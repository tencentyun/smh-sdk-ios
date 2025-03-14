//
//  QCloudSMHBatchMoveRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchMoveRequest.h"

@implementation QCloudSMHBatchMoveRequest


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
    
    NSMutableArray * array = [NSMutableArray new];
    for (QCloudSMHBatchMoveInfo * info in self.batchInfos) {
        NSMutableDictionary * mdic = [info qcloud_modelToJSONObject];
        [mdic setObject:QCloudSMHConflictStrategyByTransferToString(info.conflictStrategy) forKey:@"conflictResolutionStrategy"];
        [mdic removeObjectForKey:@"conflictStrategy"];
        [mdic setObject:@(info.moveAuthority) forKey:@"moveAuthority"];
        [array addObject:mdic];
    }
    NSData * data = [array qcloud_modelToJSONData];
    
    self.requestData.directBody = data;
    self.requestData.URIMethod = @"move";
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
