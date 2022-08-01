//
//  QCloudSMHCopyObjectRequest.h
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHBatchBaseRequest.h"
#import "QCloudSMHBatchCopyInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 批量复制
 封装了QCloudSMHBatchCopyRequest 接口
 若返回结果为202 任务正在进行中，则轮询任务结果直到 200。
 */
@interface QCloudSMHCopyObjectRequest : QCloudSMHBatchBaseRequest<QCloudSMHBatchCopyInfo *>

@property (nonatomic,assign)NSString * shareAccessToken;
@end

NS_ASSUME_NONNULL_END
