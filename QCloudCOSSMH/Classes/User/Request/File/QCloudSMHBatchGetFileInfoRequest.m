//
//  QCloudSMHBatchGetFileInfoRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHBatchGetFileInfoRequest.h"

@implementation QCloudSMHBatchGetFileInfoRequest
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

    requestSerializer.HTTPMethod = @"post";
    
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/directory"]];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    if (!self.organizationId) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[organizationId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (!self.spaceId) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[spaceId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:self.spaceId];
    [__pathComponents addObject:@"detail"];
    self.requestData.URIComponents = __pathComponents;
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setParameter:self.userToken withKey:@"user_token"];
    
    NSData * data = [self.dirPaths qcloud_modelToJSONData];
    self.requestData.directBody  = data;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)( NSArray <QCloudSMHContentInfo *> * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
