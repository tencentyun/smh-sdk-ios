//
//  QCloudSMHDeleteHistoryVersionRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHDeleteHistoryVersionRequest.h"

@implementation QCloudSMHDeleteHistoryVersionRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
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
    


    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory-history"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"delete"];
    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    NSData *data =  [self.historyIds qcloud_modelToJSONData] ;
    self.requestData.directBody = data;

    
    return YES;
}


@end
