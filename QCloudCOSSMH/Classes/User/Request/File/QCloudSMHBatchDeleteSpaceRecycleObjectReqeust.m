//
//  QCloudSMHBatchDeleteSpaceRecycleObjectReqeust.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBatchDeleteSpaceRecycleObjectReqeust.h"
@implementation QCloudSMHBatchDeleteSpaceRecycleObjectReqeust



- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/recycled"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    
    [__pathComponents addObject:self.organizationId];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    NSData * data = [@{@"recycledItems":self.recycledItems,@"withAllGroups":@(self.withAllGroups),@"withAllTeams":@(self.withAllTeams)} qcloud_modelToJSONData];
    self.requestData.directBody = data;
    self.requestData.URIMethod = @"delete";
    
    return YES;
}


@end
