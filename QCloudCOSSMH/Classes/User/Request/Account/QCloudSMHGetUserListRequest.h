//
//  QCloudSMHGetUserListRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTeamMemberInfo.h"
#import "QCloudSMHSortTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询用户列表
 */
@interface QCloudSMHGetUserListRequest : QCloudSMHUserBizRequest

/// 查询的手机号或昵称，如果不带 keyword 参数，则是查询组织下的所有用户
@property (nonatomic,strong)NSString *keyword;

/// 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

/// 是否同时获取个人空间用量信息，1|0，默认 0；
@property (nonatomic,assign)BOOL withSpaceUsage;

/// 是否同时获取用户所属的团队信息，1|0，默认 0；
@property (nonatomic,assign)BOOL withBelongingTeams;

/// 排序方式  支持
/// QCloudSMHGetTeamSortByRole
/// QCloudSMHGetTeamSortByEnabled
/// QCloudSMHGetTeamSortByNickname
/// 默认 QCloudSMHGetTeamSortByRole;
@property (nonatomic,assign)QCloudSMHGetTeamSortType sortType;

/// 是否过滤已有团队归属的用户，1|0，默认 0；1
@property (nonatomic,assign)BOOL excludeTeamUser;

- (void)setFinishBlock:(void (^)(QCloudSMHTeamContentInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
