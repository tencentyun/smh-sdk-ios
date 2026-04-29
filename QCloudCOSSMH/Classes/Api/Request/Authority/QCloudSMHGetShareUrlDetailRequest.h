#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHShareUrlDetail.h"
NS_ASSUME_NONNULL_BEGIN
/// 获取分享URL详情（无需认证，公开访问接口）
@interface QCloudSMHGetShareUrlDetailRequest : QCloudSMHBaseRequest
/// 分享 Token
@property (nonatomic, strong) NSString *shareToken;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareUrlDetail *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
