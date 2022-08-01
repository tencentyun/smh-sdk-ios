//
//  QCloudSMHGetListFileShareLinkRequest.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudFileShareInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取分享链接列表
 */
@interface QCloudSMHGetListFileShareLinkRequest : QCloudSMHUserBizRequest

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;

/**
 排序方式，默认过期时间 QCloudSMHSortTypeExpireTime；
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

/**
 限制响应体中的条目数，如不指定则默认为 1000；
 */
@property (nonatomic,assign)NSInteger limit;

/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;
@end

NS_ASSUME_NONNULL_END
