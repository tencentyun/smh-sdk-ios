//
//  QCloudSMHGetTeamRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/19.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTeamInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询团队
 */
@interface QCloudSMHGetTeamRequest : QCloudSMHUserBizRequest

/// 团队 ID，可选（不填则是查询根团队)
@property (nonatomic,strong)NSString * teamId;

/// 如果 query 中带 check_permission，则会检查权限（管理员列出所有团队，普通用户仅列出所属团队），可选参数
@property (nonatomic,assign)bool checkPermission;

///  1 | 0 只展示当前用户能管理的团队（管理员列出所有团队，团队管理员列出能够管辖的团队，普通用户不列出团队），可选参数
@property (nonatomic,strong)NSString *checkManagementPermission;

/// 是否带 team path, true | false, 可选参数，默认为 false
@property (nonatomic,assign)bool withPath;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTeamInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
