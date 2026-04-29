#import "QCloudSMHUpdateQuotaByIdRequest.h"

@implementation QCloudSMHUpdateQuotaByIdRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // PUT /api/v1/quota/{LibraryId}/{QuotaId}（不含 SpaceId）
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/quota"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }
    if (self.quotaId) {
        [__pathComponents addObject:self.quotaId];
    }
    self.requestData.URIComponents = __pathComponents;
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.spaces) {
        body[@"spaces"] = self.spaces;
    }
    if (self.capacity) {
        body[@"capacity"] = self.capacity;
    }
    body[@"removeWhenExceed"] = @(self.removeWhenExceed);
    if (self.removeAfterDays > 0) {
        body[@"removeAfterDays"] = @(self.removeAfterDays);
    }
    body[@"removeNewest"] = @(self.removeNewest);
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
