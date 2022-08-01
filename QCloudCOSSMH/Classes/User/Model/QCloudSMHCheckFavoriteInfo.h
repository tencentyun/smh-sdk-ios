//
//  QCloudSMHCheckFavoriteInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 确认是否收藏 信息
 */
@interface QCloudSMHCheckFavoriteInfo : NSObject

/// 空间id
@property (nonatomic,strong) NSString *spaceId;

/// 文件path
@property (nonatomic,strong) NSString *path;
@end

NS_ASSUME_NONNULL_END
