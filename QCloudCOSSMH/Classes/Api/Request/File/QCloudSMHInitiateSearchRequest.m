//
//  QCloudSMHSearchRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHInitiateSearchRequest.h"

@implementation QCloudSMHInitiateSearchRequest
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/search"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"space-contents"];
    self.requestData.URIComponents = __pathComponents;
   
    NSMutableDictionary *bodyDic = [NSMutableDictionary new];
    if(self.keyword.length){
        bodyDic[@"keyword"] = self.keyword;
    }
    if(self.scope.length){
        bodyDic[@"scope"] = self.scope;
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
    
    self.requestData.directBody = [bodyDic qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
