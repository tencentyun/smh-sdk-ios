#import "QCloudSMHBizRequest.h"
#import "QCloudSMHShareDetail.h"
NS_ASSUME_NONNULL_BEGIN
/// 获取分享详情
@interface QCloudSMHGetShareDetailRequest : QCloudSMHBizRequest
/// 分享 ID，必选参数（格式为经过编码的复合ID，包含分享ID和创建者ID信息）
@property (nonatomic, strong) NSString *shareId;
/// 是否返回文件信息
@property (nonatomic, assign) BOOL withFileInfo;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareDetail *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
