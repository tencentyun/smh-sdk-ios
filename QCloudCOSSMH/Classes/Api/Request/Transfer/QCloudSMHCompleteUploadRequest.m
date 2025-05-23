//
//  QCloudSMHCompleteUploadRequest.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHCompleteUploadRequest.h"


@implementation QCloudSMHCompleteUploadRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHContentInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.confirmKey || ([self.confirmKey isKindOfClass:NSString.class] && ((NSString *)self.confirmKey).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[confirmKey] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    [__pathComponents addObject:self.confirmKey];

    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setQueryStringParamter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    self.requestData.URIMethod = @"confirm";

    NSMutableDictionary * params = [NSMutableDictionary new];
    if (self.crc64) {
        [params setObject:self.crc64 forKey:@"crc64"];
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
    [self.requestData setQueryStringParamter:self.withInode?@"1":@"0" withKey:@"with_inode"];
    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
