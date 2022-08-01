//
//  QCloudGetObjectInfoRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHGetFileInfoRequest.h"

@implementation QCloudSMHGetFileInfoRequest
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
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHContentInfo.class)
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
    
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

   
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/directory"]];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    if (self.spaceId){
        [__pathComponents addObject:self.spaceId];
    }
    [__pathComponents addObject:self.dirPath];
    self.requestData.URIComponents = __pathComponents;
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setParameter:self.userToken withKey:@"user_token"];
    
    if (self.spaceOrgId) {
        [self.requestData setParameter:self.spaceOrgId withKey:@"space_org_id"];
    }
    
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    self.requestData.URIMethod = @"info";
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
