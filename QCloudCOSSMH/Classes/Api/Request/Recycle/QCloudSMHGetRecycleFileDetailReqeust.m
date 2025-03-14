//
//  QCloudSMHGetRecycleFileDetailReqeust.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHGetRecycleFileDetailReqeust.h"

@implementation QCloudSMHGetRecycleFileDetailReqeust



- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHRecycleObjectItemInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/recycled"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.recycledItemId) {
        [__pathComponents addObject:@(self.recycledItemId).stringValue];
    }
    self.requestData.URIMethod = @"info";
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecycleObjectItemInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
