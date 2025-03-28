//
//  QCloudSMHOffcialFreeLoginRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHOffcialFreeLoginRequest.h"

@implementation QCloudSMHOffcialFreeLoginRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
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
    
    if (!self.countryCode) {
        if (error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[countryCode] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    if (!self.phoneNumber) {
        if (error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[phoneNumber] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/register-official-free"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.countryCode];
    [__pathComponents addObject:self.phoneNumber];
    [__pathComponents addObject:self.code];
    
    if(self.deviceId){
        [self.requestData setQueryStringParamter:self.deviceId withKey:@"device_id"];
    }
    
    if(self.captchaTicket){
        [self.requestData setQueryStringParamter:self.captchaTicket withKey:@"captcha_ticket"];
    }
    
    if(self.captchaRandstr){
        [self.requestData setQueryStringParamter:self.captchaRandstr withKey:@"captcha_randstr"];
    }    

    [self.requestData setQueryStringParamter:@"mobile" withKey:@"client"];
    
    if(self.domain){
        [self.requestData setQueryStringParamter:self.domain withKey:@"domain"];
    }
    
    if(self.inviteCode){
        [self.requestData setQueryStringParamter:self.inviteCode withKey:@"invite_code"];
    }
    
    NSMutableDictionary * params = @{}.mutableCopy;
    if(self.orgName){
        [params setObject:self.orgName forKey:@"orgName"];
    }
    
    if(self.role){
        [params setObject:self.role forKey:@"role"];
    }
    
    if(self.business){
        [params setObject:self.business forKey:@"business"];
    }
    
    if(self.scale){
        [params setObject:self.scale forKey:@"scale"];
    }
    
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    self.requestData.directBody = [params qcloud_modelToJSONData];
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
