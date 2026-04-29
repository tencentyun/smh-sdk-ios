#import "QCloudSMHListSharesRequest.h"

@implementation QCloudSMHListSharesRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHShareListResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share"]];
    self.requestData.serverURL = serverHost.absoluteString;
    // ListShares URL: /api/v1/share/{LibraryId}/list（不含 SpaceId）
    // 需要从 super 注入的 URIComponents 中移除 spaceId
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }
    [__pathComponents addObject:@"list"];
    self.requestData.URIComponents = __pathComponents;
    // 查询参数
    if (self.limit > 0) { [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld", (long)self.limit] withKey:@"limit"]; }
    if (self.marker) { [self.requestData setQueryStringParamter:self.marker withKey:@"marker"]; }
    if (self.orderBy) { [self.requestData setQueryStringParamter:self.orderBy withKey:@"orderBy"]; }
    if (self.orderByType) { [self.requestData setQueryStringParamter:self.orderByType withKey:@"orderByType"]; }
    if (self.creatorId) { [self.requestData setQueryStringParamter:self.creatorId withKey:@"creatorId"]; }
    if (self.withFileInfo) { [self.requestData setQueryStringParamter:@"1" withKey:@"with_file_info"]; }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
