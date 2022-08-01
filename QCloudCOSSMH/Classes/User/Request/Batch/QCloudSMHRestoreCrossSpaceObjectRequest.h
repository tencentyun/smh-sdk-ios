//
//  QCloudSMHRestoreCrossSpaceObjectRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHUserBatchBaseRequest.h"
#import "QCloudSMHCrossSpaceRecycleItem.h"
NS_ASSUME_NONNULL_BEGIN

/// 批量恢复 （跨空间）
@interface QCloudSMHRestoreCrossSpaceObjectRequest : QCloudSMHUserBatchBaseRequest <QCloudSMHBatchInputRecycleInfo *>

@end

NS_ASSUME_NONNULL_END

