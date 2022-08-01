//
//  QCloudGetFavoriteListRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHFavoriteResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取收藏列表
 */
@interface QCloudGetFavoriteListRequest : QCloudSMHUserBizRequest

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;

/**
 限制响应体中的条目数，如不指定则默认为 1000；
 
 */
@property (nonatomic,assign)NSInteger limit;
/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;

/**
 收藏夹 ID，可选参数；
 */
@property (nonatomic,copy)NSString *favoriteGroupId;

/**
 排序字段，按名称排序为
 QCloudSMHSortTypeFavoriteTime，
 按修改时间排序为
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHFavoriteResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
