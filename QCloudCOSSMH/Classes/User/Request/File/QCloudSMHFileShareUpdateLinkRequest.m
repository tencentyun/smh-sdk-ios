//
//  QCloudSMHFileShareUpdateLinkRequest.m
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHFileShareUpdateLinkRequest.h"


@implementation QCloudSMHFileShareUpdateLinkRequest
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
        QCloudURLSerilizerURLEncodingBody
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudSMHFileShareResult class])
        
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.shareInfo ) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[shareInfo] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *serverHost = [NSURL URLWithString:[_serverDomain stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"user/v1/share/%@/update/%@?user_token=%@",self.organizationId,self.shareId,self.userToken]]];
    self.requestData.serverURL = serverHost.absoluteString;
    [self.requestData setValue:serverHost.host forHTTPHeaderField:@"Host"];
    
    NSMutableDictionary * mParams = [NSMutableDictionary new];
    if (self.shareInfo.extractionCode) {
        [mParams setObject:self.shareInfo.extractionCode forKey:@"extractionCode"];
    }
    [mParams setObject:self.shareInfo.expireTime forKey:@"expireTime"];
    [mParams setObject:@(self.shareInfo.linkToLatestVersion) forKey:@"linkToLatestVersion"];
    [mParams setObject:@(self.shareInfo.canPreview) forKey:@"canPreview"];
    [mParams setObject:@(self.shareInfo.canDownload) forKey:@"canDownload"];
    [mParams setObject:@(self.shareInfo.canModify) forKey:@"canModify"];
    [mParams setObject:@(self.shareInfo.canSaveToNetDisc) forKey:@"canSaveToNetDisc"];
    [mParams setObject:@(self.shareInfo.disabled) forKey:@"disabled"];
    if (self.shareInfo.previewCount > 0) {
        [mParams setObject:@(self.shareInfo.previewCount) forKey:@"previewCount"];
    }
    if (self.shareInfo.downloadCount > 0) {
        [mParams setObject:@(self.shareInfo.downloadCount) forKey:@"downloadCount"];
    }
    [mParams setObject:@(self.shareInfo.isPermanent) forKey:@"isPermanent"];
    self.requestData.directBody = [mParams qcloud_modelToJSONData];;
    return YES;
}

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFileShareResult * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
