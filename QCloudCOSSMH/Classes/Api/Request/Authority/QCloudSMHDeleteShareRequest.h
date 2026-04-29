//
//  QCloudSMHDeleteShareRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/24.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 删除分享
@interface QCloudSMHDeleteShareRequest : QCloudSMHBizRequest
/// 分享 ID
@property (nonatomic, strong) NSString *shareId;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
