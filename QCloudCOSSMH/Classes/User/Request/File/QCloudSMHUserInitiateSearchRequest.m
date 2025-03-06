//
//  QCloudSMHUserInitiateSearchRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserInitiateSearchRequest.h"

@implementation QCloudSMHUserInitiateSearchRequest
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
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHSearchListInfo class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/directory-search"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"global"];
    self.requestData.URIComponents = __pathComponents;
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary new];
    if(self.keyword){
        bodyDic[@"keyword"] = self.keyword;
    }
    if(self.scope){
        bodyDic[@"scope"] = self.scope;
    }
    
    if(self.extname.count > 0){
        bodyDic[@"extname"] = self.extname;
    }
    
    NSMutableArray *searchTypeTexts = [NSMutableArray array];
    if(self.searchTypes){
        for (NSNumber *obj in self.searchTypes) {
            [searchTypeTexts addObject:QCloudSMHSearchTypeByTransferToString(obj.integerValue)];
        }
        bodyDic[@"type"] = [searchTypeTexts copy];
    }
   
    if (self.searchTags.count) {
        bodyDic[@"tags"] = self.searchTags;
    }
    
    if (self.maxFileSize > 0) {
        [bodyDic setObject:@(self.maxFileSize) forKey:@"maxFileSize"];
    }
    
    if (self.minFileSize > 0) {
        [bodyDic setObject:@(self.minFileSize) forKey:@"minFileSize"];
    }
    
    if (self.modificationTimeStart > 0) {
        [bodyDic setObject:self.modificationTimeStart forKey:@"modificationTimeStart"];
    }
    
    if (self.modificationTimeEnd > 0) {
        [bodyDic setObject:self.modificationTimeEnd forKey:@"modificationTimeEnd"];
    }
    if (self.creators) {
        [bodyDic setObject:self.creators forKey:@"creators"];
    }
    
    if(self.spaceId){
        [bodyDic setObject:self.spaceId forKey:@"spaceId"];
    }
    
    if(self.spaceOrgId){
        [bodyDic setObject:self.spaceOrgId forKey:@"spaceOrgId"];
    }
    
    [bodyDic setObject:QCloudSMHSearchByTypeByTransferToString(self.searchBy) forKey:@"searchBy"];
    [bodyDic setObject:@(self.accurate) forKey:@"accurate"];
    
    
    if (self.sortType > QCloudSMHSortTypeNone) {
        [bodyDic setObject:QCloudSMHOrderByTransferToString(self.sortType%100) forKey:@"orderBy"];
        if(self.sortType<100){
            [bodyDic setObject:@"asc" forKey:@"orderByType"];
        }else{
            [bodyDic setObject:@"desc" forKey:@"orderByType"];
        }
    }
    
    
    self.requestData.directBody = [bodyDic qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
