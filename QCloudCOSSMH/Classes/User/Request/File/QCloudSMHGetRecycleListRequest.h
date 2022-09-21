//
//  QCloudSMHGetRecycleListRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCrossSpaceRecycleItem.h"
#import "QCloudSMHSortTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHSpaceItem : NSObject

/// 字符串，空间 ID；
@property (nonatomic,strong)NSString *spaceId;

/// 是否包括该空间下的子空间，默认不包括；
@property (nonatomic,assign)BOOL includeChildSpace;
@end

/**
 列出误删恢复回收站项目
 用于列出回收站项目，跨空间。
 目录内容的列出顺序为：默认无排序，根据传入参数 orderBy 和 orderByType 来决定排列顺序
 */
@interface QCloudSMHGetRecycleListRequest : QCloudSMHUserBizRequest


/**
 用于顺序列出分页时本地列出的项目数限制，可选参数，不能与 page 和 page_size 参数同时使用；
 */
@property (nonatomic,assign)NSInteger limit;

/**
 Marker: 用于顺序列出分页的标识，可选参数，不能与 page 和 page_size 参数同时使用；
 */
@property (nonatomic,copy)NSString *marker;

/**
 分页码，默认第一页，可选参数，不能与 marker 和 limit 参数同时使用；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数，不能与 marker 和 limit 参数同时使用；
 */
@property (nonatomic,assign)NSInteger pageSize;

/**
 排序字段，
 按名称排序为 QCloudSMHSortTypeName，
 按修改时间排序为 QCloudSMHSortTypeMTime，
 按文件大小排序为 QCloudSMHSortTypeSize，
 按创建时间排序为 QCloudSMHSortTypeCTime
 按删除时间排序为 QCloudSMHSortTypeRemovalTime
 按剩余时间排序为 QCloudSMHSortTypeRemainingTime
 可选参数；
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

/**
 根据删除者 id 筛选信息，可选参数；
 */
@property (nonatomic,strong)NSString *removedBy;

/**
 筛选的空间集合，必传；
 */
@property (nonatomic,strong)NSArray <QCloudSMHSpaceItem *> *spaceItems;

/**
 是否快捷筛选当前用户加入的所有团队空间，默认 false；
 */
@property (nonatomic,assign)BOOL withAllTeamSpace;

/**
 是否快捷筛选当前用户加入的群组空间，默认 false；
 */
@property (nonatomic,assign)BOOL withAllGroupSpace;

- (void)setFinishBlock:(void (^)(QCloudSMHCrossSpaceRecycleInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
