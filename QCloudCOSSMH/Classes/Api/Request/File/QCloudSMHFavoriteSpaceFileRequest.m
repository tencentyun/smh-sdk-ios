//
//  QCloudSMHFavoriteSpaceFileRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHFavoriteSpaceFileRequest.h"
#import "QCloudSMHFavoriteSpaceFileResult.h"

@implementation QCloudSMHFavoriteSpaceFileRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHFavoriteSpaceFileResult class])
        
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

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFavoriteSpaceFileResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
