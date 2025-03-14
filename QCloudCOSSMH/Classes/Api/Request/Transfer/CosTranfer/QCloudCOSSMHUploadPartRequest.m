
#import "QCloudCOSSMHUploadPartRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import "QCloudSMHUploadPartResult.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudCOSSMHUploadPartRequest


- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

        QCloudResponseAppendHeadersSerializerBlock,

        QCloudResponseObjectSerilizerBlock([QCloudSMHUploadPartResult class])
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
    [self.requestData setNumberParamter:@(self.partNumber) withKey:@"partNumber"];
    if (!self.uploadId || ([self.uploadId isKindOfClass:NSString.class] && ((NSString *)self.uploadId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[uploadId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    [self.requestData setParameter:self.uploadId withKey:@"uploadId"];
   
    self.requestData.directBody = self.body;
    
    if (self.renewUploadInfo) {
        self.customHeaders = self.renewUploadInfo();
    }
    
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHUploadPartResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    if ([self.requestData.directBody isKindOfClass:[QCloudFileOffsetBody class]]) {
        QCloudFileOffsetBody * directBody = self.requestData.directBody;
        if (!QCloudFileExist(directBody.fileURL.path)) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"指定的上传路径不存在"];
            return NO;
        }
    }
    return YES;
}
@end
NS_ASSUME_NONNULL_END
