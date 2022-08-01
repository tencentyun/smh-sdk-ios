//
//  QCloudDeleteLocalSyncRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 删除本地盘同步任务
 */
@interface QCloudDeleteLocalSyncRequest : QCloudSMHBizRequest

/**
 SyncId: 同步任务 ID，必须指定该参数；
 */
@property (nonatomic,strong)NSString * syncId;

@end

NS_ASSUME_NONNULL_END
