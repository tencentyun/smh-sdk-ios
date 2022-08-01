//
//  QCloudSMHUpdateOrgInviteInfoRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUpdateOrgInviteInfoRequest.h"

@implementation QCloudSMHUpdateOrgInviteInfoRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.role = QCloudSMHGroupRoleUser;
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
    
    if (self.role !=QCloudSMHGroupRoleUser && self.role != QCloudSMHGroupRoleAdmin) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[role] is user|admin, it must have some value. please check it"]];
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
    
    if (self.role != -1) {
        [params setValue:self.role == QCloudSMHGroupRoleUser ? @"user" : @"admin" forKey:@"role"];
    }
    
    if (self.expireTime) {
        [params setValue:self.expireTime forKey:@"expireTime"];
    }
    self.requestData.directBody = [params qcloud_modelToJSONData];
    return YES;
}

@end
