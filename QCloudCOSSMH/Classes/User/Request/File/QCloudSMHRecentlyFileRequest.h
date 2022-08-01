//
//  QCloudSMHRecentlyFileRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHRecentlyFileListInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 获取最近使用文件列表
 */
@interface QCloudSMHRecentlyFileRequest : QCloudSMHUserBizRequest

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
 排序字段，
 按操作时间排序为 QCloudSMHSortTypeVisitTime（默认）
 可选参数；
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHRecentlyFileListInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
