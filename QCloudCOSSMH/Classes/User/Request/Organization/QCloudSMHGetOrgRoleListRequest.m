//
//  QCloudSMHGetOrgRoleListRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHGetOrgRoleListRequest.h"

@implementation QCloudSMHGetOrgRoleListRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
    
        QCloudResponseObjectSerilizerBlock([QCloudSMHRoleInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/organization"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:self.organizationId];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:QCloudSMHUsedSenceTransferToString(self.userSence) withKey:@"used_sence"];
    [__pathComponents addObject:@"role-list"];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    return [super prepareInvokeURLRequest:urlRequest error:error];
}

- (void)setFinishBlock:(void (^_Nullable)(NSArray <QCloudSMHRoleInfo *> *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
