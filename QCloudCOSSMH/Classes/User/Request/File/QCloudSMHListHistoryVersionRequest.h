//
//  QCloudSMHListHistoryVersionRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHListHistoryVersionResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查看历史版本列表
 */
@interface QCloudSMHListHistoryVersionRequest : QCloudSMHUserBizRequest

/// 空间 ID，如果媒体库为单租户模式，则该参数固定为连字符(-)；如果媒体库为多租户模式，则必须指定该参数；
@property (nonatomic,strong)NSString * spaceId;

/// 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
@property (nonatomic,strong)NSString *filePath;

/// 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 空间所在组织id
@property (nonatomic, strong) NSString *spaceOrgId;

/// 排序字段，
/// 按文件大小排序为 QCloudSMHSortTypeSize，
/// 按创建时间排序为 QCloudSMHSortTypeCTime，
/// 可选参数；
@property (nonatomic,assign)QCloudSMHSortType sortType;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHListHistoryVersionResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
