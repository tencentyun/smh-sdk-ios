//
//  QCloudSMHGetUserListRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHGetUserListRequest.h"


@implementation QCloudSMHGetUserListRequest
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
        QCloudResponseObjectSerilizerBlock([QCloudSMHTeamContentInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/user"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    self.requestData.URIComponents = __pathComponents;
    
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    if (self.keyword) {
        [self.requestData setQueryStringParamter:self.keyword withKey:@"keyword"];
    }
    
    if (self.page != 0) {
        [self.requestData setQueryStringParamter:@(self.page).stringValue withKey:@"page"];
    }else{
        [self.requestData setQueryStringParamter:@(1).stringValue withKey:@"page"];
    }
    
    if (self.pageSize != 0) {
        [self.requestData setQueryStringParamter:@(self.pageSize).stringValue withKey:@"page_size"];
    }else{
        [self.requestData setQueryStringParamter:@(20).stringValue withKey:@"page_size"];
    }
    
    NSInteger  orderType = self.sortType / 100;
    if (orderType == 0) {
        [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
    }else{
        [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
    }
    
    NSString * sortType = @"role";
    switch (self.sortType % 100) {
        case 0:
            sortType = @"role";
            break;
        case 1:
            sortType = @"enabled";
            break;
        case 2:
            sortType = @"nickname";
            break;
    }
    
    [self.requestData setQueryStringParamter:sortType withKey:@"order_by"];
   
    [self.requestData setQueryStringParamter:@(self.withSpaceUsage).stringValue withKey:@"with_space_usage"];
    
    [self.requestData setQueryStringParamter:@(self.withBelongingTeams).stringValue withKey:@"with_belonging_teams"];
    
    [self.requestData setQueryStringParamter:@(self.excludeTeamUser).stringValue withKey:@"exclude_team_user"];
    
    if(self.limit>0){
        [self.requestData setQueryStringParamter:@(self.limit).stringValue withKey:@"limit"];
    }
    if(self.marker.length>0){
        [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];
    }
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];

    return YES;
}

- (void)setFinishBlock:(void (^)(QCloudSMHTeamContentInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
