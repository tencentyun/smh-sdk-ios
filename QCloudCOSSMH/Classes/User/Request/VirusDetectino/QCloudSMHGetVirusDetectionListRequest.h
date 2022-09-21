//
//  QCloudSMHGetVirusDetectionListRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHVirusDetectionModel.h"
#import "QCloudSMHSortTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN

/// 用于列出可疑文件列表，跨空间
@interface QCloudSMHGetVirusDetectionListRequest : QCloudSMHUserBizRequest

/// spaceItems：筛选的空间集合，必填；
/// spaceId: 字符串，空间 ID；
/// includeChildSpace: 布尔型，是否包括该空间下的子空间，默认不包括；
@property(nonatomic,strong)NSArray <QCloudSMHListVirusDetectionInput *> * spaceItems;

/// 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 排序字段，
/// 按名称排序为:   QCloudSMHSortTypeName,
/// 按文件大小排序为 QCloudSMHSortTypeSize，
/// 按创建时间排序为 QCloudSMHSortTypeCTime，
/// 可选参数；
@property (nonatomic,assign)QCloudSMHSortType sortType;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;


- (void)setFinishBlock:(void (^)(QCloudVirusDetectionFileList * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
