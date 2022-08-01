//
//  QCloudSMHDeleteFavoriteRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 删除收藏
 */
@interface QCloudSMHDeleteFavoriteRequest : QCloudSMHUserBizRequest

/// 收藏 ID 列表，以逗号分隔，如 123,222，必选参数；
@property (nonatomic,strong)NSArray <NSString *>*favoriteIds;
@end

NS_ASSUME_NONNULL_END
