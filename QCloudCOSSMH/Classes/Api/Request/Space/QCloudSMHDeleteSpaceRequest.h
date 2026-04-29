//
//  QCloudSMHDeleteSpaceRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 删除租户空间
@interface QCloudSMHDeleteSpaceRequest : QCloudSMHBizRequest
/// 是否强制删除，可选值：1-强制删除（不判断 space 是否为空）；0-非强制删除（不允许删除非空的 space），默认为 0
@property (nonatomic, assign) NSInteger force;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
