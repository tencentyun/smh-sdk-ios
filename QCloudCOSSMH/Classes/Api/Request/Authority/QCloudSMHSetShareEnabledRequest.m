#import "QCloudSMHSetShareEnabledRequest.h"

@implementation QCloudSMHSetShareEnabledRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

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
    // URL: /api/v1/share/{LibraryId}/{ShareId}?setEnabled=1（不含 SpaceId）
    NSMutableArray *__pathComponents = [NSMutableArray array];
    if (self.libraryId) { [__pathComponents addObject:self.libraryId]; }
    if (self.shareId) { [__pathComponents addObject:self.shareId]; }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"setEnabled"];
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"adminEnabled"] = @(self.adminEnabled);
    body[@"ownerEnabled"] = @(self.ownerEnabled);
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
