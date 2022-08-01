//
//  QCloudGetTaskStatusRequest.h
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHBatchResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询任务接口
 */
@interface QCloudGetTaskStatusRequest : QCloudSMHBizRequest

/// 任务 ID 列表，用逗号分隔，例如 10 或 10,12,13；
@property (nonatomic,strong)NSArray *taskIdList;

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHBatchResult *>* _Nullable result, NSError * _Nullable error))finishBlock;
@end

NS_ASSUME_NONNULL_END
