//
//  QCloudSMHGetRecycleListRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHGetRecycleListRequest.h"

@implementation QCloudSMHSpaceItem

@end

@implementation QCloudSMHGetRecycleListRequest
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
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHCrossSpaceRecycleInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/recycled"]];

    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"list"];
    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
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
    if (self.sortType > QCloudSMHSortTypeNone) {
        [self.requestData setQueryStringParamter:QCloudSMHOrderByTransferToString(self.sortType%100) withKey:@"order_by"];
        if(self.sortType<100){
            [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];

        }else{
            [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
        }
    }
   
    if(self.removedBy){
        [self.requestData setQueryStringParamter:self.removedBy withKey:@"removed_by"];
    }
    
    self.requestData.directBody = [@{@"spaceItems":self.spaceItems,@"withAllTeamSpace":@(self.withAllTeamSpace),@"withAllGroupSpace":@(self.withAllGroupSpace)} qcloud_modelToJSONData];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^)(QCloudSMHCrossSpaceRecycleInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
