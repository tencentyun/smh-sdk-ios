#import "QCloudSMHCreateQuotaRequest.h"

@implementation QCloudSMHCreateQuotaRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHQuotaInfo class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/quota"]];
    self.requestData.serverURL = serverHost.absoluteString;
    // CreateQuota URL: /api/v1/quota/{LibraryId}（不含 SpaceId）
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }
    self.requestData.URIComponents = __pathComponents;
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.spaces) { body[@"spaces"] = self.spaces; }
    if (self.capacity) { body[@"capacity"] = self.capacity; }
    body[@"removeWhenExceed"] = @(self.removeWhenExceed);
    body[@"removeAfterDays"] = @(self.removeAfterDays);
    body[@"removeNewest"] = @(self.removeNewest);
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHQuotaInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
