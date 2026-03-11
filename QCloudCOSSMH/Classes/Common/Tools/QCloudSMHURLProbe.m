//
//  QCloudSMHURLProbe.m
//  QCloudCOSSMH
//
//  Created by mochadu
//

#import "QCloudSMHURLProbe.h"

#import <QCloudCore/QCloudCore.h>

/**
 * 探测请求类型
 */
typedef NS_ENUM(NSInteger, QCloudSMHProbeRequestType) {
    QCloudSMHProbeRequestTypeNone = 0,
    QCloudSMHProbeRequestTypeHEAD,
    QCloudSMHProbeRequestTypeGET
};

@interface QCloudSMHURLProbe () <NSURLSessionDataDelegate>

@property (nonatomic, strong, readwrite) NSURL *sourceURL;
@property (nonatomic, copy, readwrite, nullable) NSDictionary<NSString *, NSString *> *sourceHeaders;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, nullable) NSURLSessionDataTask *currentTask;
@property (nonatomic, assign) BOOL isCancelled;

// 探测过程中的中间结果
@property (nonatomic, assign) int64_t remoteFileSize;
@property (nonatomic, assign) BOOL hasContentLength;
@property (nonatomic, assign) BOOL supportsRange;
@property (nonatomic, copy, nullable) NSString *contentType;

// 当前探测请求类型
@property (nonatomic, assign) QCloudSMHProbeRequestType currentRequestType;
// 探测回调（用于 delegate 模式）
@property (nonatomic, copy, nullable) void (^probeCompletion)(BOOL success, NSError *_Nullable error);
// 标记是否已处理过响应（避免重复回调）
@property (nonatomic, assign) BOOL hasHandledResponse;

@end

@implementation QCloudSMHURLProbe

#pragma mark - Initialization

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
                          headers:(nullable NSDictionary<NSString *, NSString *> *)headers {
    self = [super init];
    if (self) {
        _sourceURL = sourceURL;
        _sourceHeaders = [headers copy];
        _timeout = 30.0;
        _remoteFileSize = -1;
        _hasContentLength = NO;
        _supportsRange = NO;
        _hasHandledResponse = NO;
        
        // 使用 ephemeral 配置，避免连接复用导致的 -1005 错误
        // 因为探测过程中会主动取消请求，复用的连接可能处于不稳定状态
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        config.timeoutIntervalForRequest = _timeout;
        // 禁用 HTTP 管道化，避免请求被错误地复用
        config.HTTPShouldUsePipelining = NO;
        // 每个请求使用独立连接
        config.HTTPMaximumConnectionsPerHost = 1;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

#pragma mark - QCloudSMHURLProbing

- (void)probeWithCompletion:(QCloudSMHURLProbeCompletionHandler)completion {
    if (self.isCancelled) {
        NSError *error = [self errorWithCode:QCloudNetworkErrorCodeCanceled
                                     message:[NSString stringWithFormat:@"URL 探测已取消: %@", self.sourceURL]];
        completion(nil, error);
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self probeWithHEAD:^(BOOL success, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (strongSelf.isCancelled) {
            NSError *cancelError = [strongSelf errorWithCode:QCloudNetworkErrorCodeCanceled
                                                     message:[NSString stringWithFormat:@"URL 探测已取消: %@", strongSelf.sourceURL]];
            completion(nil, cancelError);
            return;
        }
        
        if (success) {
            [strongSelf finishProbeWithCompletion:completion];
        } else {
            // HEAD 失败，降级到 GET 探测
            QCloudLogInfo(@"URL 探测：HEAD 请求失败，降级到 GET 探测: %@, error: %@", strongSelf.sourceURL, error.localizedDescription);
            [strongSelf probeWithGET:^(BOOL getSuccess, NSError *getError) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) {
                    return;
                }
                
                if (strongSelf.isCancelled) {
                    NSError *cancelError = [strongSelf errorWithCode:QCloudNetworkErrorCodeCanceled
                                                             message:[NSString stringWithFormat:@"URL 探测已取消: %@", strongSelf.sourceURL]];
                    completion(nil, cancelError);
                    return;
                }
                
                if (getSuccess) {
                    [strongSelf finishProbeWithCompletion:completion];
                } else {
                    // GET 也失败，返回探测失败错误
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:@"URL 探测失败，HEAD 和 GET 请求均失败: %@", strongSelf.sourceURL];
                    userInfo[@"sourceURL"] = strongSelf.sourceURL;
                    if (error) {
                        userInfo[@"headError"] = error;
                    }
                    if (getError) {
                        userInfo[@"getError"] = getError;
                    }
                    
                    NSError *probeError = [strongSelf errorWithCode:QCloudNetworkErrorUnsupportOperationError
                                                            message:@""
                                                           userInfo:userInfo];
                    completion(nil, probeError);
                }
            }];
        }
    }];
}

