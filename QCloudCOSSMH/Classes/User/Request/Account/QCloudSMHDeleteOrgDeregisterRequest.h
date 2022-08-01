//
//  QCloudSMHDeleteOrgDeregisterRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 在企业成员注销犹豫期，驳回其它成员提交的注销操作
 
 超管可以驳回系统管理员和普通用户的注销
 系统管理员可以驳回普通用户的注销
 成员注销 30 天后，用户数据从系统中删除，不可撤消注销
 仅适用于企业版
 */
@interface QCloudSMHDeleteOrgDeregisterRequest : QCloudSMHUserBizRequest

/**
 驳回的用户 ID，必选参数
 */
@property (nonatomic,strong)NSString *userId;
@end

NS_ASSUME_NONNULL_END
