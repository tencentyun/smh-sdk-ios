//
//  QCloudSMHGetTeamRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/19.
//

#import "QCloudSMHGetTeamRequest.h"

@implementation QCloudSMHGetTeamRequest
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
        QCloudURLFuseURIMethodASURLParamters
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
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/team/%@",self.organizationId]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
  
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.teamId){
        [__pathComponents addObject:self.teamId];
    }
    if(self.limit>0){
        [self.requestData setQueryStringParamter:@(self.limit).stringValue withKey:@"limit"];
    }
    if(self.marker.length>0){
        [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];
    }
 
    if (self.checkManagementPermission) {
        [self.requestData setQueryStringParamter:self.checkManagementPermission withKey:@"check_management_permission"];
    }
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:self.withPath?@"true":@"false" withKey:@"with_path"];
    self.requestData.URIComponents = __pathComponents;
    if(self.checkPermission){
        self.requestData.URIMethod = @"check_permission";
    }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTeamInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
