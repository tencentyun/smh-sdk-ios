//
//  QCloudSMHVerifyAccountLoginRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHVerifyAccountLoginRequest.h"

@implementation QCloudSMHVerifyAccountLoginRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseWithJSONParamters,
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/verify-account-login"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.corpId){
        [__pathComponents addObject:self.corpId];
    }
    
    if(self.credential){
        [self.requestData setQueryStringParamter:self.credential withKey:@"credential"];
        [self.requestData setQueryStringParamter:@"sso" withKey:@"type"];
    }
    
    NSDictionary * body;
    if(self.accountName && self.accountPassword){
        body = @{@"accountName":self.accountName,@"accountPassword":self.accountPassword};
        [self.requestData setQueryStringParamter:@"ccount-password" withKey:@"type"];
    }
    
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
    
    if(self.SSOWay){
        [self.requestData setQueryStringParamter:self.SSOWay withKey:@"sso_way"];
    }
    
    if(self.inviteCode){
        [self.requestData setQueryStringParamter:self.inviteCode withKey:@"invite_code"];
    }
    
    if(self.ldapType){
        [self.requestData setQueryStringParamter:self.ldapType withKey:@"ldap_type"];
    }
    
    if(body){
        self.requestData.directBody = [body qcloud_modelToJSONData];
    }
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
