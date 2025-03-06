//
//  QCloudSMHListFavoriteSpaceFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHContentListInfo.h"


NS_ASSUME_NONNULL_BEGIN
/**
 查看指定空间收藏列表
 */
@interface QCloudSMHListFavoriteSpaceFileRequest : QCloudSMHBizRequest

/**
 限制响应体中的条目数，如不指定则默认为 1000；
 */
@property (nonatomic,assign)NSInteger limit;
/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;

/**
 按名称排序为     QCloudSMHSortTypeName，
 按修改时间排序为   QCloudSMHSortTypeMTime，
 按文件大小排序为 QCloudSMHSortTypeSize，
 按创建时间排序为 QCloudSMHSortTypeCTime
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

/**
 是否返回 path，返回为 true，不返回为 false（默认），可选参数；
 */
@property (nonatomic,assign)BOOL withPath;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
