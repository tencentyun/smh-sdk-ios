//
//  QCloudSMHBatchRestoreSpaceRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCrossSpaceRecycleItem.h"
#import "QCloudSMHBatchResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 批量恢复回收站文件
 */
@interface QCloudSMHBatchRestoreSpaceRecycleObjectReqeust : QCloudSMHUserBizRequest

/// 回回收站数据集合
@property (nonatomic,copy)NSArray <QCloudSMHBatchInputRecycleInfo *> * recycledItems;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
