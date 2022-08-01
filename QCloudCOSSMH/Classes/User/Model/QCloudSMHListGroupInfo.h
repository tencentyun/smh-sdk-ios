//
//  QCloudSMHListGroupInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHListGroupMemberInfo.h"
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHRoleInfo.h"
@class QCloudSMHListGroupItem;
@class QCloudSMHListGroupFileItem;


NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHListGroupInfo : NSObject

/// 整数，用户所在群组总数
@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

/// 群组列表
@property (nonatomic, strong) NSArray <QCloudSMHListGroupItem *>*contents;

@end

@interface QCloudSMHListGroupItem : NSObject


/// 群组 ID
@property (nonatomic,strong)NSString * groupId;

@property (nonatomic,strong)NSString * authRoleId;

/// 群组名称
@property (nonatomic,strong)NSString * name;

/// 群组协作空间 ID
@property (nonatomic,strong)NSString * spaceId;

/// 用户在该群组的角色 owner | groupAdmin | user
@property (nonatomic,assign)QCloudSMHGroupRole groupRole;

/// 是否为外部群组
@property (nonatomic,assign) BOOL isExternal;

/// 群组是否包含外部用户
@property (nonatomic,assign) BOOL hasCrossOrgUser;

/// 群组文件目录列表（最多列出 6 个）
@property (nonatomic,strong)NSArray <QCloudSMHListGroupFileItem *>*directoryList;

/// 群组前 6 个用户的信息，仅当 WithUsers = 1 时返回，非必返
@property (nonatomic,strong)NSArray <QCloudSMHListGroupMember *>*users;

/// 当前登录用户，对该文件的操作的权限，仅 WithDirectory = 1 时返回，非必返；
@property (nonatomic, strong)QCloudSMHRoleInfo * authorityList;

/// 整数，群组用户数量；
@property (nonatomic,assign)NSInteger userCount;

/// 整数，群组内文件数量，仅当 WithFileCount = 1 时返回，非必返；
@property (nonatomic,assign)NSInteger fileCount;

/// 字符串，群主昵称
@property (nonatomic,strong)NSString * ownerName;

/// 整数，群主用户 ID
@property (nonatomic,strong)NSString * ownerId;

/// 字符串，群组所属组织名称
@property (nonatomic,strong)NSString * orgName;

/// 整数，群组 ID
@property (nonatomic,strong)NSString * orgId;
@property (nonatomic,strong)NSString * modificationTime;

/// 日期字符串，加入群组的时间；
@property (nonatomic,strong)NSString * joinTime;
@property (nonatomic,strong)NSString * creationTime;

/// 'personal', 表示个人版
/// 'team', 表示团队版
/// 'enterprise', 表示企业版
@property (nonatomic,assign) QCloudSMHOrganizationType orgEditionFlag;

@end

@interface QCloudSMHListGroupFileItem : NSObject

/// 创建者 ID
@property (nonatomic, strong)NSString * userId;

/// 创建者组织 ID
@property (nonatomic, strong)NSString * userOrgId;
@property (nonatomic, strong)NSString * modifierName;
@property (nonatomic, strong)QCloudSMHRoleInfo * authorityList;

/// 字符串，文件名称；
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * creationTime;
@property (nonatomic, strong)NSString * modificationTime;

/// 字符串，文件类型 dir | file;
@property (nonatomic, assign)QCloudSMHContentInfoType type;

/// 字符串，文件类型：excel、powerpoint 等，仅 file 返回，非必返；
@property (nonatomic, assign)QCloudSMHContentInfoType fileType;

/// 是否可用预览图做 icon，非必返；
@property (nonatomic, assign)BOOL previewAsIcon;

/// 是否可通过万象预览；
@property (nonatomic, assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

@end

NS_ASSUME_NONNULL_END
