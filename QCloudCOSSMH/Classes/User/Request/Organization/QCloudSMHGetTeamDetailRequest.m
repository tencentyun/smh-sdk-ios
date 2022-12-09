//
//  QCloudSMHGetTeamDetailRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHGetTeamDetailRequest.h"


@implementation QCloudSMHGetTeamDetailRequest
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
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHTeamInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/team"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:self.organizationId];
    if (self.teamId) {
        [__pathComponents addObject:self.teamId];
    }
    
    [self.requestData setQueryStringParamter:self.withPath?@"1":@"0" withKey:@"with_path"];
    
    if (self.checkPermission) {
        [self.requestData setQueryStringParamter:self.checkPermission withKey:@"check_permission"];
    }
    
    if (self.checkManagementPermission) {
        [self.requestData setQueryStringParamter:self.checkManagementPermission withKey:@"check_management_permission"];
    }
    
    [self.requestData setQueryStringParamter:self.WithRecursiveUserCount?@"1":@"0" withKey:@"with_recursive_user_count"];
    
    [self.requestData setQueryStringParamter:@(self.withRecycledFileCount).stringValue withKey:@"with_recycled_file_count"];
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
   
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTeamInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
