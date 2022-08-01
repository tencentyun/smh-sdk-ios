//
//  QCloudSMHQuickPutObjectRequest.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHQuickPutObjectRequest.h"

@implementation QCloudSMHQuickPutObjectRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseDataAppendHeadersSerializerBlock
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
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    [__pathComponents addObject:self.filePath];
    
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    
    if (self.size) {
        [self.requestData setParameter:self.size withKey:@"filesize"];
    }
    
    self.requestData.URIComponents = __pathComponents;
   
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }

    if (self.createionDate) {
        [self.requestData setValue:self.createionDate forHTTPHeaderField:@"x-smh-meta-creation-date"];
    }
    
    NSMutableDictionary * params = NSMutableDictionary.new;
    if (self.fullHash) {
        [params setObject:self.fullHash forKey:@"fullHash"];
    }
    
    if (self.beginningHash) {
        [params setObject:self.beginningHash forKey:@"beginningHash"];
    }
    
    if (self.size) {
        [params setObject:self.size forKey:@"size"];
    }
    
    if (params.allKeys.count > 0) {
        self.requestData.directBody = [params qcloud_modelToJSONData];
    }
    
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
