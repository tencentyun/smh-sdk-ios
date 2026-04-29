#import "QCloudSMHVerifyExtractionCodeRequest.h"

@implementation QCloudSMHVerifyExtractionCodeRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHVerifyExtractionCodeResult class]),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    // 无需认证的公开接口：POST /api/v1/share/verify/{ShareCode}
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/share/verify"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.shareCode) {
        [__pathComponents addObject:self.shareCode];
    }
    self.requestData.URIComponents = __pathComponents;
    if (self.extractionCode) {
        NSMutableDictionary *body = [NSMutableDictionary dictionary];
        body[@"extractionCode"] = self.extractionCode;
        if (self.libraryId) { body[@"libraryId"] = self.libraryId; }
        if (self.accessToken) { body[@"access_token"] = self.accessToken; }
        if (self.deviceId) { body[@"device_id"] = self.deviceId; }
        self.requestData.directBody = [body qcloud_modelToJSONData];
    }
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHVerifyExtractionCodeResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
