//
//  QCloudSMHExitFileAuthorizeRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHExitFileAuthorize.h"
NS_ASSUME_NONNULL_BEGIN


/**
 用于用户主动退出被授权的 文件/文件夹 权限。
 */
@interface QCloudSMHExitFileAuthorizeRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；必选参数；
 */
@property (nonatomic,strong)NSString * dirPath;

/**
 要删除些用户或者组织的权限
 */
@property (nonatomic,strong)NSArray <QCloudSMHExitFileAuthorize *> * authorizeTo;
@end

NS_ASSUME_NONNULL_END
