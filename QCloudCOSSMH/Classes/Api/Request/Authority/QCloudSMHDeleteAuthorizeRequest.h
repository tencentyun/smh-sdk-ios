//
//  QCloudSMHDeleteAuthorizeRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSelectRoleInfo.h"
NS_ASSUME_NONNULL_BEGIN


/**
 用于删除权限
 */
@interface QCloudSMHDeleteAuthorizeRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
 */
@property (nonatomic,strong)NSString * dirPath;

/**
 要删除些用户或者组织的权限
 */
@property (nonatomic,strong)NSArray <QCloudSMHSelectRoleInfo *> * selectRoles;
@end

NS_ASSUME_NONNULL_END