- (void)cancel {
    self.isCancelled = YES;
    [self.currentTask cancel];
}

#pragma mark - Private Methods - HEAD Probe

- (void)probeWithHEAD:(void (^)(BOOL success, NSError *_Nullable error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.sourceURL];
    request.HTTPMethod = @"HEAD";
    request.timeoutInterval = self.timeout;
    
    // 添加自定义请求头
    [self.sourceHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    // 保存回调和请求类型，用于 delegate 模式
    self.probeCompletion = completion;
    self.currentRequestType = QCloudSMHProbeRequestTypeHEAD;
    self.hasHandledResponse = NO;
    
    // 使用 delegate 模式创建任务
    self.currentTask = [self.session dataTaskWithRequest:request];
    [self.currentTask resume];
}

#pragma mark - Private Methods - GET Probe

- (void)probeWithGET:(void (^)(BOOL success, NSError *_Nullable error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.sourceURL];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = self.timeout;
    
    // 只请求第1个字节，用于探测
    [request setValue:@"bytes=0-0" forHTTPHeaderField:@"Range"];
    
    // 添加自定义请求头
    [self.sourceHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    // 保存回调和请求类型，用于 delegate 模式
    self.probeCompletion = completion;
    self.currentRequestType = QCloudSMHProbeRequestTypeGET;
    self.hasHandledResponse = NO;
    
    // 使用 delegate 模式创建任务（不使用 completionHandler）
    // 这样可以在 URLSession:dataTask:didReceiveResponse:completionHandler: 中
    // 收到响应头后立即取消，避免下载整个文件
    self.currentTask = [self.session dataTaskWithRequest:request];
    [self.currentTask resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 检查是否是当前正在处理的任务
    if (dataTask != self.currentTask) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    // 检查是否有待处理的探测请求
    if (!self.probeCompletion || self.currentRequestType == QCloudSMHProbeRequestTypeNone) {
        completionHandler(NSURLSessionResponseAllow);
        return;
    }
    
    // 防止重复处理
    if (self.hasHandledResponse) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    self.hasHandledResponse = YES;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    QCloudLogInfo(@"%@ %@ 探测收到响应: statusCode=%ld, headers=%@",httpResponse.URL,
                  self.currentRequestType == QCloudSMHProbeRequestTypeHEAD ? @"HEAD" : @"GET",
                  (long)httpResponse.statusCode, httpResponse.allHeaderFields);
    
    // 检查取消状态
    if (self.isCancelled) {
        NSError *cancelError = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:NSURLErrorCancelled
                                               userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"URL 探测已取消: %@", self.sourceURL]}];
        completionHandler(NSURLSessionResponseCancel);
        [self invokeProbeCompletionWithSuccess:NO error:cancelError];
        return;
    }
    
    // 根据请求类型处理响应
    if (self.currentRequestType == QCloudSMHProbeRequestTypeHEAD) {
        [self handleHEADResponse:httpResponse completionHandler:completionHandler];
    } else {
        [self handleGETResponse:httpResponse completionHandler:completionHandler];
    }
}

