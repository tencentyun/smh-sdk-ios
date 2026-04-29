#import "QCloudSMHSearchSharesRequest.h"

@implementation QCloudSMHSearchSharesRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHShareListResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share"]];
    self.requestData.serverURL = serverHost.absoluteString;
    // SearchShares URL: /api/v1/share/{LibraryId}/search（不含 SpaceId）
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }
    [__pathComponents addObject:@"search"];
    self.requestData.URIComponents = __pathComponents;
    // 查询参数
    if (self.limit > 0) { [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld", (long)self.limit] withKey:@"limit"]; }
    if (self.marker) { [self.requestData setQueryStringParamter:self.marker withKey:@"marker"]; }
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.name) { body[@"name"] = self.name; }
    if (self.creatorId) { body[@"creatorId"] = self.creatorId; }
    if (self.orderBy) { body[@"orderBy"] = self.orderBy; }
    if (self.orderByType) { body[@"orderByType"] = self.orderByType; }
    if (self.expireTimeStart) { body[@"expireTimeStart"] = self.expireTimeStart; }
    if (self.expireTimeEnd) { body[@"expireTimeEnd"] = self.expireTimeEnd; }
    if (self.createTimeStart) { body[@"createTimeStart"] = self.createTimeStart; }
    if (self.createTimeEnd) { body[@"createTimeEnd"] = self.createTimeEnd; }
    if (body.count > 0) { self.requestData.directBody = [body qcloud_modelToJSONData]; }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
