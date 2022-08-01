//
//  QCloudSMHUploadPersonalInfoRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUploadPersonalInfoRequest.h"

@implementation QCloudSMHUploadPersonalInfoRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHUploadPersonalInfoResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/store"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    self.requestData.directBody = [@{@"idfv":self.idfv?:@"",
                                     @"model":self.model?:@"",
                                     @"system":self.system?:@""} qcloud_modelToJSONData];
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHUploadPersonalInfoResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
