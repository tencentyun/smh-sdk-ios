#import "QCloudSMHCreateShareRequest.h"

@implementation QCloudSMHCreateShareRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHCreateShareResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // POST /api/v1/share/{LibraryId}/{SpaceId}
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (self.name) { body[@"name"] = self.name; }
    if (self.filePath) { body[@"filePath"] = self.filePath; }
    // 构建 config 子对象
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"isPermanent"] = @(self.isPermanent);
    if (self.expireTime) { config[@"expireTime"] = self.expireTime; }
    if (self.extractionCode) { config[@"extractionCode"] = self.extractionCode; }
    config[@"canPreview"] = @(self.canPreview);
    config[@"canDownload"] = @(self.canDownload);
    config[@"canSaveToNetdisk"] = @(self.canSaveToNetdisk);
    config[@"forbidAnonymousUser"] = @(self.forbidAnonymousUser);
    if (self.previewLimit > 0) { config[@"previewLimit"] = @(self.previewLimit); }
    if (self.downloadLimit > 0) { config[@"downloadLimit"] = @(self.downloadLimit); }
    if (self.userLimit > 0) { config[@"userLimit"] = @(self.userLimit); }
    if (self.shareToUsers) { config[@"shareToUsers"] = self.shareToUsers; }
    body[@"config"] = config;
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
