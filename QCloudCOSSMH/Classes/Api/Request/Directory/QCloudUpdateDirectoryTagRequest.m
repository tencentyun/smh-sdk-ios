//
//  QCloudUpdateDirectoryTagRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2025/2/27.
//

#import "QCloudUpdateDirectoryTagRequest.h"
@implementation QCloudUpdateDirectoryTagRequest
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
        QCloudURLFuseWithURLEncodeParamters
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

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.dirPath) {
        [__pathComponents addObject:self.dirPath];
    }
    
    self.requestData.URIComponents = __pathComponents;
    self.requestData.URIMethod = @"update";
    
    if (self.labels) {
        NSData * data = [@{@"labels":self.labels} qcloud_modelToJSONData];
        self.requestData.directBody = data;
    }
    return YES;
}

@end
