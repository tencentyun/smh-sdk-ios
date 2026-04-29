#import "QCloudSMHListShareFilesRequest.h"

@implementation QCloudSMHListShareFilesRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHShareFileListResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    // URL: /api/v1/share/file/{ShareCode}/{Inodes}?list=1&access_token=xxx
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.shareCode) { [__pathComponents addObject:self.shareCode]; }
    if (self.inodes) { [__pathComponents addObject:self.inodes]; }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"list"];
    if (self.accessToken) { [self.requestData setQueryStringParamter:self.accessToken withKey:@"access_token"]; }
    if (self.limit > 0) { [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld", (long)self.limit] withKey:@"limit"]; }
    if (self.marker) { [self.requestData setQueryStringParamter:self.marker withKey:@"marker"]; }
    if (self.orderBy) { [self.requestData setQueryStringParamter:self.orderBy withKey:@"orderBy"]; }
    if (self.orderByType) { [self.requestData setQueryStringParamter:self.orderByType withKey:@"orderByType"]; }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareFileListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
