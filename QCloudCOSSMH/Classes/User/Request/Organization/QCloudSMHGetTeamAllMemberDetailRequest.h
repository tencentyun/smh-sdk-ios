//
//  QCloudSMHGetTeamAllMemberDetailRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHTeamMemberInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查询该团队及其所有子级团队的成员
 */
@interface QCloudSMHGetTeamAllMemberDetailRequest : QCloudSMHUserBizRequest

/// team ID
@property (nonatomic,strong)NSString *teamId;

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


// 是否包含未激活用户，NO 不包含，YES 包含，默认包含
@property (nonatomic,assign)BOOL includeInactiveUser;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTeamContentInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
