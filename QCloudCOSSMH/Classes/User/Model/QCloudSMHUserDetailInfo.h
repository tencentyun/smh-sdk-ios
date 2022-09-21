//
//  QCloudSMHUserDetailInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
@class QCloudSMHUserDetailInfoTeamItem;
@class QCloudSMHUserDetailWechatUser;
@class QCloudSMHUserThirdPartyAuthListInfo;

NS_ASSUME_NONNULL_BEGIN
/**
 用户信息详情
 */
@interface QCloudSMHUserDetailInfo : NSObject

/// 上次登录组织 ID
@property (nonatomic,strong)NSString *lastSignedInOrgId;

/// 手机号国家码
@property (nonatomic,strong)NSString *countryCode;

/// 手机号码
@property (nonatomic,strong)NSString *phoneNumber;

/// 昵称
@property (nonatomic,strong)NSString *nickname;

/// 邮箱
@property (nonatomic,strong)NSString *email;

/// 备注
@property (nonatomic,strong)NSString *comment;

/// 'superAdmin' | 'admin' | 'user'
@property (nonatomic,assign)QCloudSMHOrgUserRole role;

/// 用户 ID
@property (nonatomic,strong)NSString *userId;

/// 是否禁用
@property (nonatomic,assign)BOOL enabled;

/// 是否注销
@property (nonatomic, assign) BOOL deregister;

@property (nonatomic,strong)NSArray * canManageTeams;

/// 头像
@property (nonatomic,strong)NSString *avatar;

@property (nonatomic,strong)NSString *allowPersonalSpace;

@property (nonatomic,strong)NSArray <QCloudSMHUserDetailInfoTeamItem *> *teams;

/// 第三方授权
@property (nonatomic,strong)QCloudSMHUserThirdPartyAuthListInfo *thirdPartyAuthList;

@property (nonatomic,strong)QCloudSMHUserDetailWechatUser *wechatUser;

@end

@interface QCloudSMHUserDetailInfoTeamItem : NSObject

/// 团队id
@property (nonatomic,strong)NSString *teamId;

/// 团队名称
@property (nonatomic,strong)NSString *name;

@end

@interface QCloudSMHUserDetailWechatUser : NSObject

/// 微信昵称
@property (nonatomic,strong)NSString *nickname;

/// 微信头像
@property (nonatomic,strong)NSString *headimgurl;

@end

@interface QCloudSMHUserThirdPartyAuthListInfo : NSObject


/// 是否绑定腾讯会议账号
@property (nonatomic,assign)BOOL meeting;

/// 是否绑定微信
@property (nonatomic,assign)BOOL wechat;

///是否绑定玉符
@property (nonatomic,assign)BOOL yufu;

@end

NS_ASSUME_NONNULL_END
