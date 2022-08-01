//
//  QCloudSMHCrossSpaceCopyDirectoryRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHCrossSpaceCopyDirectoryRequest.h"

@implementation QCloudSMHCrossSpaceCopyDirectoryRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHCopyResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (!self.from) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[from] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    
    if (!self.fromSpaceId) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[fromSpaceId] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/cross-space/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:@"copy"];
    if (self.dirPath){
        [__pathComponents addObject:self.dirPath];
    }
    
    [self.requestData setQueryStringParamter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    
    NSDictionary * dic = @{@"copyFrom":self.from,@"copyFromSpaceId":self.fromSpaceId};
    
    NSData * data = [dic qcloud_modelToJSONData];
    self.requestData.directBody = data;

    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHCopyResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError *__autoreleasing  _Nullable *)error{
    return [super prepareInvokeURLRequest:urlRequest error:error];
}
@end
