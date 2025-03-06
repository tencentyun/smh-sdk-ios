//
//  QCloudSMHListContentsRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHContentListInfo.h"


NS_ASSUME_NONNULL_BEGIN

/**
 列出目录或相簿内容
 */
@interface QCloudSMHListContentsRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
 */
@property (nonatomic,copy)NSString *dirPath;


/**
 限制响应体中的条目数，如不指定则默认为 1000；
 */
@property (nonatomic,assign)NSInteger limit;
/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;

//目录的 ETag 可作为列出目录或相簿内容请求的 If-None-Match 请求头部，如果目标目录的 ETag 与传入的值相同，则返回 HTTP 304 Not Modified，此时客户端可使用本地的缓存，否则将返回 HTTP 200 OK，此时客户端应清除本地的缓存并使用服务端返回的最新数据；
@property (nonatomic,copy)NSString *headerIfNoneMatch;

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


@property (nonatomic,strong)NSString * accessToken;
/**
 筛选方式，必选，onlyDir 只返回文件夹，onlyFile 只返回文件；
 */
@property (nonatomic,assign)QCloudSMHDirectoryFilter directoryFilter;
/**
 是否返回 inode，即文件目录 ID，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withInode;
/**
 是否返回收藏状态，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withFavoriteStatus;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
