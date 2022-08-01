//
//  QCloudSMHBatchCopyRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchCopyRequest.h"

@implementation QCloudSMHBatchCopyRequest
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
        QCloudURLFuseWithURLEncodeParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHBatchResult.class)

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/batch"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    if (self.shareAccessToken) {
        [self.requestData setQueryStringParamter:self.shareAccessToken withKey:@"share_access_token"];
    }
    
    NSMutableArray * array = [NSMutableArray new];
    for (QCloudSMHBatchCopyInfo * info in self.batchInfos) {
        NSMutableDictionary * mdic = [info qcloud_modelToJSONObject];
        [mdic setObject:QCloudSMHConflictStrategyByTransferToString(info.conflictStrategy) forKey:@"conflictResolutionStrategy"];
        [mdic removeObjectForKey:@"conflictStrategy"];
        [array addObject:mdic];
    }
    NSData * data = [array qcloud_modelToJSONData];
    self.requestData.directBody = data;
    self.requestData.URIMethod = @"copy";
    
    return YES;
}
- (void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}



@end
