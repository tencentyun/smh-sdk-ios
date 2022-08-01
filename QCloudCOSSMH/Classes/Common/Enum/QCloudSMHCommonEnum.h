//
//  QCloudSMHCommonEnum.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudSMHGroupRole) {
    QCloudSMHGroupRoleOwner = 0,
    QCloudSMHGroupRoleAdmin,
    QCloudSMHGroupRoleUser,
};

QCloudSMHGroupRole  QCloudSMHGroupRoleFromString(NSString *key);
NSString *  QCloudSMHGroupRoleTransferToString( QCloudSMHGroupRole type);


/// : 'personal', // 表示个人版 'team', // 表示个人版  'enterprise', // 表示企业版
typedef NS_ENUM(NSUInteger, QCloudSMHOrganizationType) {
    QCloudSMHOrganizationTypePersonal = 0,
    QCloudSMHOrganizationTypeTeam,
    QCloudSMHOrganizationTypeEnterprise,
};

QCloudSMHOrganizationType  QCloudSMHOrganizationTypeFromString(NSString *key);
NSString *  QCloudSMHOrganizationTypeTransferToString( QCloudSMHOrganizationType type);


/**
 用户角色
 */
typedef NS_ENUM(NSUInteger, QCloudSMHOrgUserRole) {
    QCloudSMHOrgUserRoleSuperAdmin = 1,
    QCloudSMHOrgUserRoleAdmin,
    QCloudSMHOrgUserRoleUser,
    QCloudSMHOrgUserRoleOther,
};

QCloudSMHOrgUserRole  QCloudSMHOrgUserRoleTypeFromString(NSString *key);
NSString *  QCloudSMHOrgUserRoleTypeTransferToString( QCloudSMHOrgUserRole type);


typedef NS_ENUM(NSUInteger, QCloudSMHLoginAuthType) {
    QCloudSMHLoginAuthWeb,
    QCloudSMHLoginAuthMobile,
    QCloudSMHLoginAuthOther,
};

QCloudSMHLoginAuthType QCloudSMHLoginAuthTypeFromString(NSString *key);
NSString *  QCloudSMHLoginAuthTypeTransferToString( QCloudSMHLoginAuthType type);

typedef NS_ENUM(NSUInteger, QCloudSMHPurposeType) {
    QCloudSMHPurposePreview = 0,
    QCloudSMHPurposeDownload,
    QCloudSMHPurposeList,
};
NSString *  QCloudSMHPurposeTypeTransferToString( QCloudSMHPurposeType type);


typedef NS_ENUM(NSUInteger, QCloudSMHFileAuthType) {
    QCloudSMHFileAuthTypeNone = 0, // 未知类型
    QCloudSMHFileAuthTypeToMe, // 共享给我
    QCloudSMHFileAuthTypeMine, // 我的共享
};

typedef NS_ENUM(NSUInteger, QCloudSMHYufuLoginType) {
    QCloudSMHYufuLoginNone = 0,
    QCloudSMHYufuLoginDomain,
    QCloudSMHYufuLoginTenantName,
};

typedef NS_ENUM(NSUInteger, QCloudSMHAllowEditionType) {
    QCloudSMHAllowEditionAll = 0,
    QCloudSMHAllowEditionEnterpriseOnly,
};


NS_ASSUME_NONNULL_END

