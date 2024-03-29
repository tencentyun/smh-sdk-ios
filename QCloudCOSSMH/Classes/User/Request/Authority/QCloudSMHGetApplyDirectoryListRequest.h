//
//  QCloudSMHGetApplyDirectoryListRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 文件权限审批列表
 */
@interface QCloudSMHGetApplyDirectoryListRequest : QCloudSMHUserBizRequest

/// 查询类型：my_audit（我审核的）、my_apply（我申请的）；
@property (nonatomic,assign)QCloudSMHAppleType type;

/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;

/**
 限制响应体中的条目数，如不指定则默认为 1000；
 */
@property (nonatomic,assign)NSInteger limit;

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;

/**
 默认按创建时间排序为 creationTime、按审批时间排序 operationTime；
 可选参数；
 */
@property (nonatomic,assign)QCloudSMHApplySortType sortType;

/// 状态筛选，可选，不传返回全部，auditing 返回等待审批中的单，history 返回已审批、已取消、已驳回的单；
@property (nonatomic,assign)QCloudSMHAppleStatusType status;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHListAppleDirectoryResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;


@end

NS_ASSUME_NONNULL_END
