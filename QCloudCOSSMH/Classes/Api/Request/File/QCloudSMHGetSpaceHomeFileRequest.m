//
//  QCloudSMHGetSpaceHomeFileRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHGetSpaceHomeFileRequest.h"

@implementation QCloudSMHGetSpaceHomeFileRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHSpaceHomeFileInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/space"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"contents-view"];
    self.requestData.URIComponents = __pathComponents;
    
    
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
    if (self.directoryFilter != QCloudSMHDirectoryAll) {
        [self.requestData setQueryStringParamter:QCloudSMHDirectoryFilterTransferToString(self.directoryFilter) withKey:@"filter"];
    }
    [self.requestData setQueryStringParamter:self.withPath?@"true":@"false" withKey:@"with_path"];
    if (self.category) {
        [self.requestData setQueryStringParamter:self.category withKey:@"category"];
    }
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpaceHomeFileInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
