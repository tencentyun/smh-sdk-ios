//
//  QCloudSMHUpdateMessageSettingRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUpdateMessageSettingRequest.h"

@implementation QCloudSMHUpdateMessageSettingRequest
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
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/message"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"settings"];
    self.requestData.URIComponents = [__pathComponents copy];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    self.requestData.directBody = @{@"receiveMessageConfig":@{
        @"authorityAndSettingMsg":@(self.authorityAndSettingMsg),
        @"shareMsg":@(self.shareMsg),
        @"esignMsg":@(self.esignMsg),
        @"userManageMsg":@(self.userManageMsg),
        @"quotaAndRenewMsg":@(self.quotaAndRenewMsg)
    }}.qcloud_modelToJSONData;
  
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

@end
