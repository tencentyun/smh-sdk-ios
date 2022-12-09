//
//  QCloudSMHGetTeamDetailRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTeamInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询团队
 */
@interface QCloudSMHGetTeamDetailRequest : QCloudSMHUserBizRequest

/// 可选参数，不填则是查询根团队
@property (nonatomic,strong)NSString *teamId;

/// 是否带 team path, true | false, 可选参数，默认为 false
@property (nonatomic,assign)BOOL withPath;

/// 是否递归统计所有团队以及子团队用户，1 | 0，默认为 0，可选参数
@property (nonatomic,assign)BOOL WithRecursiveUserCount;

///  如果 query 中带 check_permission，则会检查权限（管理员列出所有团队，普通用户仅列出所属团队），可选参数
@property (nonatomic,strong)NSString *checkPermission;

///  1 | 0 只展示当前用户能管理的团队（管理员列出所有团队，团队管理员列出能够管辖的团队，普通用户不列出团队），可选参数
@property (nonatomic,strong)NSString *checkManagementPermission;

/// 是否统计团队回收站数量，1 | 0，默认为 0，可选参数
@property (nonatomic,assign)BOOL withRecycledFileCount;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTeamInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END


