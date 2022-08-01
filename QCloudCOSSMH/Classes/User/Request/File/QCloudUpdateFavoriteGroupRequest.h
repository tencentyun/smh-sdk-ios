//
//  QCloudUpdateFavoriteGroupRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHFavoriteResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 更新收藏夹。
 */
@interface QCloudUpdateFavoriteGroupRequest : QCloudSMHUserBizRequest

/**
 收藏夹 Tag，可选参数
 */
@property (nonatomic,copy)NSString *tag;

/**
 字符串，收藏夹名称，必填参数；
 */
@property (nonatomic,copy)NSString *name;

@end

NS_ASSUME_NONNULL_END
