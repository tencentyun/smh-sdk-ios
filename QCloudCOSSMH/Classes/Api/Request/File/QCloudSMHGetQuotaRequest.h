//
//  QCloudSMHGetQuotaRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHQuotaInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 获取租户空间配额
@interface QCloudSMHGetQuotaRequest : QCloudSMHBizRequest
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHQuotaInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
