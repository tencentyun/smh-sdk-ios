//
//  QCloudSMHDeleteFileRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/17.
//

#import "QCloudSMHDeleteFileRequest.h"

@implementation QCloudSMHDeleteFileRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHDeleteResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"delete";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath){
        [__pathComponents addObject:self.filePath];
    }
    [self.requestData setQueryStringParamter:@(self.permanent).stringValue withKey:@"permanent"];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
