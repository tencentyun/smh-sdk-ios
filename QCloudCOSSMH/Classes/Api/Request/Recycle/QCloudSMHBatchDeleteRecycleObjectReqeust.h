//
//  QCloudSMHBatchDeleteRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 回收站批量删除
 */
@interface QCloudSMHBatchDeleteRecycleObjectReqeust : QCloudSMHBizRequest

/// 回收站项目 ID，必选参数；
@property (nonatomic,copy)NSArray<NSNumber *> * recycledItemIds;

@end

NS_ASSUME_NONNULL_END
