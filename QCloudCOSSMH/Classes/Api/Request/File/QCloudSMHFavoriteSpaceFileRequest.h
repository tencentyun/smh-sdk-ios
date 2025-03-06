//
//  QCloudSMHFavoriteSpaceFileRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHFavoriteSpaceFileResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 收藏文件目录
 */
@interface QCloudSMHFavoriteSpaceFileRequest : QCloudSMHBizRequest


/// 字符串，文件目录路径，根据路径取消收藏时，path 与 inode 参数二选一，如果同时指定 inode 和 path，则以 inode 为准；
@property (nonatomic,strong)NSString *path;

/// inode: 字符串，文件目录ID，
@property (nonatomic,strong)NSString *inode;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFavoriteSpaceFileResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
