#import "QCloudSMHGetShareDetailRequest.h"

@implementation QCloudSMHGetShareDetailRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHShareDetail class]),
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
    // URL: /api/v1/share/{LibraryId}/{ShareId}?detail=1（不含 SpaceId）
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) { [__pathComponents addObject:self.libraryId]; }
    if (self.shareId) { [__pathComponents addObject:self.shareId]; }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"detail"];
    if (self.withFileInfo) { [self.requestData setQueryStringParamter:@"1" withKey:@"with_file_info"]; }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareDetail *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
