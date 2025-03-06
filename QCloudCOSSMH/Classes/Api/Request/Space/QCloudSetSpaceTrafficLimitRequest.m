//
//  QCloudSetSpaceTrafficLimitRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSetSpaceTrafficLimitRequest.h"
@implementation QCloudSetSpaceTrafficLimitRequest
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
    
    [__pathComponents addObject:@"traffic-limit"];
    self.requestData.URIComponents = __pathComponents;
    
    self.requestData.directBody = [@{@"downloadTrafficLimit":@(self.downloadTrafficLimit)} qcloud_modelToJSONData];
    return YES;
}

@end
