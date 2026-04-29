//
//  QCloudSMHGetQuotaInfoRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHQuotaDetailInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 获取租户配额信息
@interface QCloudSMHGetQuotaInfoRequest : QCloudSMHBizRequest
/// 配额 ID
@property (nonatomic, strong) NSString *quotaId;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHQuotaDetailInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
