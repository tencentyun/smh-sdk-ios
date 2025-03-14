//
//  QCloudSMHCreateFileRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHCreateFileRequest.h"

@implementation QCloudSMHCreateFileRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHContentInfo class])
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
    [__pathComponents addObject:self.filePath];
    self.requestData.URIComponents = __pathComponents;

    NSDictionary * dic = @{@"fromTemplate":QCloudSMHFileTemplateTransferToString(self.fromTemplate)};
    NSData * data = [dic qcloud_modelToJSONData];
    self.requestData.directBody = data;

    return YES;
}
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
