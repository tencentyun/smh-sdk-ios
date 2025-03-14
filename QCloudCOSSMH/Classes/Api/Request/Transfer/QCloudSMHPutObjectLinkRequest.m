//
//  QCloudSMHPutObjectLinkRequest.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHPutObjectLinkRequest.h"

@implementation QCloudSMHPutObjectLinkRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHPutObjectLinkInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
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
    
    
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    [__pathComponents addObject:self.filePath];
    
    NSDictionary * dic = @{@"linkTo":self.linkTo};
    NSData * data = [dic qcloud_modelToJSONData];

    self.requestData.directBody = data;
    
    self.requestData.URIComponents = __pathComponents;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }

    return YES;
}


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHPutObjectLinkInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
