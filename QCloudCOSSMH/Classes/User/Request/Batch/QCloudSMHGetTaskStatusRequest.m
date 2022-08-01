//
//  QCloudSMHGetTaskStatusRequest.m
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHGetTaskStatusRequest.h"

@implementation QCloudSMHGetTaskStatusRequest
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
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHBatchResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/task"]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:self.organizationId];
    if(self.taskIdList.count){
        NSString *taskidList = [self.taskIdList componentsJoinedByString:@","];
        [__pathComponents addObject:taskidList];
    }
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    self.requestData.URIComponents = __pathComponents;

    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHBatchResult * > * _Nullable result, NSError * _Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}

@end
