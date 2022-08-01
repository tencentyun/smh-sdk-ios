//
//  QCloudSMHListGroupMemberInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
@class QCloudSMHListGroupMember;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHListGroupMemberInfo : NSObject
@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, strong) NSArray <QCloudSMHListGroupMember *>*contents;
@end

@interface QCloudSMHListGroupMember : NSObject

///  用户 ID
@property (nonatomic, strong) NSString * userId;

///  用户国家码
@property (nonatomic, strong) NSString * countryCode;

///  用户手机号
@property (nonatomic, strong) NSString * phoneNumber;

///  用户昵称
@property (nonatomic, strong) NSString * nickname;

///  群组角色
/// 用户在该群组的角色 owner | groupAdmin | user
@property (nonatomic,assign)QCloudSMHGroupRole groupRole;

/// 用户在群组中的权限，普通用户返回数字，群主和群组管理员返回 null
@property (nonatomic, strong) NSString * authRoleId;

/// 用户是否是启用状态
@property (nonatomic, assign) BOOL enabled;

/// 是否注销
@property (nonatomic, assign) BOOL deregister;

/// 是否为外部人员
@property (nonatomic, assign) BOOL isExternal;

/// 用户头像
@property (nonatomic, strong) NSString * avatar;

/// 群组id
@property (nonatomic,copy) NSString *groupId;

/// 组织id
@property (nonatomic,copy) NSString *orgId;

@end

NS_ASSUME_NONNULL_END

