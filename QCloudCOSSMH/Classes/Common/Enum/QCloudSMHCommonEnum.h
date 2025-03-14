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
    QCloudSMHPurposeDownload = 0,
    QCloudSMHPurposePreview,
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
// 敏感词状态
typedef NS_ENUM(NSUInteger, QCloudSMHSensitiveWordAuditStatus) {
    QCloudSMHSensitiveWordWaitAudit = 0,  //0 未检查
    QCloudSMHSensitiveWordAuditNone,  //1无风险
    QCloudSMHSensitiveWordAuditSuccess,  //2 敏感文件
    QCloudSMHSensitiveWordAuditMarkNone,  //3 人为标记为无风险
    QCloudSMHSensitiveWordAuditError,  // 4无法判断（如文件内容读取失败等原因）
};

typedef NS_ENUM(NSUInteger, QCloudSMHUsedSence) {
    QCloudSMHUsedSenceAll = 0,
    QCloudSMHUsedSencePersonal,
    QCloudSMHUsedSenceTeam,
    QCloudSMHUsedSenceGroup,
};
NSString *  QCloudSMHUsedSenceTransferToString( QCloudSMHUsedSence type);

typedef NS_ENUM(NSUInteger, QCloudSMHFileTemplate) {
    QCloudSMHFileTemplateWord = 0,
    QCloudSMHFileTemplateExcel,
    QCloudSMHFileTemplatePPT,
};
NSString *  QCloudSMHFileTemplateTransferToString( QCloudSMHFileTemplate fileTemplate);

typedef NS_ENUM(NSUInteger, QCloudSMHChannelFlag) {
    QCloudSMHChannelFlagNone = 0,
    QCloudSMHChannelFlagMeeting = 1,
    QCloudSMHChannelFlagHiflow = 2,
    QCloudSMHChannelFlagOfficialFree = 3,
    QCloudSMHChannelFlagVisitor = 4,
};
NSString *  QCloudSMHChannelFlagTransferToString( QCloudSMHChannelFlag flag);
QCloudSMHChannelFlag QCloudSMHChannelFlagFromString(NSString *key);


/// 文件类型；混合文件：multi-file、文件：file、文件夹：dir；
typedef NS_ENUM(NSUInteger, QCloudSMHShareFileType) {
    QCloudSMHShareFileTypeNone = 0,
    QCloudSMHShareFileTypeMultiFile ,
    QCloudSMHShareFileTypeFile ,
    QCloudSMHShareFileTypeDir ,
};
NSString *  QCloudSMHShareFileTypeTransferToString( QCloudSMHShareFileType flag);
QCloudSMHShareFileType QCloudSMHShareFileTypeFromString(NSString *key);

/// 查询类型：my_audit（我审核的）、my_apply（我申请的）；
typedef NS_ENUM(NSUInteger, QCloudSMHAppleType) {
    QCloudSMHAppleTypeNone = 0,
    QCloudSMHAppleTypeMyAudit,
    QCloudSMHAppleTypeMyApply,
};
NSString *  QCloudSMHAppleTypeTransferToString( QCloudSMHAppleType flag);

typedef NS_ENUM(NSUInteger, QCloudSMHAppleStatusType) {
    QCloudSMHAppleStatusTypeAll = 0,
    QCloudSMHAppleStatusTypeAuditing,
    QCloudSMHAppleStatusTypeHistory,
};
NSString *  QCloudSMHAppleStatusTypeTransferToString( QCloudSMHAppleStatusType flag);

// 审批状态，0 审批中 1 已失效 2 已撤回 3 已驳回 4 审批通过
typedef NS_ENUM(NSUInteger, QCloudSMHApplyAuditStatus) {
    QCloudSMHApplyAuditIng = 0,  //0 审批中
    QCloudSMHApplyAuditInvalid,  //1 已失效
    QCloudSMHApplyAuditUndo,  //2 已撤回
    QCloudSMHApplyAuditReject,  //3 已驳回
    QCloudSMHApplyAuditPass,  //4 审批通过
};
typedef NS_ENUM(NSUInteger, QCloudSMHApplyAuditStatusCause) {
    QCloudSMHApplyAuditCauseNormal = 0,  //0 正常
    QCloudSMHApplyAuditCauseFileDelete,  //1 文件删除
    QCloudSMHApplyAuditCauseSpaceDelete,  //2 空间删除
    QCloudSMHApplyAuditCauseUserDelete,  //3 用户删除
    QCloudSMHApplyAuditCauseRoleDelete,  //4 角色删除
    QCloudSMHApplyAuditCauseUserDeleteFromGroup,  //5 用户被移除群组
};
typedef NS_ENUM(NSUInteger, QCloudSMHDirectoryFilter) {
    QCloudSMHDirectoryAll = 0,  //0 返回全部
    QCloudSMHDirectoryOnlyDir = 1,  //1 只返回文件夹
    QCloudSMHDirectoryOnlyFile = 2,  //2 只返回文件
};
NSString *  QCloudSMHDirectoryFilterTransferToString( QCloudSMHDirectoryFilter filter);

typedef NS_ENUM(NSUInteger, QCloudSMHSearchMode) {
    QCloudSMHSearchModeNormal = 0,
    QCloudSMHSearchModeFast = 1,
};
NSString *  QCloudSMHSearchModeTransferToString( QCloudSMHSearchMode model);

NS_ASSUME_NONNULL_END

