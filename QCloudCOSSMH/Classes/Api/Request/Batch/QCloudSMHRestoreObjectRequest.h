//
//  QCloudSMHRestoreObjectRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHBatchBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 批量恢复
 封装了QCloudSMHBatchRestoreRecycleObjectReqeust 接口
 若返回结果为202 任务正在进行中，则轮询任务结果直到 200。
 */
@interface QCloudSMHRestoreObjectRequest : QCloudSMHBatchBaseRequest <NSString *>

@end

NS_ASSUME_NONNULL_END
