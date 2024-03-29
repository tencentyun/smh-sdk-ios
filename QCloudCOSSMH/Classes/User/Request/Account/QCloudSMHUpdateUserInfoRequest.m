//
//  QCloudSMHUpdateUserInfoRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUpdateUserInfoRequest.h"

@implementation QCloudSMHUpdateUserInfoRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
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
    
    if (!self.userId) {
        *error = [NSError
            qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                         message:[NSString stringWithFormat:
                                               @"InvalidArgument:paramter[userId] is invalid (nil), it must have some value. please check it"]];
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/user"]];
    
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:self.userId];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    NSMutableDictionary * body = [NSMutableDictionary new];
    [body setValue:self.nickname forKey:@"nickname"];
    [body setValue:self.email forKey:@"email"];
    if (self.role > 0) {
        [body setValue:QCloudSMHOrgUserRoleTypeTransferToString(self.role) forKey:@"role"];
    }
    if (self.enabled) {
        [body setValue:self.enabled forKey:@"enabled"];
    }
    if(self.comment){
        [body setValue:self.comment forKey:@"comment"];
    }
    
    if(self.allowPersonalSpace){
        [body setValue:self.allowPersonalSpace forKey:@"allowPersonalSpace"];
    }
    
    if(self.allowChangeNickname){
        [body setValue:self.allowChangeNickname forKey:@"allowChangeNickname"];
    }
    
    NSData * data = [body qcloud_modelToJSONData];
    self.requestData.directBody = data;
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

@end
