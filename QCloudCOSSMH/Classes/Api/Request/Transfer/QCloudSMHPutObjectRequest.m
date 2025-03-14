//
//  QCloudSMHPutObjectRequest.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHPutObjectRequest.h"

@implementation QCloudSMHPutObjectRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHInitUploadInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    [__pathComponents addObject:self.filePath];
    
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    if (self.fileSize) {
        [self.requestData setQueryStringParamter:self.fileSize withKey:@"filesize"];
    }
    self.requestData.URIComponents = __pathComponents;
   
    NSMutableDictionary * params = [NSMutableDictionary new];

    if (self.fullHash) {
        [params setObject:self.fullHash forKey:@"fullHash"];
    }
    
    if (self.beginningHash) {
        [params setObject:self.beginningHash forKey:@"beginningHash"];
    }
    
    if (self.fileSize) {
        [params setObject:self.fileSize forKey:@"size"];
    }
    if (self.labels) {
        [params setObject:self.labels forKey:@"labels"];
    }
    if (self.category) {
        [params setObject:self.category forKey:@"category"];
    }
    if (self.localCreationTime) {
        [params setObject:self.localCreationTime forKey:@"localCreationTime"];
    }
    if (self.localModificationTime) {
        [params setObject:self.localModificationTime forKey:@"localModificationTime"];
    }
    if (params.allKeys.count > 0) {
        NSData * data = [params qcloud_modelToJSONData];
        self.requestData.directBody = data;
    }
    
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }

    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
