//
//  QCloudSMHBatchRestoreRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHBatchResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 批量恢复回收站文件
 */
@interface QCloudSMHBatchRestoreRecycleObjectReqeust : QCloudSMHBizRequest

/// 回收站项目 ID，必选参数；
@property (nonatomic,copy)NSArray * recycledItemIds;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
