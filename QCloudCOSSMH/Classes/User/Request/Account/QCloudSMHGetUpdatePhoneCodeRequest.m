//
//  QCloudSMHGetUpdatePhoneCodeRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHGetUpdatePhoneCodeRequest.h"

@implementation QCloudSMHNewPhoneInfo


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{ @"nPhoneNumber" : @"newPhoneNumber" , @"nCountryCode" : @"newCountryCode" };
}

@end

@implementation QCloudSMHGetUpdatePhoneCodeRequest

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
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHNewPhoneInfo.class)

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
    
    if (!self.userToken) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[userToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/update-phone/send-sms-code"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.countryCode];
    [__pathComponents addObject:self.phone];
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];

    self.requestData.URIComponents = __pathComponents;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

- (void)setFinishBlock:(void (^)(QCloudSMHNewPhoneInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
