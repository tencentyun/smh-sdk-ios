//
//  QCloudSMHGroupInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import <Foundation/Foundation.h>
@class QCloudSMHGroupOwnerInfo;
@class QCloudSMHGroupExtensionDataInfo;
@class QCloudSMHGroupRoleListItem;
NS_ASSUME_NONNULL_BEGIN

/// 创建群组结果
@interface QCloudSMHGroupInfo : NSObject

/// 群组 ID；
@property (nonatomic,copy) NSString *groupId;

/// 群组所属的组织 ID；
@property (nonatomic,copy) NSString *orgId;

/// 字符串，团队名称；
@property (nonatomic,copy) NSString *name;

/// 字符串，群组的协作空间 ID；
@property (nonatomic,copy) NSString *spaceId;

/// 群主的用户 ID；
@property (nonatomic,copy) NSString *userId;

/// 群组成员数量；
@property (nonatomic,assign) NSInteger userCount;

/// 是否为外部群组
@property (nonatomic,assign) BOOL isExternal;

/// 群组成员是否来自多个企业
@property (nonatomic,assign) BOOL hasCrossOrgUser;

/// 群组协作空间内的文件数量；
@property (nonatomic,assign) NSInteger fileCount;

/// 群组权限列表（源自群组所属企业的权限列表）
@property (nonatomic,strong)NSArray <QCloudSMHGroupRoleListItem *> * roleList;

/// 群主信息
@property (nonatomic,strong) QCloudSMHGroupOwnerInfo * owner;

@property (nonatomic,strong) QCloudSMHGroupExtensionDataInfo * extensionData;

@end

@interface QCloudSMHGroupOwnerInfo : NSObject


/// 群主的用户 ID；
@property (nonatomic,copy) NSString *userId;

/// 群主所属的组织 ID；
@property (nonatomic,copy) NSString *orgId;

/// 群主昵称；
@property (nonatomic,copy) NSString *nickname;

/// 群主头像链接；
@property (nonatomic,copy) NSString *avatar;

/// 是否为当前登入企业的外部成员；
@property (nonatomic,assign) BOOL isExternal;

@end

@interface QCloudSMHGroupRoleListItem : NSObject

/// 权限 ID
@property (nonatomic,strong) NSString *roleId;

/// 是否默认权限
@property (nonatomic,assign) BOOL isDefault;

/// 权限名称
@property (nonatomic,strong) NSString *name;

/// 权限描述
@property (nonatomic,strong) NSString *roleDesc;

/// 是否可为成员设置该权限
@property (nonatomic,assign) BOOL isUsable;
@end

@interface QCloudSMHGroupExtensionDataInfo : NSObject
@property (nonatomic,copy) NSString *defaultRoleId;
@end

NS_ASSUME_NONNULL_END
