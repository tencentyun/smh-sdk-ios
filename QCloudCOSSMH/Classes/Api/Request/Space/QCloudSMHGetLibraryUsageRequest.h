//
//  QCloudSMHGetLibraryUsageRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHLibraryUsageInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 查询媒体库容量信息
@interface QCloudSMHGetLibraryUsageRequest : QCloudSMHBizRequest
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHLibraryUsageInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
