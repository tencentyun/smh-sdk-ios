//
//  QCloudSMHGetSpaceExtensionRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSpaceExtensionInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 查询租户空间属性
@interface QCloudSMHGetSpaceExtensionRequest : QCloudSMHBizRequest
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpaceExtensionInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
