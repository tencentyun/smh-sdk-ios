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

//virusAuditStatus: 0-6 查毒状态
typedef NS_ENUM(NSUInteger, QCloudSMHVirusAuditStatus) {
    QCloudSMHVirusWaitAudit = 0,  //0 未检测 （文件夹不标记可疑状态，一直为0）
    QCloudSMHVirusAuditIng,  //1 检测中
    QCloudSMHVirusAuditSafety,  //2 无风险
    QCloudSMHVirusAuditUnsafety,  //3 风险文件
    QCloudSMHVirusCantAudit,  //4 无法检测 （比如文件太大超过可检测范围，端侧当无风险处理）（超1G不检）
    QCloudSMHVirusAuditManualSafety,  //5 人为标记为无风险
    QCloudSMHVirusAuditFailure,  //6 检测任务失败
};

typedef NS_ENUM(NSUInteger, QCloudSMHUsedSence) {
    QCloudSMHUsedSencePersonal = 0,
    QCloudSMHUsedSenceTeam,
    QCloudSMHUsedSenceGroup,
};
NSString *  QCloudSMHUsedSenceTransferToString( QCloudSMHUsedSence type);

NS_ASSUME_NONNULL_END

