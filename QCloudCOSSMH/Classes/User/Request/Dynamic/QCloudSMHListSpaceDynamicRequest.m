//
//  QCloudSMHListSpaceDynamicRequest.m
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHListSpaceDynamicRequest.h"

@implementation QCloudSMHListSpaceDynamicRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHSpaceDynamicList.class)
        
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/dynamic/%@/list",self.organizationId]]];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    if (self.spaceOrgId) {
        [params setValue:@(self.spaceOrgId.integerValue) forKey:@"spaceOrgId"];
    }
    
    if (self.spaceId) {
        [params setValue:self.spaceId forKey:@"spaceId"];
    }
    
    if (self.startTime) {
        [params setValue:self.startTime forKey:@"startTime"];
    }
    
    if (self.endTime) {
        [params setValue:self.endTime forKey:@"endTime"];
    }
    
    if (self.dirPath) {
        [params setValue:self.dirPath forKey:@"dirPath"];
    }
    
    if (self.actionTypeDetail > 0) {
        [params setValue:[QCloudSMHDynamicActionDetailTypeTransferToString(self.actionTypeDetail) componentsJoinedByString:@"|"] forKey:@"actionTypeDetail"];
    }
    
    self.requestData.directBody = [params qcloud_modelToJSONData];
    
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpaceDynamicList * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
