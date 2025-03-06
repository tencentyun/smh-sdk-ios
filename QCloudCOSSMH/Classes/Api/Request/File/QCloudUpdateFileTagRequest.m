//
//  QCloudUpdateFileTagRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2025/2/27.
//

#import "QCloudUpdateFileTagRequest.h"
@implementation QCloudUpdateFileTagRequest
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
    if (self.filePath) {
        [__pathComponents addObject:self.filePath];
    }
    self.requestData.URIComponents = __pathComponents;
    self.requestData.URIMethod = @"update";
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    if (self.labels) {
        [params setObject:self.labels forKey:@"labels"];
    }
    if (self.category) {
        [params setObject:self.category forKey:@"category"];
    }
    if (self.localCreationTime) {
        [params setObject:self.localCreationTime forKey:@"localCreationTime"];
    }
    if (self.localModificationTime) {
        [params setObject:self.localModificationTime forKey:@"localModificationTime"];
    }
    if (params.allKeys.count > 0) {
        NSData * data = [params qcloud_modelToJSONData];
        self.requestData.directBody = data;
    }
    
    return YES;
}

@end
