//
//  QCloudSMHRecycleSetLifecycleRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 设置回收站生命周期
@interface QCloudSMHRecycleSetLifecycleRequest : QCloudSMHBizRequest
/// 回收站保留天数，取值范围 1-10000，必选参数
@property (nonatomic, assign) NSInteger retentionDays;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
