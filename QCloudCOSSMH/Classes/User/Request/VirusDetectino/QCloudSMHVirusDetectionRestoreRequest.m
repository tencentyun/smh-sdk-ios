//
//  QCloudSMHVirusDetectionRestoreRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHVirusDetectionRestoreRequest.h"


@implementation QCloudSMHVirusDetectionRestoreRequest
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
    
    if (!self.restoreItems) {
        *error = [NSError
            qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                         message:[NSString stringWithFormat:
                                               @"InvalidArgument:paramter[restoreItems] is invalid (nil), it must have some value. please check it"]];
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/virus-detection"]];
    
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"restore"];
    self.requestData.URIComponents = __pathComponents;
    
    self.requestData.directBody = @{@"restoreItems":self.restoreItems}.qcloud_modelToJSONData;
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

@end
