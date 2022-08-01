//
//  QCloudSMHUpdateGroupInviteInfoRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 编辑群组邀请信息
 */
@interface QCloudSMHUpdateGroupInviteInfoRequest : QCloudSMHUserBizRequest

///  邀请码;
@property (nonatomic, copy) NSString * code;

/// 1|0 是否可用
@property (nonatomic, strong) NSNumber * enabled;

/// 加入群组时的默认权限（几个者），仅群组邀请适用，可选参数；
@property (nonatomic, strong) NSNumber * authRoleId;

/// 1|0 是否允许外部用户
@property (nonatomic, strong) NSNumber * allowExternalUser;

/// ///  可选，用户加入企业的角色
/// QCloudSMHGroupRoleAdmin
/// QCloudSMHGroupRoleUser；
@property (nonatomic, assign) QCloudSMHGroupRole  groupRole;

/// 日期字符串，邀请码过期时间，可选参数；
@property (nonatomic, copy) NSString * expireTime;
@end

NS_ASSUME_NONNULL_END
