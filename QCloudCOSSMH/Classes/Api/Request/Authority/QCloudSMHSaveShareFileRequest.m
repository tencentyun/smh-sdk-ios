#import "QCloudSMHSaveShareFileRequest.h"

@implementation QCloudSMHSaveShareFileRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHSaveShareFileResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    // URL: /api/v1/share/file/{ShareCode}?save=1
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.shareCode) { [__pathComponents addObject:self.shareCode]; }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"save"];
    if (self.accessToken) { [self.requestData setQueryStringParamter:self.accessToken withKey:@"access_token"]; }
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.targetSpaceId) { body[@"targetSpaceId"] = self.targetSpaceId; }
    if (self.targetPath) { body[@"targetPath"] = self.targetPath; }
    if (self.sourceInodesPath) { body[@"sourceInodesPath"] = self.sourceInodesPath; }
    if (self.inodes) { body[@"inodes"] = self.inodes; }
    if (self.conflictResolutionStrategy) { body[@"conflictResolutionStrategy"] = self.conflictResolutionStrategy; }
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSaveShareFileResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
