//
//  QCloudSMHTeamMemberInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/19.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
@class QCloudSMHTeamMemberInfo;
@class QCloudSMHTeamInfo;
NS_ASSUME_NONNULL_BEGIN
/**
 团队成员
 */
@interface QCloudSMHTeamContentInfo : NSObject

/// 整数，满足条件的用户总数
@property (nonatomic,strong)NSString *totalNum;

/// 整数，分页码；
@property (nonatomic,strong)NSString *page;

/// 整数，分页大小；
@property (nonatomic,strong)NSString *pageSize;

///  对象数组，用户具体信息：
@property (nonatomic,strong)NSArray <QCloudSMHTeamMemberInfo *> *contents;
@end

@interface QCloudSMHTeamMemberInfo : NSObject

/// 整数，用户 ID
@property (nonatomic,strong)NSString *userId;

/// 组织id
@property (nonatomic,strong)NSString *orgId;

/// 字符串，手机号国家码
@property (nonatomic,strong)NSString *countryCode;

///  字符串，手机号码
@property (nonatomic,strong)NSString *phoneNumber;

/// 字符串，昵称
@property (nonatomic,strong)NSString *nickname;

/// 字符串，邮箱
@property (nonatomic,strong)NSString *email;

/// 字符串，备注
@property (nonatomic,strong)NSString *comment;

///  字符串，用户角色，'superAdmin' | 'admin' | 'user'
@property (nonatomic,assign)QCloudSMHOrgUserRole role;

/// 布尔值，是否禁用
@property (nonatomic,assign)BOOL enabled;

@property (nonatomic, assign) BOOL deregister;

@property (nonatomic, assign) BOOL inactive;

/// 用户头像链接
@property (nonatomic,strong)NSString *avatar;

/// 是否允许分配个人空间；
@property (nonatomic,strong)NSString *allowPersonalSpace;

/// 个人空间存储额度，单位 Byte，仅当 WithSpaceUsage = true 时返回
@property (nonatomic,strong)NSString *capacity;

/// 个人空间剩余可使用存储额度，单位 Byte，仅当 WithSpaceUsage = true 时返回
@property (nonatomic,strong)NSString *availableSpace;

/// 用户所属团队列表，仅当 WithBelongingTeams = true 时返回
@property (nonatomic,strong)NSArray <QCloudSMHTeamInfo *> *teams;

@property (nonatomic,strong)NSArray *teamIds;



@end

NS_ASSUME_NONNULL_END
