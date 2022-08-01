//
//  QCloudSMHListGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHListGroupInfo.h"
#import "QCloudSMHSortTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 列出用户所在群组
 */
@interface QCloudSMHListGroupRequest : QCloudSMHUserBizRequest


///  文件夹更新时间是否递归所有子节点，1 - 递归所有子节点，0 - 不递归所有子节点 ，默认 0
@property (nonatomic, assign) BOOL checkUpdateRecursively;

///  是否列出群组内空间，1 - 列出，0- 不列出，默认不列出
@property (nonatomic, assign) BOOL withDirectory;

///  是否列出群组空间文件数量，1 - 列出，0- 不列出，默认不列出
@property (nonatomic, assign) BOOL withFileCount;

///  是否列出群组成员
@property (nonatomic, assign) BOOL withUser;

///  排序方式，支持
///  QCloudSMHGroupSortTypeCreationTime
///  QCloudSMHGroupSortTypeJoinTime，
///  默认 QCloudSMHGroupSortTypeCreationTime;
@property (nonatomic, assign) QCloudSMHGetGroupSortType  sortType;

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;


-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHListGroupInfo *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
