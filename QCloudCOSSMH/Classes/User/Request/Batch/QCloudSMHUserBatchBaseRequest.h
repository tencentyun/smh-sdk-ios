//
//  QCloudSMHBatchBaseRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHUserBatchBaseRequest.h"
#import "QCloudSMHGetTaskStatusRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHTaskResult.h"
#import "QCloudSMHUserService.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询异步任务状态。
 任务的具体返回请参阅会产生异步任务的接口说明，部分接口会根据任务耗时情况返回同步或异步结果，此时异步结果通常与同步结果的格式保持一致；
 */
@interface QCloudSMHUserBatchBaseRequest <BATCHTYPE> : QCloudHTTPRequest

@property (nonatomic,strong)NSArray *taskIdList;


@property (nonatomic)NSArray <BATCHTYPE>*batchInfos;

/// 用户令牌
@property (nonatomic,strong)NSString *userToken;

/// 组织 ID
@property (nonatomic,strong)NSString *organizationId;

- (void)startAsyncTask;
@end

NS_ASSUME_NONNULL_END
