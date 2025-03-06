//
//  QCloudSMHUploadPartRequest.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHUploadPartRequest.h"


@implementation QCloudSMHUploadPartRequest
- (void)dealloc {
    
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHInitUploadInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
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
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    
    [__pathComponents addObject:self.filePath];
    
    
    self.requestData.URIMethod = @"multipart";
    
    if(self.partNumberRange && [QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        self.requestData.directBody = [@{@"partNumberRange":self.partNumberRange} qcloud_modelToJSONData];
    }
    
    if (self.fileSize) {
        [self.requestData setQueryStringParamter:self.fileSize withKey:@"filesize"];
    }

    self.requestData.URIComponents = __pathComponents;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }

    NSMutableDictionary * params = NSMutableDictionary.new;
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
        self.requestData.directBody = [params qcloud_modelToJSONData];
    }
    
    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
