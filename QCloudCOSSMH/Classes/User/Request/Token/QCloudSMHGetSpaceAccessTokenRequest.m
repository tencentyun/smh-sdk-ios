//
//  QCloudSMHGetSpaceAccessTokenRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/21.
//

#import "QCloudSMHGetSpaceAccessTokenRequest.h"
#import "QCloudSMHSpaceInfo.h"
@implementation QCloudSMHGetSpaceAccessTokenRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHSpaceInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.organizationId || ([self.organizationId isKindOfClass:NSString.class] && ((NSString *)self.organizationId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[organizationId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.userToken || ([self.userToken isKindOfClass:NSString.class] && ((NSString *)self.userToken).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[userToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.spaceId || ([self.spaceId isKindOfClass:NSString.class] && ((NSString *)self.spaceId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[spaceId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/space"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"token"];
    [__pathComponents addObject:self.spaceId];
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setParameter:self.userToken withKey:@"user_token"];
    
    if (self.spaceOrgId) {
        self.requestData.directBody = [@{@"spaceOrgId":@(self.spaceOrgId.integerValue)} qcloud_modelToJSONData];
    }
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpaceInfo *object, NSError * _Nullable))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
    
}
@end
