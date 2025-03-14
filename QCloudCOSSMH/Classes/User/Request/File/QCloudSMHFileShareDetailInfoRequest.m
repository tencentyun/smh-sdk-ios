//
//  QCloudSMHFileShareDetailInfoRequest.m
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHFileShareDetailInfoRequest.h"

@implementation QCloudSMHFileShareDetailInfoRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHShareUserInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.shareToken ) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[shareToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/share/url-detail/%@",self.shareToken]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHShareUserInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
