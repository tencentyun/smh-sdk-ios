//
//  QCloudSMHVerifyShareCodeRequest.m
//  Pods
//
//  Created by garenwang on 2021/11/25.
//

#import "QCloudSMHVerifyShareCodeRequest.h"

@implementation QCloudSMHVerifyShareCodeRequest
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
        QCloudURLFuseURIMethodASURLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHVerifyShareCodeResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.shareToken || ([self.shareToken isKindOfClass:NSString.class] && ((NSString *)self.shareToken).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[shareToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/share/verify-extraction-code"]];
    
    if (self.extractionCode) {
        [self.requestData setQueryStringParamter:self.extractionCode withKey:@"extraction_code"];
    }
    
    if (self.userToken) {
        [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    }
    
    self.requestData.serverURL = serverHost.absoluteString;
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.shareToken];
    self.requestData.URIComponents = __pathComponents;
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHVerifyShareCodeResult * _Nullable, NSError * _Nullable))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
