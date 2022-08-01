//
//  QCloudSMHInviteModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHBaseContentInfo.h"
@class QCloudSMHInviteOrgInfoModel;
@class QCloudSMHInvitorInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHInviteGroupCodeInfoModel : NSObject

@property (nonatomic,strong)NSString *inviteId;

///  整数，邀请的组织 ID；
@property (nonatomic,strong)NSString *orgId;

/// 整数，发起邀请用户 ID；
@property (nonatomic,strong)NSString *userId;

/// admin/user
@property (nonatomic,strong)NSString *role;

/// 字符串，邀请码；
@property (nonatomic,strong)NSString *code;

/// "org" | "group"
@property (nonatomic,strong)NSString *type;

/// 时间戳字符串，邀请码创建时间；
@property (nonatomic,strong)NSString *creationTime;

/// 布尔值，是否已加入邀请对象，未登录用户固定为 false；
@property (nonatomic,assign)BOOL hasJoined;

/// 时间戳字符串，邀请码过期时间；
@property (nonatomic,strong)NSString *expireTime;

/// 布尔值，是否允许外部人员加入群组，企业邀请码固定返回 true；
@property (nonatomic,assign)BOOL allowExternalUser;

/// 布尔值，邀请码是否启用；
@property (nonatomic,assign)BOOL enabled;

/// /// 整数，群组 ID，仅群组邀请码返回，非必返；
@property (nonatomic,strong)NSString *groupId;

/// 布尔值，邀请码是否已过期；
@property (nonatomic,strong)NSString *expired;
@property (nonatomic,strong)NSString *authRoleId;

/// 整数，通过邀请链接加入的人数；
@property (nonatomic,assign)NSInteger invitedCount;

/// 整数，当前群组的人数，仅群组邀请码返回，非必返；
@property (nonatomic,assign)NSInteger currentGroupUserCount;

/// 整数，当前企业的人数，仅企业邀请码返回，非必返；
@property (nonatomic,assign)NSInteger currentOrgUserCount;

/// 邀请者信息
@property (nonatomic,strong)QCloudSMHInvitorInfoModel *invitor;

/// 组织信息
@property (nonatomic,strong)QCloudSMHInviteOrgInfoModel *organization;

/// 邀请加入的群组信息，仅群组邀请码返回，非必返；
@property (nonatomic,strong)QCloudSMHContentGroupInfo *group;

@end


@interface QCloudSMHInviteOrgCodeInfoModel : QCloudSMHInviteGroupCodeInfoModel

/// 'personal', 表示个人版
/// 'team', 表示团队版
/// 'enterprise', 表示企业版
@property (nonatomic,assign) QCloudSMHOrganizationType editionFlag;

@end

@interface QCloudSMHInviteOrgInfoModel : NSObject

/// 字符串，组织名称
@property (nonatomic,strong)NSString *name;

/// 字符串，所在组织 logo 链接
@property (nonatomic,strong)NSString *logo;

@end

@interface QCloudSMHCodeResult : NSObject

/// 字符串，邀请码；
@property (nonatomic,strong)NSString *code;

@end

@interface QCloudSMHInvitorInfoModel : NSObject

/// 整数，邀请者用户 ID;
@property (nonatomic,strong)NSString *userId;

/// 整数，邀请者所属组织 ID;
@property (nonatomic,strong)NSString *orgId;

/// 字符串，邀请者昵称；
@property (nonatomic,strong)NSString *nickname;

/// 字符串，邀请者头像链接；
@property (nonatomic,strong)NSString *avatar;

@end


@interface QCloudSMHJoinResult : NSObject

/// 布尔值，是否成功加入；
@property (nonatomic,assign)BOOL isSuccess;

/// 布尔值，是否通过本次邀请加入；false - 通过本次邀请加入， true - 以前就已加入；
@property (nonatomic,assign)BOOL isNew;


@end
NS_ASSUME_NONNULL_END
