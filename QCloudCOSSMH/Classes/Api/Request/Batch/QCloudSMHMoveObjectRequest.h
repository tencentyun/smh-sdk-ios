//
//  QCloudSMHMoveObjectRequest.h
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHBatchBaseRequest.h"
#import "QCloudSMHBatchMoveInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 批量移动
 封装了QCloudSMHBatchMoveRequest 接口
 若返回结果为202 任务正在进行中，则轮询任务结果直到 200。
 */
@interface QCloudSMHMoveObjectRequest : QCloudSMHBatchBaseRequest <QCloudSMHBatchMoveInfo *>
@end

NS_ASSUME_NONNULL_END
