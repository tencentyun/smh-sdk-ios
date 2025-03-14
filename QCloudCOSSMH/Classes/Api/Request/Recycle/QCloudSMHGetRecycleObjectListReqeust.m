//
//  QCloudSMHGetRecycleObjectListReqeust.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHGetRecycleObjectListReqeust.h"

@implementation QCloudSMHGetRecycleObjectListReqeust



- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHRecycleObjectListInfo class])

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

    if(self.limit>0){
        [self.requestData setQueryStringParamter:@(self.limit).stringValue withKey:@"limit"];
    }
    if(self.marker.length>0){
        [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];
    }
    
    if(self.page>0){
        [self.requestData setQueryStringParamter:@(self.page).stringValue withKey:@"page"];
    }
    
    if(self.pageSize>0){
        [self.requestData setQueryStringParamter:@(self.pageSize).stringValue withKey:@"page_size"];
    }
    
    if (self.sortType > QCloudSMHSortTypeNone) {
        if (self.sortType == QCloudSMHSortTypeCTimeReverse || self.sortType == QCloudSMHSortTypeCTime) {
            [self.requestData setQueryStringParamter:@"removalTime" withKey:@"order_by"];
        }else{
            [self.requestData setQueryStringParamter:QCloudSMHOrderByTransferToString(self.sortType%100) withKey:@"order_by"];
        }
        
        if(self.sortType<100){
            [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
            
        }else{
            [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
        }
    }
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecycleObjectListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
