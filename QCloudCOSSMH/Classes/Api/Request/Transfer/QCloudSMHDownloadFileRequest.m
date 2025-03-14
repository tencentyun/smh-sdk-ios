//
//  QCloudSMHDownloadFileRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHDownloadFileRequest.h"
#import "QCloudSMHContentListInfo.h"
@implementation QCloudSMHDownloadFileRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseDataAppendHeadersSerializerBlock,

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.filePath || ([self.filePath isKindOfClass:NSString.class] && ((NSString *)self.filePath).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[filePath] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (self.localCacheDownloadOffset) {
        self.range = [NSString stringWithFormat:@"bytes=%lld-", self.localCacheDownloadOffset];
    }
    
    if (self.range) {
        [self.requestData setValue:self.range forHTTPHeaderField:@"Range"];
    }
    
    if (self.historVersionId > 0) {
        [self.requestData setQueryStringParamter:@(self.historVersionId).stringValue withKey:@"history_id"];
    }
    [self.requestData setQueryStringParamter:QCloudSMHPurposeTypeTransferToString(self.purpose) withKey:@"purpose"];
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath){
        [__pathComponents addObject:self.filePath];
    }
    //这里不能设置host，因为请求是重定向到 cos的，这样会导致重定向后的request的host有问题，导致400
//    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (NSURLSessionResponseDisposition)reciveResponse:(NSURLResponse *)response {
    if (self.responseHeader) {
        NSHTTPURLResponse * httpRespo = (NSHTTPURLResponse *)response;
        self.responseHeader(httpRespo.allHeaderFields);
    }
    return NSURLSessionResponseAllow;
}

- (void)setFinishBlock:(void (^)(id _Nonnull result, NSError *_Nonnull error))finishBlock {
    if (finishBlock) {
        QCloudWeakSelf(self);
        [super setFinishBlock:^(id outputObject, NSError *error) {
            QCloudStrongSelf(self);
            if ([strongself respondsToSelector:NSSelectorFromString(@"downloadingTempURL")]) {
                NSError * lError;
                NSURL * downloadingTempURL = [strongself performSelector:NSSelectorFromString(@"downloadingTempURL")];
                if (QCloudFileExist(downloadingTempURL.relativePath)) {
                    if (QCloudFileExist(strongself.downloadingURL.relativePath)) {
                        QCloudRemoveFileByPath(strongself.downloadingURL.relativePath);
                    }
                    QCloudMoveFile(downloadingTempURL.relativePath, strongself.downloadingURL.relativePath, &lError);
                }
            }
            finishBlock(outputObject,error);
        }];
    }
}

@end
