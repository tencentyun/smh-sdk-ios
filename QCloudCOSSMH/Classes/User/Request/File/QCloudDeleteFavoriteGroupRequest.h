//
//  QCloudDeleteFavoriteGroupRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHFavoriteResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 删除收藏夹
 */
@interface QCloudDeleteFavoriteGroupRequest : QCloudSMHUserBizRequest

/**
 要删除的收藏夹 ID，必选参数；
 */
@property (nonatomic,copy)NSString *favoriteGroupId;

@end

NS_ASSUME_NONNULL_END
