//
//  QCloudSMHCollectFileRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHFavoriteFileRequest.h"

@implementation QCloudSMHFavoriteFileRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLSerilizerURLEncodingBody
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHFavoriteInfo.class)
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.spaceId || ([self.spaceId isKindOfClass:NSString.class] && ((NSString *)self.spaceId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[spaceId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.path || ([self.path isKindOfClass:NSString.class] && ((NSString *)self.path).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[path] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/favorite/%@?user_token=%@",self.organizationId,self.userToken]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableDictionary * mdic = @{@"spaceId":self.spaceId,@"path":self.path}.mutableCopy;
    
    if (self.favoriteGroupId) {
        [mdic setObject:self.favoriteGroupId forKey:@"favoriteGroupId"];
    }
    
    if (self.spaceOrgId) {
        [mdic setObject:@(self.spaceOrgId.integerValue) forKey:@"spaceOrgId"];
    }

    self.requestData.directBody = [mdic qcloud_modelToJSONData];

    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFavoriteInfo * result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
