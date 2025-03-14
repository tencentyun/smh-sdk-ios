//
//  QCloudDeleteFavoriteGroupRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudDeleteFavoriteGroupRequest.h"

@implementation QCloudDeleteFavoriteGroupRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"delete";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (!self.favoriteGroupId ) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[name] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"user/v1/favorite-group/%@",self.organizationId]];
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.favoriteGroupId];
    self.requestData.URIComponents = __pathComponents;
    self.requestData.serverURL = serverHost.absoluteString;
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    return YES;
}
@end
