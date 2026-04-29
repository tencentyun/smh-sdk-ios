#import "QCloudSMHDeleteUserTokensRequest.h"

@implementation QCloudSMHDeleteUserTokensRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"delete";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // 使用 librarySecret 认证：DELETE /api/v1/token/{LibraryId}
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/token"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }
    self.requestData.URIComponents = __pathComponents;
    if (self.librarySecret) {
        [self.requestData setQueryStringParamter:self.librarySecret withKey:@"library_secret"];
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
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
