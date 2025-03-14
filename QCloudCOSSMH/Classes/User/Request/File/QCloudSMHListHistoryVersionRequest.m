//
//  QCloudSMHListHistoryVersionRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHListHistoryVersionRequest.h"

@implementation QCloudSMHListHistoryVersionRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHListHistoryVersionResult class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (!self.filePath || ([self.filePath isKindOfClass:NSString.class] && ((NSString *)self.filePath).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[filePath] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/history"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
 
    self.requestData.URIComponents = __pathComponents;
 
    if(self.limit>0){
        [self.requestData setQueryStringParamter:@(self.limit).stringValue withKey:@"limit"];
    }
    if(self.marker.length>0){
        [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];
    }
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:self.spaceId];
    [__pathComponents addObject:@"history-list"];
    [__pathComponents addObject:self.filePath];
    if(self.page>0){
        [self.requestData setQueryStringParamter:@(self.page).stringValue withKey:@"page"];
    }
    
    if(self.pageSize>0){
        [self.requestData setQueryStringParamter:@(self.pageSize).stringValue withKey:@"page_size"];
    }
    if (self.sortType > QCloudSMHSortTypeNone) {
        [self.requestData setQueryStringParamter:QCloudSMHOrderByTransferToString(self.sortType%100) withKey:@"order_by"];
        if(self.sortType<100){
            [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
        }else{
            [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
        }
    }

    if (self.spaceOrgId) {
        [self.requestData setQueryStringParamter:self.spaceOrgId withKey:@"space_org_id"];
    }
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHListHistoryVersionResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
