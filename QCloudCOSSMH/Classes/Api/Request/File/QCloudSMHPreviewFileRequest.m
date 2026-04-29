#import "QCloudSMHPreviewFileRequest.h"

@implementation QCloudSMHPreviewFileRequest

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
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath) {
        [__pathComponents addObject:self.filePath];
    }
    [self.requestData setQueryStringParamter:@"1" withKey:@"preview"];
    if (self.historyId) {
        [self.requestData setQueryStringParamter:self.historyId withKey:@"history_id"];
    }
    if (self.type) {
        [self.requestData setQueryStringParamter:self.type withKey:@"type"];
    }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
