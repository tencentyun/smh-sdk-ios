//
//  QCloudSMHCheckDirectoryApplyResult.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHBaseContentInfo.h"

@class QCloudSMHCheckDirectoryApplyItem;
@class QCloudSMHAppleDirectoryResultItem;
@class QCloudSMHListAppleDirectoryResultItem;
@class QCloudSMHListAppleDirectoryResultCanAuditUsers;
@class QCloudSMHListAppleDirectoryResultdirectoryList;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHCheckDirectoryApplyResult : NSObject
@property (nonatomic,strong) NSArray <QCloudSMHCheckDirectoryApplyItem *> * directoryList;
@end

@interface QCloudSMHCheckDirectoryApplyItem : QCloudSMHBaseContentInfo

/// 空间 ID
@property (nonatomic,strong) NSString * spaceId;

/// 授权文件目录集合
@property (nonatomic,strong) NSString * path;

/// 是否已在申请权限
@property (nonatomic,assign) BOOL hasApplied;

/// 是否可申请权限
@property (nonatomic,assign) BOOL canApply;

/// 关联的申请单列表
@property (nonatomic,strong) NSArray * applyNoList;

/// 老的权限 roleId，如果只有一个则直接展示，如果有多个，则展示复合权限
@property (nonatomic,strong) NSArray <NSString *>* oldRoleIds;

/// 文件是否有效
@property (nonatomic,assign) BOOL isValid;

/// 敏感词扫描状态
@property (nonatomic, assign) QCloudSMHSensitiveWordAuditStatus sensitiveWordAuditStatus;

/// 病毒扫描状态
@property (nonatomic, assign) QCloudSMHVirusAuditStatus virusAuditStatus;

@end


@interface QCloudSMHAppleDirectoryResult : NSObject

/// 审批单号
@property (nonatomic,strong) NSString * applyNo;

/// 成功申请项
@property (nonatomic,strong) NSArray <QCloudSMHAppleDirectoryResultItem *> * successItems;

/// 失败申请项
@property (nonatomic,strong) NSArray <QCloudSMHAppleDirectoryResultItem *> * failedItems;

@end

@interface QCloudSMHAppleDirectoryResultItem : NSObject

/// 空间 ID
@property (nonatomic,strong) NSString * spaceId;

/// 授权文件目录集合
@property (nonatomic,strong) NSString * path;

@end



@interface QCloudSMHListAppleDirectoryResult : NSObject
/// 列表数量
@property (nonatomic, assign) NSInteger totalNum;


@property (nonatomic,strong) NSString * nextMarker;

/// 列表内容
@property (nonatomic, strong) NSArray <QCloudSMHListAppleDirectoryResultItem *> * contents;

@end


@interface QCloudSMHListAppleDirectoryResultItem : NSObject

/// 审批单号
@property (nonatomic,strong) NSString * applyNo;

/// 审批标题
@property (nonatomic,strong) NSString * title;

/// 可审批用户列表
@property (nonatomic,strong) NSArray <QCloudSMHListAppleDirectoryResultCanAuditUsers *> * canAuditUsers;

/// 审批状态，0 审批中 1 已失效 2 已撤回 3 已驳回 4 审批通过
@property (nonatomic,assign) QCloudSMHApplyAuditStatus auditStatus;

/// 创建时间
@property (nonatomic,strong) NSString * creationTime;

/// 创建人头像
@property (nonatomic,strong) NSString * createdByAvatar;

/// 创建人昵称
@property (nonatomic,strong) NSString * createdByNickname;

/// 操作时间，需结合状态来判断，可能是审批时间、驳回时间、失效时间、撤回时间
@property (nonatomic,strong) NSString * operationTime;

/// 申请的角色 ID
@property (nonatomic,strong) NSString * roleId;

/// 申请的文件信息
@property (nonatomic,strong) NSArray <QCloudSMHListAppleDirectoryResultdirectoryList *> * directoryList;

@end
@interface QCloudSMHListAppleDirectoryResultCanAuditUsers : NSObject

/// : 用户 ID
@property (nonatomic,strong) NSString *userId;

/// : 用户昵称
@property (nonatomic,strong) NSString *nickname;

/// : 用户头像
@property (nonatomic,strong) NSString *avatar;
@end

@interface QCloudSMHListAppleDirectoryResultdirectoryList : NSObject

/// 文件名
@property (nonatomic,strong) NSString *name;

/// 文件所在目录
@property (nonatomic,strong) NSString *path;

/// 文件类型；
@property (assign, nonatomic) QCloudSMHContentInfoType type;

/// 操作后的对象文件类型
@property (nonatomic,assign)QCloudSMHContentInfoType fileType;

/// 是否可通过万象预览；
@property (nonatomic,assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

/// 是否可用预览图做 icon，非必返；
@property (nonatomic, assign) BOOL previewAsIcon;


@end




NS_ASSUME_NONNULL_END







