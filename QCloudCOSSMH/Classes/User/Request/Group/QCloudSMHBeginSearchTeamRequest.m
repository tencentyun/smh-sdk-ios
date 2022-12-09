//
//  QCloudSMHBeginSearchTeamRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHBeginSearchTeamRequest.h"

@implementation QCloudSMHBeginSearchTeamRequest
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
        QCloudURLSerilizerURLEncodingBody,
        QCloudURLFuseWithJSONParamters
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock(QCloudSMHSearchTeamResult.class)

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }


    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingString:@"user/v1/search"]];
    self.requestData.serverURL = serverHost.absoluteString;
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    self.requestData.URIComponents = __pathComponents;
    [__pathComponents addObject:self.organizationId];
    [__pathComponents addObject:@"team"];
    
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    [self.requestData setQueryStringParamter:self.userToken withKey:@"user_token"];
    [self.requestData setQueryStringParamter:self.checkChildren?@"1":@"0" withKey:@"check_children"];
    [self.requestData setQueryStringParamter:self.checkManagementPermission?@"1":@"0" withKey:@"check_management_permission"];
    [self.requestData setQueryStringParamter:self.checkBelongingTeams?@"1":@"0" withKey:@"check_belonging_teams"];
    NSMutableDictionary * mparams = [NSMutableDictionary new];
    if(self.keyword != nil){
        [mparams setObject:self.keyword forKey:@"keyword"];
    }
    if(self.ancestorId != 0){
        [mparams setObject:@(self.ancestorId) forKey:@"ancestorId"];
    }
    self.requestData.directBody = [mparams qcloud_modelToJSONData];
    return YES;
}

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchTeamResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}


@end
