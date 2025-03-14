//
//  QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest.h"

@implementation QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHContentListInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/authority"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"related-authorization-directory"];
    
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
        [self.requestData setQueryStringParamter:QCloudSMHOrderByTransferToString(self.sortType%100) withKey:@"order_by"];
        if(self.sortType<100){
            [self.requestData setQueryStringParamter:@"asc" withKey:@"order_by_type"];
            
        }else{
            [self.requestData setQueryStringParamter:@"desc" withKey:@"order_by_type"];
        }
    }
  
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentListInfo * result, NSError * error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
