#import "QCloudSMHCreateTokenRequest.h"

@implementation QCloudSMHCreateTokenRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHTokenResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // GET /api/v1/token?library_id=xxx&library_secret=xxx&...
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/token"]];
    self.requestData.serverURL = serverHost.absoluteString;
    if (self.libraryId) {
        [self.requestData setQueryStringParamter:self.libraryId withKey:@"library_id"];
    }
    if (self.librarySecret) {
        [self.requestData setQueryStringParamter:self.librarySecret withKey:@"library_secret"];
    }
    if (self.spaceId) {
        [self.requestData setQueryStringParamter:self.spaceId withKey:@"space_id"];
    }
    if (self.userId) {
        [self.requestData setQueryStringParamter:self.userId withKey:@"user_id"];
    }
    if (self.clientId) {
        [self.requestData setQueryStringParamter:self.clientId withKey:@"client_id"];
    }
    if (self.sessionId) {
        [self.requestData setQueryStringParamter:self.sessionId withKey:@"session_id"];
    }
    if (self.period > 0) {
        [self.requestData setQueryStringParamter:[@(self.period) stringValue] withKey:@"period"];
    }
    if (self.grant) {
        [self.requestData setQueryStringParamter:self.grant withKey:@"grant"];
    }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