- (void)handleHEADResponse:(NSHTTPURLResponse *)httpResponse
         completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 检查 HTTP 状态码
    if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
        NSError *httpError = [self errorWithCode:QCloudNetworkErrorCodeDomainInvalid
                                         message:[NSString stringWithFormat:@"HEAD 请求返回非成功状态码: %ld, URL: %@", (long)httpResponse.statusCode, self.sourceURL]
                                        userInfo:@{@"statusCode": @(httpResponse.statusCode), @"sourceURL": self.sourceURL}];
        // 先取消请求，再回调（避免回调中启动 GET 请求后被 cancel 影响）
        completionHandler(NSURLSessionResponseCancel);
        [self invokeProbeCompletionWithSuccess:NO error:httpError];
        return;
    }
    
    // 提取元信息
    [self extractMetadataFromResponse:httpResponse];
    
    // HEAD 请求本身不会有 body，但仍取消以确保资源释放
    completionHandler(NSURLSessionResponseCancel);
    
    // HEAD 请求成功
    [self invokeProbeCompletionWithSuccess:YES error:nil];
}

- (void)handleGETResponse:(NSHTTPURLResponse *)httpResponse
        completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 检查 HTTP 状态码
    if (httpResponse.statusCode != 200 && httpResponse.statusCode != 206) {
        NSError *httpError = [self errorWithCode:QCloudNetworkErrorCodeDomainInvalid
                                         message:[NSString stringWithFormat:@"GET 探测请求返回非成功状态码: %ld, URL: %@", (long)httpResponse.statusCode, self.sourceURL]
                                        userInfo:@{@"statusCode": @(httpResponse.statusCode), @"sourceURL": self.sourceURL}];
        completionHandler(NSURLSessionResponseCancel);
        [self invokeProbeCompletionWithSuccess:NO error:httpError];
        return;
    }
    
    // 根据状态码处理
    if (httpResponse.statusCode == 206) {
        // 支持 Range 请求，从 Content-Range 解析总大小
        NSString *contentRange = httpResponse.allHeaderFields[@"Content-Range"];
        if (contentRange) {
            [self parseContentRange:contentRange];
            self.supportsRange = YES;
        }
        QCloudLogInfo(@"GET 探测: 服务器支持 Range，返回 206, URL: %@", self.sourceURL);
    } else {
        // 状态码 200，不支持 Range
        // 重要：服务器忽略了 Range 头，会返回整个文件
        // 我们只需要响应头信息，立即取消以避免下载整个文件
        self.supportsRange = NO;
        NSString *contentLengthStr = httpResponse.allHeaderFields[@"Content-Length"];
        if (contentLengthStr) {
            int64_t contentLength = [contentLengthStr longLongValue];
            if (contentLength > 0) {
                self.remoteFileSize = contentLength;
                self.hasContentLength = YES;
            }
        }
        QCloudLogInfo(@"GET 探测: 服务器不支持 Range，返回 200，文件大小: %lld bytes, URL: %@", self.remoteFileSize, self.sourceURL);
    }
    
    // 提取其他元信息
    self.contentType = httpResponse.allHeaderFields[@"Content-Type"];
    
    // 关键：取消后续数据接收，避免下载整个文件
    // 对于不支持 Range 的服务器（返回 200），这里会阻止下载整个文件内容
    completionHandler(NSURLSessionResponseCancel);
    
    // 探测成功，回调
    [self invokeProbeCompletionWithSuccess:YES error:nil];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    // 检查是否是当前正在处理的任务
    // 避免 HEAD task 的 didCompleteWithError 影响已启动的 GET task
    if (task != self.currentTask) {
        return;
    }
    
    // 检查是否有待处理的探测请求
    if (!self.probeCompletion || self.currentRequestType == QCloudSMHProbeRequestTypeNone) {
        return;
    }
    
    // 如果已经处理过响应，忽略（NSURLSessionResponseCancel 会触发取消错误）
    if (self.hasHandledResponse) {
        return;
    }
    
    [self invokeProbeCompletionWithSuccess:!error error:error];
}

