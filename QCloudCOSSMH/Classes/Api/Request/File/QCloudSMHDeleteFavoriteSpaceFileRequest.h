//
//  QCloudSMHDeleteFavoriteSpaceFileRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 删除指定空间收藏
 */
@interface QCloudSMHDeleteFavoriteSpaceFileRequest : QCloudSMHBizRequest


/// 字符串，文件目录路径，根据路径取消收藏时，path 与 inode 参数二选一，如果同时指定 inode 和 path，则以 inode 为准；
@property (nonatomic,strong)NSString *path;

/// inode: 字符串，文件目录ID，
@property (nonatomic,strong)NSString *inode;

@end

NS_ASSUME_NONNULL_END
