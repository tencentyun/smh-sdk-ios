//
//  QCloudSMHExternalURLDownloadRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2025/01/27.
//

#import "QCloudSMHExternalURLDownloadRequest.h"

@implementation QCloudSMHExternalURLDownloadRequest

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认超时时间
        self.timeoutInterval = 60;
        self.forbidenWirteToCahce = YES;
    }
    return self;
}

#pragma mark - Override: 配置响应解析

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer
                responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    // 请求序列化：无特殊处理
    requestSerializer.HTTPMethod = @"get";
    
    NSArray *customRequestSerilizers = @[ QCloudURLFuseSimple, QCloudURLFuseWithURLEncodeParamters ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseAppendHeadersSerializerBlock,
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
}

- (void)loadConfigureBlock {
    __weak typeof(self) weakSelf = self;
    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
        [weakSelf configureReuqestSerializer:requestSerializer responseSerializer:responseSerializer];
    }];
}

#pragma mark - Override: 跳过 requestData 构建

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    [super buildRequestData:error];
    // 不调用 super，避免 SMH/COS 特有参数校验
    if (!self.sourceURL) {
        if (error) {
            *error = [NSError errorWithDomain:QCloudErrorDomain
                                         code:QCloudNetworkErrorCodeParamterInvalid
                                     userInfo:@{NSLocalizedDescriptionKey: @"sourceURL is required"}];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Override: 直接构建外部 URL 请求

- (NSURLRequest *)buildURLRequest:(NSError *__autoreleasing *)error {
    if (![self buildRequestData:error]) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.sourceURL];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = self.timeoutInterval > 0 ? self.timeoutInterval : 60;
    
    // 添加 Connection: keep-alive，避免服务器过早关闭连接导致 -1005 错误
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    // 添加自定义 Header
    [self.customHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    // Range 支持（用于分块下载）
    if (self.rangeHeader) {
        [request setValue:self.rangeHeader forHTTPHeaderField:@"Range"];
    }
    
    return request;
}

#pragma mark - Override: 跳过签名

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest
                          error:(NSError *__autoreleasing *)error {
    // 第三方 URL 不需要 COS/SMH 签名，直接返回 YES
    return YES;
}

@end
