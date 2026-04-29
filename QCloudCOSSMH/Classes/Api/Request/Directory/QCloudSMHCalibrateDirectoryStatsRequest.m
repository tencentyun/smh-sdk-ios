#import "QCloudSMHCalibrateDirectoryStatsRequest.h"

@implementation QCloudSMHCalibrateDirectoryStatsRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHCalibrateDirectoryStatsResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath) { [__pathComponents addObject:self.filePath]; }
    [self.requestData setQueryStringParamter:@"1" withKey:@"calibrate"];
    if (self.statsType) {
        [self.requestData setQueryStringParamter:self.statsType withKey:@"stats_type"];
    }
    if (self.recycledId) {
        [self.requestData setQueryStringParamter:self.recycledId withKey:@"recycled_id"];
    }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHCalibrateDirectoryStatsResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
