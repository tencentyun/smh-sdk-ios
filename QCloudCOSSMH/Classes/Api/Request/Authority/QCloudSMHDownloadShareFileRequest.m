#import "QCloudSMHDownloadShareFileRequest.h"

@implementation QCloudSMHDownloadShareFileRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.disableRedirect = YES;
    }
    return self;
}

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), @(302), nil], nil),
        QCloudResponseAppendHeadersSerializerBlock,
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
    // URL: /api/v1/share/file/{ShareCode}/{Inodes}?download=1
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.shareCode) { [__pathComponents addObject:self.shareCode]; }
    if (self.inodes) { [__pathComponents addObject:self.inodes]; }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"download"];
    if (self.accessToken) { [self.requestData setQueryStringParamter:self.accessToken withKey:@"access_token"]; }
    if (self.internalDomain > 0) { [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld", (long)self.internalDomain] withKey:@"internal_domain"]; }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
