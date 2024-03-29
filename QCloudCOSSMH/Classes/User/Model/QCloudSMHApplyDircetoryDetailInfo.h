//
//  QCloudSMHApplyDircetoryDetailInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHContentTypeEnum.h"

@class QCloudSMHApplyDircetoryDetailDirectoryList;
@class QCloudSMHApplyDircetoryDetailCreateByBelongLatestTeam;
@class QCloudSMHApplyDircetoryDetailextensionData;
@class QCloudSMHApplyDircetoryExtDetailDirectoryList;
@class QCloudSMHApplyDircetoryDetailRoleInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHApplyDircetoryDetailInfo : NSObject

@property (nonatomic,assign) NSInteger applyId;

/// 审批单号
@property (nonatomic,strong) NSString * applyNo;


@property (nonatomic,assign) NSInteger orgId;

/// 审批标题
@property (nonatomic,strong) NSString * title;


@property (nonatomic,strong) NSString * reason;

@property (nonatomic,strong) NSString * canAuditUserIds;

/// 可审批用户列表
@property (nonatomic,strong) NSArray <QCloudSMHListAppleDirectoryResultCanAuditUsers *> * canAuditUsers;

/// 审批状态，0 审批中 1 已失效 2 已撤回 3 已驳回 4 审批通过
@property (nonatomic,assign) QCloudSMHApplyAuditStatus auditStatus;

/// 0正常 1文件删除 2空间删除  3用户删除 4 角色删除 5 用户已被移出群组
@property (nonatomic,assign) QCloudSMHApplyAuditStatusCause auditStatusCause;
///  创建人 ID
@property (nonatomic,assign) NSInteger createdBy;

/// 创建时间
@property (nonatomic,strong) NSString * creationTime;

/// 创建人头像
@property (nonatomic,strong) NSString * createdByAvatar;

/// 创建人昵称
@property (nonatomic,strong) NSString * createdByNickname;

/// 创建人CountryCode
@property (nonatomic,strong) NSString * createdByCountryCode;

/// 创建人手机号
@property (nonatomic,strong) NSString * createdByPhoneNumber;

/// 审批人昵称
@property (nonatomic,strong) NSString * auditByNickname;


@property (nonatomic,strong) NSString * auditByAvatar;
/// 操作时间，需结合状态来判断，可能是审批时间、驳回时间、失效时间、撤回时间
@property (nonatomic,strong) NSString * operationTime;

/// 是否管理员
@property (nonatomic,assign) BOOL isAdmin;

/// 申请人是否存在
@property (nonatomic,assign) BOOL isCreatedByExist;

@property (nonatomic,strong) QCloudSMHApplyDircetoryDetailRoleInfo * roleInfo;

/// 申请的角色 ID
@property (nonatomic,strong) NSString * roleId;

/// 数组，申请文件所在的目录
@property (nonatomic,strong) NSArray <NSString *>* directoryPath;

/// 申请人加入的最后的团队
@property (nonatomic,strong) QCloudSMHApplyDircetoryDetailCreateByBelongLatestTeam * createByBelongLatestTeam;

/// 申请的文件信息
@property (nonatomic,strong) NSArray <QCloudSMHApplyDircetoryDetailDirectoryList *> * directoryList;

@property (nonatomic,strong) QCloudSMHApplyDircetoryDetailextensionData * extensionData;


/// 空间标签
@property (nonatomic, assign) QCloudSpaceTagEnum spaceTag;

/// 共享群组空间信息；和 用户空间信息、团队空间信息三选一返回
@property (nonatomic, strong) QCloudSMHContentGroupInfo * group;

/// 用户空间信息；和共享群组空间信息、团队空间信息三选一返回
@property (nonatomic, strong)  QCloudSMHUserInfo *user;

/// 团队空间信息； 和共享群组空间信息、用户空间信息三选一返回
@property (nonatomic, strong)  QCloudSMHTeamInfo *team;

@end

@interface QCloudSMHApplyDircetoryDetailRoleInfo : NSObject
@property (nonatomic,strong) NSString * roleId;
@property (nonatomic,strong) NSString * libraryId;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) BOOL canView;
@property (nonatomic,assign) BOOL canPreview;
@property (nonatomic,assign) BOOL canDownload;
@property (nonatomic,assign) BOOL canPrint;
@property (nonatomic,assign) BOOL canUpload;
@property (nonatomic,assign) BOOL canDelete;
@property (nonatomic,assign) BOOL canModify;
@property (nonatomic,assign) BOOL canAuthorize;
@property (nonatomic,assign) BOOL canShare;
@property (nonatomic,assign) BOOL canPreviewSelf;
@property (nonatomic,assign) BOOL canDownloadSelf;
@property (nonatomic,strong) NSString * roleDesc;
@property (nonatomic,assign) BOOL isDefault;
@property (nonatomic,assign) BOOL isOwner;
@property (nonatomic,assign) BOOL isForbidden;
@property (nonatomic,assign) BOOL isCustom;
@end

@interface QCloudSMHApplyDircetoryDetailextensionData : NSObject

@property (nonatomic,strong) NSArray <QCloudSMHApplyDircetoryExtDetailDirectoryList *> * directoryList;

@end

@interface QCloudSMHApplyDircetoryDetailCreateByBelongLatestTeam : NSObject

/// : 团队 ID
@property (nonatomic,strong) NSString *teamId;

/// : 团队名称
@property (nonatomic,strong) NSString *name;

/// : 父团队 ID
@property (nonatomic,strong) NSString *parentId;

/// : 团队 spaceId
@property (nonatomic,strong) NSString *spaceId;

@end

@interface QCloudSMHApplyDircetoryExtDetailDirectoryList : NSObject

/// : 文件名
@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *path;

@property (nonatomic,strong) NSArray <NSString *>*oldRoleIds;

@property (nonatomic,strong) NSArray *appliedList;

@property (nonatomic,strong) NSString *directoryId;

@end

@interface QCloudSMHApplyDircetoryDetailDirectoryList : NSObject

/// : 是否有效
@property (nonatomic,assign) BOOL isValid;

/// : 文件名
@property (nonatomic,strong) NSString *name;

/// 字符串，文件类型 dir | file;
@property (nonatomic, assign)QCloudSMHContentInfoType type;

/// 字符串，文件类型：excel、powerpoint 等，仅 file 返回，非必返；
@property (nonatomic, assign)QCloudSMHContentInfoType fileType;

@property (nonatomic,assign) BOOL previewByCI;

@property (nonatomic,assign) BOOL previewByDoc;

@property (nonatomic,assign) BOOL previewAsIcon;

@property (nonatomic,strong) NSArray <NSString *>*oldRoleIds;
@property (nonatomic, assign) QCloudSMHVirusAuditStatus virusAuditStatus;
@property (nonatomic, assign) QCloudSMHSensitiveWordAuditStatus sensitiveWordAuditStatus;

@end

NS_ASSUME_NONNULL_END
