//
//  QCloudSMHGetMessageSettingRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHGetMessageSettingRequest.h"

@implementation QCloudSMHGetMessageSettingRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHMessageSetting class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
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
  
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^)(QCloudSMHMessageSetting * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
