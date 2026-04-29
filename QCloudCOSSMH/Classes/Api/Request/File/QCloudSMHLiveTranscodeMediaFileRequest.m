#import "QCloudSMHLiveTranscodeMediaFileRequest.h"

@implementation QCloudSMHLiveTranscodeMediaFileRequest

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
    // GET /api/v1/hls/{LibraryId}/{SpaceId}/{FilePath}?live_transcode=1&transcoding_template_id=xxx
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/hls"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.filePath) {
        [__pathComponents addObject:self.filePath];
    }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"live_transcode"];
    if (self.transcodingTemplateId) {
        [self.requestData setQueryStringParamter:self.transcodingTemplateId withKey:@"transcoding_template_id"];
    }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
