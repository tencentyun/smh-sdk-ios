//
//  QCloudSMHGetDownloadInfoRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHGetDownloadInfoRequest.h"
#import "QCloudSMHContentListInfo.h"
#import "QCloudSMHDownloadInfoModel.h"
@implementation QCloudSMHGetDownloadInfoRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithURLEncodeParamters,
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHDownloadInfoModel class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.filePath || ([self.filePath isKindOfClass:NSString.class] && ((NSString *)self.filePath).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[filePath] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    self.requestData.URIMethod = @"info";
    

    if (self.historyId > 0) {
        [self.requestData setQueryStringParamter:@(self.historyId).stringValue withKey:@"history_id"];
    }
    if (self.trafficLimit > 0) {
        [self.requestData setQueryStringParamter:@(self.trafficLimit).stringValue withKey:@"traffic_limit"];
    }
    
    [self.requestData setQueryStringParamter:@(self.preCheck).stringValue withKey:@"pre_check"];
    
    [self.requestData setQueryStringParamter:QCloudSMHPurposeTypeTransferToString(self.purpose) withKey:@"purpose"];
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath){
        [__pathComponents addObject:self.filePath];
    }
    //这里不能设置host，因为请求是重定向到 cos的，这样会导致重定向后的request的host有问题，导致400
//    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHDownloadInfoModel *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
