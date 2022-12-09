//
//  QCloudSMHNextSearchTeamRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHNextSearchTeamRequest.h"

@implementation QCloudSMHNextSearchTeamRequest
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
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHSearchTeamResult.class)

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.searchId || ([self.searchId isKindOfClass:NSString.class] && ((NSString *)self.searchId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[searchId] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }

    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/search"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"team"];
    [__pathComponents addObject:self.searchId];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:self.checkChildren?@"1":@"0" withKey:@"check_children"];
    [self.requestData setQueryStringParamter:self.marker withKey:@"marker"];

    return YES;
}

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchTeamResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
