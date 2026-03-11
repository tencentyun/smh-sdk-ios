
#import "QCloudCOSSMHUploadPartRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import "QCloudSMHUploadPartResult.h"
#import "QCloudStreamPipeline.h"
#import "QCloudSMHExternalURLDownloadRequest.h"
#import "QCloudSMHService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudCOSSMHUploadPartRequest ()

/// 流式模式：流管道
@property (nonatomic, strong, nullable) QCloudStreamPipeline *streamPipeline;

/// 流式模式：下载请求
@property (nonatomic, strong, nullable) QCloudSMHExternalURLDownloadRequest *downloadRequest;

@end

@implementation QCloudCOSSMHUploadPartRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

        QCloudResponseAppendHeadersSerializerBlock,

        QCloudResponseObjectSerilizerBlock([QCloudSMHUploadPartResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
   
    NSURL *__serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,self.path]];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    [self.requestData setNumberParamter:@(self.partNumber) withKey:@"partNumber"];
    if (!self.uploadId || ([self.uploadId isKindOfClass:NSString.class] && ((NSString *)self.uploadId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[uploadId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    [self.requestData setParameter:self.uploadId withKey:@"uploadId"];
   
    if (self.isStreamMode) {
        // 流式模式：创建流管道，设置 inputStream 为 body
        QCloudFileOffsetBody *offsetBody = (QCloudFileOffsetBody *)self.body;
        self.streamPipeline = [[QCloudStreamPipeline alloc] initWithBufferSize:offsetBody.sliceLength];
        [self.streamPipeline open];
        
        self.requestData.directBody = self.streamPipeline.inputStream;
        // 流式模式下需要手动设置 Content-Length，否则 totalBytesExpectedToSend 会返回 -1
        if (offsetBody.sliceLength > 0) {
            [self.requestData setValue:@(offsetBody.sliceLength).stringValue forHTTPHeaderField:@"Content-Length"];
        }
    } else {
        // 本地文件模式
        self.requestData.directBody = self.body;
    }
    
    if (self.renewUploadInfo) {
        self.customHeaders = self.renewUploadInfo();
    }
    
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHUploadPartResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error {
    // 流式模式：启动下载请求
    if (self.isStreamMode) {
        [self startStreamDownload];
        return YES;
    }
    
    // 本地文件模式：检查文件是否存在
    if ([self.requestData.directBody isKindOfClass:[QCloudFileOffsetBody class]]) {
        QCloudFileOffsetBody *directBody = self.requestData.directBody;
        if (!QCloudFileExist(directBody.fileURL.path)) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"指定的上传路径不存在"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 流式上传

/// 启动流式下载
- (void)startStreamDownload {
    if (!self.isStreamMode || !self.streamPipeline) {
        return;
    }
    
    QCloudFileOffsetBody *offsetBody = (QCloudFileOffsetBody *)self.body;
    
    QCloudSMHExternalURLDownloadRequest *downloadRequest = [[QCloudSMHExternalURLDownloadRequest alloc] init];
    downloadRequest.sourceURL = offsetBody.fileURL;
    downloadRequest.customHeaders = self.customHeaders;
    downloadRequest.rangeHeader = [NSString stringWithFormat:@"bytes=%lu-%lu",
                                   (unsigned long)offsetBody.offset,
                                   (unsigned long)(offsetBody.offset + offsetBody.sliceLength - 1)];
    
    __weak typeof(self) weakSelf = self;
    __block BOOL downloadFailed = NO;
    __weak typeof(downloadRequest) weakDownloadRequest = downloadRequest;
    
    [downloadRequest setDownProcessWithDataBlock:^(int64_t bytesDownload,
                                                    int64_t totalBytesDownload,
                                                    int64_t totalBytesExpectedToDownload,
                                                    NSData * _Nullable receiveData) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.canceled || downloadFailed) return;
        
        if (receiveData) {
            NSError *writeError = nil;
            [strongSelf.streamPipeline writeData:receiveData error:&writeError];
            if (writeError) {
                downloadFailed = YES;
                [weakDownloadRequest cancel];
            }
        }
    }];
    
    [downloadRequest setFinishBlock:^(id _Nullable outputObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (error) {
            [strongSelf.streamPipeline close];
        } else {
            [strongSelf.streamPipeline closeOutput];  // 标记写入完成
        }
    }];
    
    self.downloadRequest = downloadRequest;
    [[QCloudSMHService defaultSMHService] downloadExternalURL:downloadRequest];
}

/// 清理流式上传资源
- (void)cleanupStreamResources {
    if (self.streamPipeline) {
        [self.streamPipeline close];
        self.streamPipeline = nil;
    }
    if (self.downloadRequest) {
        [self.downloadRequest cancel];
        self.downloadRequest = nil;
    }
}

- (void)cancel {
    [self cleanupStreamResources];
    [super cancel];
}

- (void)dealloc {
    [self cleanupStreamResources];
}

@end

NS_ASSUME_NONNULL_END
