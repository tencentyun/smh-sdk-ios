//
//  QCloudSMHBatchDeleteRecycleObjectReqeust.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBatchDeleteRecycleObjectReqeust.h"
@implementation QCloudSMHBatchDeleteRecycleObjectReqeust



- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
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
    
    if (self.recycledItemIds.count == 0) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[recycledItemId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/recycled"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
 
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    NSData * data = [self.recycledItemIds qcloud_modelToJSONData];
    self.requestData.directBody = data;
    self.requestData.URIMethod = @"delete";
    
    return YES;
}


@end
