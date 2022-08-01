//
//  QCloudSMHCheckFavoriteResultInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 收藏结果信息
 */
@interface QCloudSMHCheckFavoriteResultInfo : NSObject

/// 空间id
@property (nonatomic,strong) NSString *spaceId;

/// 文件path
@property (nonatomic,strong) NSString *path;

/// 收藏id
@property (nonatomic,assign) NSInteger favoriteId;

/// 收藏夹id
@property (nonatomic,assign) NSInteger favoriteGroupId;

@end

NS_ASSUME_NONNULL_END
