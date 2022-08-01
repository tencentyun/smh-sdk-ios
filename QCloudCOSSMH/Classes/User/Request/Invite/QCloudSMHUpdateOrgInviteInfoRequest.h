//
//  QCloudSMHUpdateOrgInviteInfoRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 编辑企业邀请信息
 */
@interface QCloudSMHUpdateOrgInviteInfoRequest : QCloudSMHUserBizRequest

///  邀请码;
@property (nonatomic, copy) NSString * code;

/// 1|0 是否可用
@property (nonatomic, strong) NSNumber * enabled;

///  可选，用户加入企业的角色 user|admin；
@property (nonatomic, assign) QCloudSMHGroupRole  role;

/// 日期字符串，邀请码过期时间，可选参数；
@property (nonatomic, copy) NSString * expireTime;

@end

NS_ASSUME_NONNULL_END
