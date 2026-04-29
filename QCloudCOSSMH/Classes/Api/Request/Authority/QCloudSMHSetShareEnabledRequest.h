#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 禁用或启用分享
/// @discussion 管理员可设置 adminEnabled，创建者可设置 ownerEnabled，分享在两者都为 YES 时才可用。
@interface QCloudSMHSetShareEnabledRequest : QCloudSMHBizRequest
/// 分享 ID
@property (nonatomic, strong) NSString *shareId;
/// 管理员启用状态（只有管理员和群组管理员可以设置）
@property (nonatomic, assign) BOOL adminEnabled;
/// 创建者启用状态（创建者可以设置）
@property (nonatomic, assign) BOOL ownerEnabled;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
