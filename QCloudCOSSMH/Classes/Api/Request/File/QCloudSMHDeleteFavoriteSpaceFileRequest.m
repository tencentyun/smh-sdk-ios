//
//  QCloudSMHDeleteFavoriteSpaceFileRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHDeleteFavoriteSpaceFileRequest.h"
#import "QCloudTagModel.h"

@implementation QCloudSMHDeleteFavoriteSpaceFileRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/favorite"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    self.requestData.URIMethod = @"cancel";
    
    self.requestData.URIComponents = __pathComponents;
   
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    if (self.inode) {
        self.requestData.directBody = [@{@"inode":self.inode} qcloud_modelToJSONData];
    }
    if (self.path) {
        self.requestData.directBody = [@{@"path":self.path} qcloud_modelToJSONData];
    }
    return YES;
}

@end
