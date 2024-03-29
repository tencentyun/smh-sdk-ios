//
//  QCloudSMHSSOLoginRedirectRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHSSOLoginRedirectRequest.h"

@implementation QCloudSMHSSOLoginRedirectRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/sso-login-redirect"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.corpId){
        [__pathComponents addObject:self.corpId];
    }
    [self.requestData setQueryStringParamter:(self.autoRedirect)?@"true":@"false" withKey:@"auto_redirect"];
    
    if(self.from){
        [self.requestData setQueryStringParamter:self.from withKey:@"from"];
    }else{
        [self.requestData setQueryStringParamter:@"ios" withKey:@"from"];
    }
    
    if(self.customState){
        [self.requestData setQueryStringParamter:self.customState withKey:@"custom_state"];
    }
    
    if(self.SSOWay){
        [self.requestData setQueryStringParamter:self.SSOWay withKey:@"sso_way"];
    }
    
    if(self.domain){
        [self.requestData setQueryStringParamter:self.domain withKey:@"domain"];
    }
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}
-(void)setFinishBlock:(void (^ _Nullable)(NSString * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
