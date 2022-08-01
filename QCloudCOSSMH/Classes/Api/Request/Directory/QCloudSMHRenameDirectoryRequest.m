//
//  QCloudSMHRenameDirecotryRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHRenameDirectoryRequest.h"

@implementation QCloudSMHRenameDirectoryRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseWithJSONParamters,
    
        
    ];

    NSMutableArray *responseSerializers = [NSMutableArray arrayWithObject:QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil)];
    if(self.conflictStrategy != QCloudSMHConflictStrategyEnumAsk){
        [responseSerializers addObjectsFromArray:@[QCloudResponseJSONSerilizerBlock,
                                                   QCloudResponseObjectSerilizerBlock([QCloudSMHRenameResult class])]];
        
    }
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/directory"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.dirPath){
        [__pathComponents addObject:self.dirPath];
    }
    NSError *_error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"from":self.from} options:0 error:&_error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.requestData.directBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:self.moveAuthority?@"true":@"false" withKey:@"move_authority"];
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
