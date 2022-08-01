//
//  QCloudSMHGetRecycleObjectListReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHRecycleObjectListInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取回收站文件列表
 */
@interface QCloudSMHGetRecycleObjectListReqeust : QCloudSMHBizRequest

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

/// 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 排序字段，
/// 按名称排序为 QCloudSMHSortTypeName，
/// 按修改时间排序为 QCloudSMHSortTypeMTime，
/// 按文件大小排序为 QCloudSMHSortTypeSize，
/// 按删除时间排序为 QCloudSMHSortTypeRemovalTime，
/// 按剩余时间排序为 QCloudSMHSortTypeRemainingTime；
@property (nonatomic,assign)QCloudSMHSortType sortType;

/// 分页方向，当请求下一页时传 next，当请求上一页时，传 prev；
@property (nonatomic,assign)BOOL isNext;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecycleObjectListInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
