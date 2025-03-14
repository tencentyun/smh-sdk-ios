//
//  QCloudSMHSpaceAuthorizeRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHSpaceAuthorizeRequest.h"

@implementation QCloudSMHSpaceAuthorizeRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/authority"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"authorize-space"];
    
    self.requestData.URIComponents = __pathComponents;

    NSMutableDictionary * params = [NSMutableDictionary new];
    if(self.authorizeSpaceId){
        [params setObject:self.authorizeSpaceId forKey:@"spaceId"];
    }
    
    if(self.name){
        [params setObject:self.name forKey:@"name"];
    }
    
    if(self.roleId){
        [params setObject:@(self.roleId) forKey:@"roleId"];
    }

    NSData * data = [@{@"authorizeTo":params} qcloud_modelToJSONData];
    self.requestData.directBody  = data;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

@end
