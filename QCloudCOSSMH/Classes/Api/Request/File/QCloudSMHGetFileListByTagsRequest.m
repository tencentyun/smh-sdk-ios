//
//  QCloudSMHGetFileListByTagsRequest.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHGetFileListByTagsRequest.h"

@implementation QCloudSMHGetFileListByTagsRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithJSONParamters
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudQueryTagFilesInfo.class)
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (self.tagList.count == 0) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[tagList] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"api/v1/file-tag"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"list"];
    
    NSMutableArray * mtags = [NSMutableArray new];
    for (QCloudFileQueryTagModel * tag in self.tagList) {
        NSMutableDictionary * mdic = [NSMutableDictionary new];
        if (tag.tagId) {
            [mdic  setValue:tag.tagId forKey:@"id"];
        }
        if (tag.tagValue) {
            [mdic setValue:tag.tagValue forKey:@"value"];
        }
        [mtags addObject:mdic];
    }
    
    self.requestData.directBody = [@{@"tagList":mtags} qcloud_modelToJSONData];
    
    self.requestData.URIComponents = __pathComponents;
    [self.requestData setQueryStringParamter:self.queryModel == QCloudFileQueryModelAnd ? @"and" : @"or" withKey:@"query_mode"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    return YES;
}

- (void)setFinishBlock:(void (^)(QCloudQueryTagFilesInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
