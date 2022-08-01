//
//  QCloudSMHDeleteObjectRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudSMHBatchBaseRequest.h"
#import "QCloudSMHBatchDeleteInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 批量删除
 封装了QCloudSMHBatchDeleteRequest 接口
 若返回结果为202 任务正在进行中，则轮询任务结果直到 200。
 */
@interface QCloudSMHDeleteObjectRequest : QCloudSMHBatchBaseRequest<QCloudSMHBatchDeleteInfo *>

@end

NS_ASSUME_NONNULL_END
