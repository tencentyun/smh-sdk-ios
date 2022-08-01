//
//  QCloudSMHBatchResult.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//  每一个批量任务的结果

#import <Foundation/Foundation.h>
#import "QCloudSMHBatchTaskStatusEnum.h"
@class QCloudSMHTaskResult;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHBatchResult : NSObject
//任务ID
@property (nonatomic)NSString *taskId;
//批量任务总的状态：
@property (nonatomic)QCloudSMHBatchTaskStatus status;

//总的任务数量（如果该任务支持返回 total)；
@property (nonatomic)NSInteger  total;

//批量操作的任务的结果集
@property (nonatomic)NSArray<QCloudSMHTaskResult *>*result;



@end

NS_ASSUME_NONNULL_END
