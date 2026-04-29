#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHVerifyExtractionCodeResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 验证提取码（无需认证，公开访问接口）
@interface QCloudSMHVerifyExtractionCodeRequest : QCloudSMHBaseRequest
/// 分享 Code
@property (nonatomic, strong) NSString *shareCode;
/// 提取码
@property (nonatomic, strong) NSString *extractionCode;
/// 访问者的媒体库 ID，当分享要求登录时必选
@property (nonatomic, strong, nullable) NSString *libraryId;
/// 访问者的访问令牌，当分享要求登录时必选
@property (nonatomic, strong, nullable) NSString *accessToken;
/// 设备 ID
@property (nonatomic, strong, nullable) NSString *deviceId;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHVerifyExtractionCodeResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
