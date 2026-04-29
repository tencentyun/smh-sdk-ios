//
//  QCloudSMHCreateQuotaRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHQuotaInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 创建配额
/// @discussion 用于创建配额。配额与租户空间是一对多的关系，即多个租户空间可以共享同一个配额，但每个租户空间只能设置一个配额。
@interface QCloudSMHCreateQuotaRequest : QCloudSMHBizRequest
/// 配额所涵盖的租户空间 ID 列表，可选参数。对于多租户空间媒体库，指定配额所涵盖的租户空间，不支持传空数组；对于单租户空间，不能指定该字段
@property (nonatomic, strong, nullable) NSArray<NSString *> *spaces;
/// 配额的具体值，单位为字节（Byte），字符串形式，为了避免大数产生的精度损失，建议指定为字符串形式
@property (nonatomic, strong, nullable) NSString *capacity;
/// 超限时是否自动删除文件，必选参数。
/// 当为 NO 时，配额仅用于上传时判断是否有足够空间；
/// 当为 YES 时，将在 removeAfterDays 天数到达后开始删除文件以保证存储量在配额之下
@property (nonatomic, assign) BOOL removeWhenExceed;
/// 存储量超限后在进行文件删除前等待的天数，必选参数
@property (nonatomic, assign) NSInteger removeAfterDays;
/// 是否从最新的文件开始删除，默认 NO（即从最旧的文件开始删除），可选参数
@property (nonatomic, assign) BOOL removeNewest;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHQuotaInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
