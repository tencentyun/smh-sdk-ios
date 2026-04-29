#import "QCloudSMHPrepareM3u8UploadRequest.h"

@implementation QCloudSMHPrepareM3u8UploadRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // PUT /api/v1/hls/{LibraryId}/{SpaceId}/{FilePath}
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/hls"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.filePath) {
        [__pathComponents addObject:self.filePath];
    }
    self.requestData.URIComponents = __pathComponents;
    if (self.conflictResolutionStrategy) {
        [self.requestData setQueryStringParamter:self.conflictResolutionStrategy withKey:@"conflict_resolution_strategy"];
    }
    if (self.trafficLimit > 0) {
        [self.requestData setQueryStringParamter:[@(self.trafficLimit) stringValue] withKey:@"traffic_limit"];
    }
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.sampleHash) {
        body[@"sampleHash"] = self.sampleHash;
    }
    if (self.segmentsCount) {
        body[@"segmentsCount"] = self.segmentsCount;
    }
    if (self.includePlaylist) {
        body[@"playlist"] = @{};
    }
    if (self.segments) {
        NSMutableArray *segmentsArray = [NSMutableArray arrayWithCapacity:self.segments.count];
        for (QCloudSMHM3u8SegmentInfo *seg in self.segments) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (seg.path) { dict[@"path"] = seg.path; }
            if (seg.uploadMethod) { dict[@"uploadMethod"] = seg.uploadMethod; }
            [segmentsArray addObject:dict];
        }
        body[@"segments"] = segmentsArray;
    }
    self.requestData.directBody = [body qcloud_modelToJSONData];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
