#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCreateShareResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 更新分享
/// @discussion 修改分享的名称、过期时间、提取码、权限等属性。
@interface QCloudSMHUpdateShareRequest : QCloudSMHBizRequest
/// 分享 ID
@property (nonatomic, strong) NSString *shareId;
/// 分享名称（可选）
@property (nonatomic, strong, nullable) NSString *name;
/// 是否永久有效，默认为 NO
@property (nonatomic, assign) BOOL isPermanent;
/// 过期时间，ISO 8601 格式，当 isPermanent 为 NO 时必选
@property (nonatomic, strong, nullable) NSString *expireTime;
/// 提取码（6位以下）
@property (nonatomic, strong, nullable) NSString *extractionCode;
/// 是否允许预览，默认为 NO
@property (nonatomic, assign) BOOL canPreview;
/// 是否允许下载，默认为 NO
@property (nonatomic, assign) BOOL canDownload;
/// 是否允许保存到网盘，默认为 NO
@property (nonatomic, assign) BOOL canSaveToNetdisk;
/// 是否禁止匿名用户访问，默认为 NO
@property (nonatomic, assign) BOOL forbidAnonymousUser;
/// 预览次数限制（canPreview 为 NO 时忽略）
@property (nonatomic, assign) NSInteger previewLimit;
/// 下载次数限制（canDownload 为 NO 时忽略）
@property (nonatomic, assign) NSInteger downloadLimit;
/// 访问用户数限制
@property (nonatomic, assign) NSInteger userLimit;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHCreateShareResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
