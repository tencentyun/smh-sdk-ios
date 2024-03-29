//
//  QCloudSMHWXLoginRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHWXLoginRequest.h"

@implementation QCloudSMHWXLoginRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHOrganizationsInfo class])
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
        if (error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[code] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/verify-wechat-code"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.code];
    
    if(self.deviceId){
        [self.requestData setQueryStringParamter:self.deviceId withKey:@"device_id"];
    }
    if(self.phoneNumber){
        [self.requestData setQueryStringParamter:self.phoneNumber withKey:@"phone_number"];
    }
    if(self.countryCode){
        [self.requestData setQueryStringParamter:self.countryCode withKey:@"country_code"];
    }
    if(self.smsCode){
        [self.requestData setQueryStringParamter:self.smsCode withKey:@"sms_code"];
    }
    
    if(self.domain){
        [self.requestData setQueryStringParamter:self.domain withKey:@"domain"];
    }
    
    if(self.inviteCode){
        [self.requestData setQueryStringParamter:self.inviteCode withKey:@"invite_code"];
    }
    
    [self.requestData setQueryStringParamter:@"mobile" withKey:@"client"];
    
    if (QCloudSMHLoginAuthTypeTransferToString(self.authType).length > 0) {
        [self.requestData setQueryStringParamter:QCloudSMHLoginAuthTypeTransferToString(self.authType) withKey:@"auth_type"];
    }
    
    [self.requestData setQueryStringParamter:@(self.allowEdition).stringValue withKey:@"allow_edition"];
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
