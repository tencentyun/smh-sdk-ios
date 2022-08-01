//
//  QCloudSMHSearchTeamDetailRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHTeamInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询团队成员
 */
@interface QCloudSMHSearchTeamDetailRequest : QCloudSMHUserBizRequest

/// 要添加的 user ID 列表，用逗号分隔
@property (nonatomic,strong)NSString *teamId;

@property (nonatomic,strong)NSString *keyword;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)NSInteger pageSize;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

/// 是否同时获取个人空间用量信息，1|0，默认 0；
@property (nonatomic,assign)NSInteger withSpaceUsage;

/// 是否同时获取用户所属的团队信息，1|0，默认 0；
@property (nonatomic,assign)NSInteger withBelongingTeams;

/// 排序方式，支持
/// QCloudSMHGetTeamSortByRole
/// QCloudSMHGetTeamSortByEnabled
/// QCloudSMHGetTeamSortByNickname，
/// 默认 QCloudSMHGetTeamSortByRole;
@property (nonatomic,assign)QCloudSMHGetTeamSortType sortType;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchTeamInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END


