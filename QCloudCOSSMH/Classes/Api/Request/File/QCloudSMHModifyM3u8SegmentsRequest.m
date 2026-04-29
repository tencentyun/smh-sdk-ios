#import "QCloudSMHModifyM3u8SegmentsRequest.h"
#import "QCloudSMHM3u8UploadInfo.h"

@implementation QCloudSMHModifyM3u8SegmentsRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHM3u8ModifyResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // POST /api/v1/hls/{LibraryId}/{SpaceId}/{ConfirmKey}?modify=1
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/hls"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.confirmKey) {
        [__pathComponents addObject:self.confirmKey];
    }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"modify"];
    if (self.trafficLimit > 0) {
        [self.requestData setQueryStringParamter:[@(self.trafficLimit) stringValue] withKey:@"traffic_limit"];
    }
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
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

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHM3u8ModifyResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
