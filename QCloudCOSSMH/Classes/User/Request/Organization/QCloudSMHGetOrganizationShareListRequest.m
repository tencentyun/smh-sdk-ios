//
//  QCloudSMHGetOrganizationShareListRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHGetOrganizationShareListRequest.h"

@implementation QCloudSMHGetOrganizationShareListRequest
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
        QCloudResponseObjectSerilizerBlock([QCloudSMHOrganizationShareList class])
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
    
    [__pathComponents addObject:@"share-list"];

    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
 
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
    
    if (self.nickNameOrEmailOrPhoneNumber) {
        [self.requestData setQueryStringParamter:self.nickNameOrEmailOrPhoneNumber withKey:@"user_filter"];
    }
 
    if (self.nickNameOrEmailOrPhoneNumber) {
        [self.requestData setQueryStringParamter:self.nickNameOrEmailOrPhoneNumber withKey:@"user_filter"];
    }
    
    if (self.expireTimeEnd) {
        [self.requestData setQueryStringParamter:self.expireTimeEnd withKey:@"expire_time_end"];
    }
    
    if (self.expireTimeStart) {
        [self.requestData setQueryStringParamter:self.expireTimeStart withKey:@"expire_time_start"];
    }
    
    if (self.name) {
        [self.requestData setQueryStringParamter:self.name withKey:@"name"];
    }
    
    NSInteger  orderType = self.sortType / 100;
    if (orderType == 0) {
        [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
    }else{
        [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
    }
    
    [self.requestData setQueryStringParamter:QCloudSMHShareSortTypeTransferToString(self.sortType) withKey:@"order_by"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationShareList * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
