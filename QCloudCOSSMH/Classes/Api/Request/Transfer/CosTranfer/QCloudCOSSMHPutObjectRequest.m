
#import "QCloudCOSSMHPutObjectRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import <QCloudCore/QCloudFileUtils.h>
#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
@implementation QCloudCOSSMHPutObjectRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
    ];

    if([QCloudSMHBizRequest getServerType] == QCloudSMHServerPublicCloud){
         [customRequestSerilizers.mutableCopy addObject:QCloudURLFuseContentMD5Base64StyleHeaders];
        customRequestSerilizers = customRequestSerilizers.copy;
    }
    
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

        QCloudResponseAppendHeadersSerializerBlock,
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *__serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,self.path]];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];

    [self.customHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestData setValue:obj forHTTPHeaderField:key];
    }];
 
    
    
    self.requestData.directBody = self.body;
    return YES;
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    return YES;
}

@end
NS_ASSUME_NONNULL_END
