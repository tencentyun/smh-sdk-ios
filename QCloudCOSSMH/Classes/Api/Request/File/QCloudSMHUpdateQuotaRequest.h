//
//  QCloudSMHUpdateQuotaRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 修改配额
@interface QCloudSMHUpdateQuotaRequest : QCloudSMHBizRequest
/// 容量限制（字节），字符串形式
@property (nonatomic, strong) NSString *capacity;
/// 超限时是否自动删除文件，默认 NO
@property (nonatomic, assign) BOOL removeWhenExceed;
/// 超限后等待多少天再删除
@property (nonatomic, assign) NSInteger removeAfterDays;
/// 是否从最新的文件开始删除，默认 NO
@property (nonatomic, assign) BOOL removeNewest;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
