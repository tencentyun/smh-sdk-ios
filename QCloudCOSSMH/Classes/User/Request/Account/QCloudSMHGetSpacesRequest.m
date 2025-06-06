//
//  QCloudSMHGetSpacesRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/16.
//

#import "QCloudSMHGetSpacesRequest.h"

@implementation QCloudSMHGetSpacesRequest




- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHSpacesSizeInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/space/%@?user_token=%@",self.organizationId,self.userToken]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpacesSizeInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
