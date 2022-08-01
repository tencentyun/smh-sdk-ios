//
//  QCloudSMHGetFileAuthorityRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHGetFileAuthorityRequest.h"


@implementation QCloudSMHGetFileAuthorityRequest
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
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudFileAutthorityInfo class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/authority"]];
    
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    
    if (!self.organizationId) {
        *error = [NSError
            qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                         message:[NSString stringWithFormat:
                                               @"InvalidArgument:paramter[organizationId] is invalid (nil), it must have some value. please check it"]];
        return NO;
    }
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"directory-authority"];
    if (!self.dirPath) {
        *error = [NSError
            qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                         message:[NSString stringWithFormat:
                                               @"InvalidArgument:paramter[dirPath] is invalid (nil), it must have some value. please check it"]];
        return NO;
    }
    [__pathComponents addObject:self.dirPath];
    
    self.requestData.URIComponents = __pathComponents;
    
    
    [self.requestData setQueryStringParamter:self.dirLibraryId withKey:@"dirLibraryId"];
    [self.requestData setQueryStringParamter:self.dirSpaceId withKey:@"dirSpaceId"];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    return YES;
}

- (void)setFinishBlock:(void (^)(NSArray <QCloudFileAutthorityInfo *> *_Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

@end
