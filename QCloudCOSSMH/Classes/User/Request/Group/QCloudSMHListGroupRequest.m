//
//  QCloudSMHListGroupRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHListGroupRequest.h"

@implementation QCloudSMHListGroupRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHListGroupInfo.class)
        
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/group/%@/list",self.organizationId]]];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:@(self.withDirectory).stringValue withKey:@"with_directory"];
    [self.requestData setQueryStringParamter:@(self.checkUpdateRecursively).stringValue withKey:@"check_update_recursively"];
    [self.requestData setQueryStringParamter:@(self.withRecycledFileCount).stringValue withKey:@"with_recycled_file_count"];
    [self.requestData setQueryStringParamter:@(self.withFileCount).stringValue withKey:@"with_file_count"];
    [self.requestData setQueryStringParamter:@(self.withUser).stringValue withKey:@"with_users"];
    [self.requestData setQueryStringParamter:QCloudSMHGroupJoinTypeTransferToString(self.joinType) withKey:@"join_type"];
    [self.requestData setQueryStringParamter:@(self.adminOnly).stringValue withKey:@"admin_only"];
    if(self.joinTimeStart){
        [self.requestData setQueryStringParamter:self.joinTimeStart withKey:@"join_time_start"];
    }
    
    if(self.joinTimeStart){
        [self.requestData setQueryStringParamter:self.joinTimeStart withKey:@"join_time_end"];
    }
    
    [self.requestData setQueryStringParamter:QCloudSMHGetGroupSortTypeTransferToString(self.sortType) withKey:@"order_by"];
    if(self.sortType<100){
        [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
    }else{
        [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
    }
    
    if(self.page>0){
        [self.requestData setQueryStringParamter:@(self.page).stringValue withKey:@"page"];
    }

    if(self.pageSize>0){
        [self.requestData setQueryStringParamter:@(self.pageSize).stringValue withKey:@"page_size"];
    }
    
    if(self.limit>0){
        [self.requestData setQueryStringParamter:@(self.limit).stringValue withKey:@"limit"];
    }
    if(self.marker.length>0){
        [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];
    }
    
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHListGroupInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
