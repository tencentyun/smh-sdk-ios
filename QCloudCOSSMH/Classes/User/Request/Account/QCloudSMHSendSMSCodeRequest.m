//
//  QCloudSMHSemdSMSCode.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHSendSMSCodeRequest.h"

NSString * QCloudSMHSendSMSCodeTypeTransferToString( QCloudSMHSendSMSCodeType type){
    switch (type) {
        case QCloudSMHSendSMSCodeSignIn:
            return @"sign-in";
        case QCloudSMHSendSMSCodeBindMeetingPhone:
            return @"bind-meeting-phone";
        case QCloudSMHSendSMSCodeBindWechatPhone:
            return @"bind-wechat-phone";
        case QCloudSMHSendSMSCodeBindYufuPhone:
            return @"bind-yufu-phone";
        default:
            return @"sign-in";
        }
}

@implementation QCloudSMHSendSMSCodeRequest

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
        QCloudURLFuseWithURLEncodeParamters,
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
    if (!self.countryCode || ([self.countryCode isKindOfClass:NSString.class] && ((NSString *)self.countryCode).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    if (!self.phone || ([self.phone isKindOfClass:NSString.class] && ((NSString *)self.phone).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[phone] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/send-sms-code"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.countryCode];
    [__pathComponents addObject:self.phone];
    
    [self.requestData setQueryStringParamter:QCloudSMHSendSMSCodeTypeTransferToString(self.type) withKey:@"type"];
    
    if (self.captchaTicket) {
        [self.requestData setQueryStringParamter:self.captchaTicket withKey:@"captcha_ticket"];
    }
    
    if (self.captchaRandstr) {
        [self.requestData setQueryStringParamter:self.captchaRandstr withKey:@"captcha_randstr"];
    }
    
    if(self.pf != nil){
        [self.requestData setQueryStringParamter:self.pf withKey:@"pf"];
    }
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}


@end
