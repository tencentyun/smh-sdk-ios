//
//  QCloudSMHUpdateQuotaByIdRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 按 ID 修改配额
@interface QCloudSMHUpdateQuotaByIdRequest : QCloudSMHBizRequest
/// 配额 ID
@property (nonatomic, strong) NSString *quotaId;
/// 配额所涵盖的租户空间（多租户空间媒体库）
@property (nonatomic, strong) NSArray<NSString *> *spaces;
/// 配额的具体值，单位为字节（Byte），字符串形式
@property (nonatomic, strong) NSString *capacity;
/// 是否在超限时自动删除文件，默认 NO
@property (nonatomic, assign) BOOL removeWhenExceed;
/// 存储量超限后在进行文件删除前等待的天数
@property (nonatomic, assign) NSInteger removeAfterDays;
/// 是否从最新的文件开始删除，默认 NO
@property (nonatomic, assign) BOOL removeNewest;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
