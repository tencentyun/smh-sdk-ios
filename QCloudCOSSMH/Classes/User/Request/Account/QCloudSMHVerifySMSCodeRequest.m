//
//  QCloudSMHVerifySMSCode.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHVerifySMSCodeRequest.h"

@implementation QCloudSMHVerifySMSCodeRequest
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
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHOrganizationsInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.countryCode || ([self.countryCode isKindOfClass:NSString.class] && ((NSString *)self.countryCode).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[countryCode] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.phone || ([self.phone isKindOfClass:NSString.class] && ((NSString *)self.phone).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[phone] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
 
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/verify-sms-code"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.countryCode];
    [__pathComponents addObject:self.phone];
    if(self.code){
        [__pathComponents addObject:self.code];
    }
    if(self.deviceID){
        [self.requestData setQueryStringParamter:self.deviceID withKey:@"device_id"];
    }
    
    if(self.clientVersion){
        [self.requestData setQueryStringParamter:self.clientVersion withKey:@"client_version"];
    }
    
    if(self.pf != QCloudSMHChannelFlagNone){
        [self.requestData setQueryStringParamter:QCloudSMHChannelFlagTransferToString(self.pf) withKey:@"pf"];
    }
    
    [self.requestData setQueryStringParamter:@"mobile" withKey:@"client"];
    
    if(self.domain){
        [self.requestData setQueryStringParamter:self.domain withKey:@"domain"];
    }
    
    if(self.inviteCode){
        [self.requestData setQueryStringParamter:self.inviteCode withKey:@"invite_code"];
    }
    
    if (self.captchaTicket) {
        [self.requestData setQueryStringParamter:self.captchaTicket withKey:@"captcha_ticket"];
    }
    
    if (self.captchaRandstr) {
        [self.requestData setQueryStringParamter:self.captchaRandstr withKey:@"captcha_randstr"];
    }
    
    [self.requestData setQueryStringParamter:@(self.allowEdition).stringValue withKey:@"allow_edition"];
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