#pragma mark - Private Methods - Probe Completion Helper

- (void)invokeProbeCompletionWithSuccess:(BOOL)success error:(NSError *)error {
    void (^completion)(BOOL, NSError *) = self.probeCompletion;
    self.probeCompletion = nil;  // 清空，防止重复调用
    self.currentRequestType = QCloudSMHProbeRequestTypeNone;
    
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success, error);
        });
    }
}

#pragma mark - Private Methods - Metadata Extraction

- (void)extractMetadataFromResponse:(NSHTTPURLResponse *)response {
    NSDictionary *headers = response.allHeaderFields;
    
    // Content-Length
    NSString *contentLengthStr = headers[@"Content-Length"];
    if (contentLengthStr) {
        int64_t contentLength = [contentLengthStr longLongValue];
        if (contentLength > 0) {
            self.remoteFileSize = contentLength;
            self.hasContentLength = YES;
        } else {
            self.remoteFileSize = -1;
            self.hasContentLength = NO;
        }
    } else {
        self.remoteFileSize = -1;
        self.hasContentLength = NO;
    }
    
    // Accept-Ranges
    NSString *acceptRanges = headers[@"Accept-Ranges"];
    self.supportsRange = [acceptRanges.lowercaseString isEqualToString:@"bytes"];
    
    // Content-Type
    self.contentType = headers[@"Content-Type"];
}

- (void)parseContentRange:(NSString *)contentRange {
    // 格式: bytes 0-0/12345678 或 bytes 0-0/*
    NSError *regexError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"bytes\\s+\\d+-\\d+/(\\d+|\\*)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexError];
    
    if (regexError) {
        return;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:contentRange
                                                    options:0
                                                      range:NSMakeRange(0, contentRange.length)];
    
    if (match && match.numberOfRanges > 1) {
        NSRange totalRange = [match rangeAtIndex:1];
        if (totalRange.location != NSNotFound) {
            NSString *totalStr = [contentRange substringWithRange:totalRange];
            
            if (![totalStr isEqualToString:@"*"]) {
                int64_t totalSize = [totalStr longLongValue];
                if (totalSize > 0) {
                    self.remoteFileSize = totalSize;
                    self.hasContentLength = YES;
                } else {
                    self.remoteFileSize = -1;
                    self.hasContentLength = NO;
                }
            } else {
                // 总大小未知
                self.remoteFileSize = -1;
                self.hasContentLength = NO;
            }
        }
    }
}

#pragma mark - Private Methods - Finish

- (void)finishProbeWithCompletion:(QCloudSMHURLProbeCompletionHandler)completion {
    // 构建结果对象
    QCloudSMHURLProbeResult *result = [[QCloudSMHURLProbeResult alloc] initWithFileSize:self.remoteFileSize
                                                                      hasContentLength:self.hasContentLength
                                                                         supportsRange:self.supportsRange
                                                                           contentType:self.contentType];
    
    QCloudLogInfo(@"%@ URL 探测完成: %@",self.sourceURL, result);
    completion(result, nil);
}

#pragma mark - Private Methods - Error Helper

- (NSError *)errorWithCode:(int)code message:(NSString *)message {
    return [self errorWithCode:code message:message userInfo:nil];
}

- (NSError *)errorWithCode:(int)code
                   message:(NSString *)message
                  userInfo:(nullable NSDictionary *)additionalUserInfo {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = message;
    
    if (additionalUserInfo) {
        [userInfo addEntriesFromDictionary:additionalUserInfo];
    }
    
    return [NSError errorWithDomain:kQCloudNetworkDomain
                               code:code
                           userInfo:userInfo];
}

@end
