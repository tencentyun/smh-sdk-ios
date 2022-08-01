//
//  QCloudSMHDeregisterRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 在指定组织中注销账户
 
 注销后，不可再登入该组织
 用户仅可注销自身
 超级管理员不可注销自身
 企业成员注销 30 天后/个人版或团队成员注销 15 天后，用户数据从系统中删除
 账号注销后，会向该用户其它设备推送 ws 消息 {"type": "deregister"}
 */
@interface QCloudSMHDeregisterRequest : QCloudSMHUserBizRequest

@end

NS_ASSUME_NONNULL_END
