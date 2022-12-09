//
//  QCloudSMHEditFileOnlineRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHEditFileOnlineRequest.h"

@implementation QCloudSMHEditFileOnlineRequest
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

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/office"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"edit"];
    [__pathComponents addObject:self.filePath];
    self.requestData.URIComponents = __pathComponents;
    return YES;
}
-(void)setFinishBlock:(void (^ _Nullable)(NSString * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
