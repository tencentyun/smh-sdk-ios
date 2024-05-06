//
//  QCloudSMHGetRecentlyUsedFileRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHGetRecentlyUsedFileRequest.h"

@implementation QCloudSMHGetRecentlyUsedFileRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHRecentlyUsedFileInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/recent"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"recently-used-file"];
    self.requestData.URIComponents = __pathComponents;
    
    NSMutableDictionary * body = [NSMutableDictionary new];
    
    if(self.limit>0){
        [body setObject:@(self.limit).stringValue forKey:@"limit"];
    }
    if(self.marker.length>0){
        [body setObject:self.marker forKey:@"marker"];
    }
    
    if (self.filterActionBy) {
        [body setObject:self.filterActionBy forKey:@"filterActionBy"];
    }

    if ([self.type containsObject:@"all"]) {
        [body setObject:@"all" forKey:@"type"];
    }else{
        [body setObject:self.type forKey:@"type"];
    }
    
    [body setObject:@(self.withPath) forKey:@"withPath"];
    
    if (body.allKeys.count > 0) {
        NSData * data = [body qcloud_modelToJSONData];
        self.requestData.directBody = data;
    }
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecentlyUsedFileInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
