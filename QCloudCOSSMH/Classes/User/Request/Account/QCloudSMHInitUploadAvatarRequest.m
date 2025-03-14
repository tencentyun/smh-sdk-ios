//
//  QCloudSMHInitUploadAvatarRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/31.
//

#import "QCloudSMHInitUploadAvatarRequest.h"

@implementation QCloudSMHInitUploadAvatarRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHInitUploadInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.userToken) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[userToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.fileExt) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[fileExt] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
 
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/file/avatar"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    
    
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:self.fileExt withKey:@"ext"];

    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
