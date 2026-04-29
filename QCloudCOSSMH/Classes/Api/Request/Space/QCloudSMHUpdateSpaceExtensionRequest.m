#import "QCloudSMHUpdateSpaceExtensionRequest.h"

@implementation QCloudSMHUpdateSpaceExtensionRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
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
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/space"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:@"extension"];
    // 构建 JSON body
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"isPublicRead"] = @(self.isPublicRead);
    body[@"allowPhoto"] = @(self.allowPhoto);
    body[@"allowVideo"] = @(self.allowVideo);
    body[@"recognizeSensitiveContent"] = @(self.recognizeSensitiveContent);
    if (self.allowPhotoExtname) {
        body[@"allowPhotoExtname"] = self.allowPhotoExtname;
    }
    if (self.allowVideoExtname) {
        body[@"allowVideoExtname"] = self.allowVideoExtname;
    }
    if (self.allowFileExtname) {
        body[@"allowFileExtname"] = self.allowFileExtname;
    }
    self.requestData.directBody = [body qcloud_modelToJSONData];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
