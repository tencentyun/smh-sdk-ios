//
//  QCloudSMHRenameFileRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/19.
//

#import "QCloudSMHRenameFileRequest.h"

@implementation QCloudSMHRenameFileRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseWithJSONParamters,
    
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHRenameResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    if (self.filePath){
        [__pathComponents addObject:self.filePath];
    }
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setParameter:QCloudSMHConflictStrategyByTransferToString(self.conflictStrategy) withKey:@"conflict_resolution_strategy"];
    [self.requestData setQueryStringParamter:self.moveAuthority?@"true":@"false" withKey:@"move_authority"];
    
    if (self.from.length > 1 && [[self.from substringToIndex:1] isEqualToString:@"/"]) {
        self.from = [self.from substringFromIndex:1];
    }
    
    NSDictionary * dic = @{@"from":self.from?:@""};
    NSData * data = [dic qcloud_modelToJSONData];
    self.requestData.directBody = data;

    return YES;
}
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
