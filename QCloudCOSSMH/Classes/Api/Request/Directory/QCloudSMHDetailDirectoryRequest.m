//
//  QCloudSMHDetailDirectoryRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHDetailDirectoryRequest.h"

@implementation QCloudSMHDetailDirectoryRequest
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
        QCloudURLFuseContentMD5Base64StyleHeaders,
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
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.filePath){
        [__pathComponents addObject:self.filePath];
    }
    self.requestData.URIComponents = __pathComponents;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    [self.requestData setQueryStringParamter:self.withInode?@"1":@"0" withKey:@"with_inode"];
    [self.requestData setQueryStringParamter:self.withFavoriteStatus?@"1":@"0" withKey:@"with_favorite_status"];
    return YES;
}

- (void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
