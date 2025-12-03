//
//  QCloudSMHListContentsRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import "QCloudSMHListContentsRequest.h"
#import "QCloudSMHService.h"

@implementation QCloudSMHListContentsRequest

- (void)fakeStart {
    [[QCloudSMHService defaultSMHService] listContents:self];
}

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

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    if (!self.accessToken) {
        return [super prepareInvokeURLRequest:urlRequest error:error];
    }
    return YES;
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.dirPath){
        [__pathComponents addObject:self.dirPath];
    }
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
   
    if (self.directoryFilter != QCloudSMHDirectoryAll) {
        [self.requestData setQueryStringParamter:QCloudSMHDirectoryFilterTransferToString(self.directoryFilter) withKey:@"filter"];
    }
    
    [self.requestData setQueryStringParamter:self.withInode?@"1":@"0" withKey:@"with_inode"];
    [self.requestData setQueryStringParamter:self.withFavoriteStatus?@"1":@"0" withKey:@"with_favorite_status"];
    
    if (self.accessToken) {
        [self.requestData setQueryStringParamter:self.accessToken withKey:@"access_token"];
    }

    if(self.headerIfNoneMatch.length){
        [self.requestData setValue:self.headerIfNoneMatch forHTTPHeaderField:@"If-None-Match"];
    }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
