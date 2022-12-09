//
//  QCloudSMHAbortSearchTeamRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于删除搜索任务
 */
@interface QCloudSMHAbortSearchTeamRequest : QCloudSMHUserBizRequest

/**
 搜索任务 ID
 */
@property (nonatomic)NSString *searchId;
@end

NS_ASSUME_NONNULL_END
