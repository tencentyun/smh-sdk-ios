//
//  QCloudSMHUpdateGroupInviteInfoRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUpdateGroupInviteInfoRequest.h"

@implementation QCloudSMHUpdateGroupInviteInfoRequest

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

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (!self.code) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[code] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
 
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/invite/%@/edit/%@",self.organizationId,self.code]]];
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    if (self.enabled) {
        [params setValue:self.enabled forKey:@"enabled"];
    }
    
    if (self.authRoleId) {
        [params setValue:@(self.authRoleId.integerValue) forKey:@"authRoleId"];
    }
    
    if (self.allowExternalUser) {
        [params setValue:self.allowExternalUser forKey:@"allowExternalUser"];
    }
    
    if (self.groupRole > 0) {
        NSString * role = self.groupRole == QCloudSMHGroupRoleUser ? @"user" : @"groupAdmin";
        [params setValue:role forKey:@"groupRole"];
    }
    
    if (self.expireTime) {
        [params setValue:self.expireTime forKey:@"expireTime"];
    }

    
    self.requestData.directBody = [params qcloud_modelToJSONData];
    return YES;
}

@end
