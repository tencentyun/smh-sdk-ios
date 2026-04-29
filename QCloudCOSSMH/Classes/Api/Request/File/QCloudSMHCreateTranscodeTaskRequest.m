#import "QCloudSMHCreateTranscodeTaskRequest.h"

@implementation QCloudSMHCreateTranscodeTaskRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        // 自定义 JSON 解析：204 No Content 表示转码已完成，无响应体，直接返回 nil（不设置 error）；
        // 200 正常解析 JSON 返回 { taskId: xxx }
        ^(NSHTTPURLResponse *response, id inputData, NSError *__autoreleasing *error) {
            if (response.statusCode == 204) {
                return (id)nil;
            }
            if (![inputData isKindOfClass:[NSData class]]) {
                if (error != NULL) {
                    *error = [NSError errorWithDomain:@"com.tencent.networking"
                                                code:-1404
                                            userInfo:@{ NSLocalizedDescriptionKey : @"数据非法，请传入合法数据" }];
                }
                return (id)nil;
            }
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:inputData options:0 error:error];
            return (id)jsonObject;
        },
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/hls"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath) { [__pathComponents addObject:self.filePath]; }
    [self.requestData setQueryStringParamter:@"1" withKey:@"transcode"];
    if (self.transcodingTemplateId) { NSDictionary *body = @{@"transcodingTemplateId": self.transcodingTemplateId}; self.requestData.directBody = [body qcloud_modelToJSONData]; }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
