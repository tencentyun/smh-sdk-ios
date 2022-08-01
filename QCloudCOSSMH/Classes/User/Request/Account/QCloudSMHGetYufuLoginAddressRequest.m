//
//  QCloudSMHGetYufuLoginAddressRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/7/06.
//

#import "QCloudSMHGetYufuLoginAddressRequest.h"
@implementation QCloudSMHGetYufuLoginAddressRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.autoRedirect = YES;
    return self;
}

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseRedirectBlock
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (self.type == QCloudSMHYufuLoginNone) {
        if (error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[type] is QCloudSMHGetYufuLoginNone, it must have some value. please check it"]];
        }
        return NO;
    }
    
    if (!self.tenantName && !self.domain) {
        if (error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[tenantName and domain] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/sign-in/yufu-endpoint/"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.domain) {
        [__pathComponents addObject:self.domain];
    }else if(self.tenantName){
        [__pathComponents addObject:self.tenantName];
    }
    
    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setQueryStringParamter:@"ios" withKey:@"from"];
    if (self.type == QCloudSMHYufuLoginDomain) {
        [self.requestData setQueryStringParamter:@"domain" withKey:@"type"];
    }else if (self.type == QCloudSMHYufuLoginTenantName){
        [self.requestData setQueryStringParamter:@"tenantName" withKey:@"type"];
    }

    [self.requestData setQueryStringParamter:self.autoRedirect?@"true":@"false" withKey:@"auto_redirect"];
    
    return YES;
}

- (void)setFinishBlock:(void (^)(NSString * _Nullable location, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
