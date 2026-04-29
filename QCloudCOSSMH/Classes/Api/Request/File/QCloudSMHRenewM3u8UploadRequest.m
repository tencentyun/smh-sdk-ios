#import "QCloudSMHRenewM3u8UploadRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"

@implementation QCloudSMHRenewM3u8UploadRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHM3u8RenewResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // POST /api/v1/hls/{LibraryId}/{SpaceId}/{ConfirmKey}?renew=1
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/hls"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.confirmKey) {
        [__pathComponents addObject:self.confirmKey];
    }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:@"1" withKey:@"renew"];
    if (self.trafficLimit > 0) {
        [self.requestData setQueryStringParamter:[@(self.trafficLimit) stringValue] withKey:@"traffic_limit"];
    }
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.playlistType) {
        body[@"playlist"] = self.playlistType;
    }
    if (self.segments) {
        // API 层面 segments 为纯字符串数组，从数据模型中提取 path 字段
        NSMutableArray<NSString *> *segmentPaths = [NSMutableArray arrayWithCapacity:self.segments.count];
        for (QCloudSMHM3u8RenewSegmentInfo *seg in self.segments) {
            if (seg.path) {
                [segmentPaths addObject:seg.path];
            }
        }
        body[@"segments"] = segmentPaths;
    }
    self.requestData.directBody = [body qcloud_modelToJSONData];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHM3u8RenewResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
