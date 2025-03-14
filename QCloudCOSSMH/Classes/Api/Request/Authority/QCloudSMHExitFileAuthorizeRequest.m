//
//  QCloudSMHExitFileAuthorizeRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHExitFileAuthorizeRequest.h"

@implementation QCloudSMHExitFileAuthorizeRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/authority"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"authorize"];
    
    if (!self.dirPath) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[dirPath] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    if (self.authorizeTo.count == 0) {
        if (error != NULL) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                      message:[NSString stringWithFormat:
                                               @"InvalidArgument:paramter[authorizeTo] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    
    [__pathComponents addObject:self.dirPath];
    
    self.requestData.URIComponents = __pathComponents;
    self.requestData.URIMethod = @"exit";
    NSData * data = [@{@"authorizeTo":self.authorizeTo} qcloud_modelToJSONData];
    self.requestData.directBody  = data;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

@end
