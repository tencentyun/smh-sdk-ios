//
//  QCloudSMHPutHisotryVersionRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/17.
//

#import "QCloudSMHPutHisotryVersionRequest.h"

@implementation QCloudSMHPutHisotryVersionRequest
- (void)dealloc {
    
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory-history"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"library-history"];
    self.requestData.URIComponents = __pathComponents;
   
    NSMutableDictionary *bodyDic = [NSMutableDictionary new];

    bodyDic[@"enableFileHistory"] = @(self.enableFileHistory);
    bodyDic[@"fileHistoryCount"] = @(self.fileHistoryCount);
    bodyDic[@"fileHistoryExpireDay"] = @(self.fileHistoryExpireDay);
    bodyDic[@"isClearFileHistory"] = @(self.isClearFileHistory);
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[bodyDic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
    self.requestData.directBody = jsonData;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}


@end
