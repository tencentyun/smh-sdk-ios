//
//  QCloudSMHDynamicEnum.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/27.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, QCloudSMHDynamicActionDetailType) {
    QCloudSMHDynamicActionDetailAll = 0 << 0,// 全部
    QCloudSMHDynamicActionDetailDownload = 1 << 0,// 下载
    QCloudSMHDynamicActionDetailPreview = 1 << 1,// 预览
    QCloudSMHDynamicActionDetailDelete = 1 << 2,// 删除
    QCloudSMHDynamicActionDetailMove = 1 << 3,// 移动
    QCloudSMHDynamicActionDetailRename = 1 << 4,// 重命名
    QCloudSMHDynamicActionDetailCopy = 1 << 5,// 复制
    QCloudSMHDynamicActionDetailCreate = 1 << 6,// 新建
    QCloudSMHDynamicActionDetailUpdate = 1 << 7,// 更新
    QCloudSMHDynamicActionDetailRestore = 1 << 8,// 还原
};


NSArray * QCloudSMHDynamicActionDetailTypeTransferToString(QCloudSMHDynamicActionDetailType type);
QCloudSMHDynamicActionDetailType QCloudSMHDynamicActionDetailTypeFromString(NSString * type);

//日志类型 user | api
typedef NS_ENUM(NSUInteger, QCloudSMHDynamicLogType) {
    QCloudSMHDynamicLogUser = 0,
    QCloudSMHDynamicLogAPI,
};


NSString * QCloudSMHDDynamicLogTypeTransferToString(QCloudSMHDynamicLogType type);
QCloudSMHDynamicLogType  QCloudSMHDDynamicLogTypeFromString(NSString * type);


//actionType：操作类型分类

typedef NS_ENUM(NSUInteger, QCloudSMHDynamicActionType) {
    
    QCloudSMHDynamicTypeLogin = 0,// 登录
    QCloudSMHDynamicTypeUserManagement,// 用户管理
    QCloudSMHDynamicTypeTeamManagement,// 团队管理
    QCloudSMHDynamicTypeShareManagement,// 分享相关，包括：分享文件
    QCloudSMHDynamicTypeAuthorityAction,// 共享相关，包括：共享文件，权限修改，删除权限
    QCloudSMHDynamicTypeFileAction,// 文件相关，包括：上传，下载，删除，修改，预览；
    QCloudSMHDynamicTypeSyncAction,// 同步盘操作；
};

NSString * QCloudSMHDDynamicActionTypeTransferToString(QCloudSMHDynamicActionType type);
QCloudSMHDynamicActionType QCloudSMHDDynamicActionTypeFromString(NSString * type);


// 操作对象类型 user | team | organization
typedef NS_ENUM(NSUInteger, QCloudSMHDynamicObjectType) {
    
    QCloudSMHDynamicObjectTypeUser = 0,
    QCloudSMHDynamicObjectTypeTeam,
    QCloudSMHDynamicObjectTypeOrganization,
};

NSString * QCloudSMHDDynamicObjectTypeTransferToString(QCloudSMHDynamicObjectType type);
QCloudSMHDynamicObjectType QCloudSMHDDynamicObjectTypeFromString(NSString * type);

NS_ASSUME_NONNULL_END

