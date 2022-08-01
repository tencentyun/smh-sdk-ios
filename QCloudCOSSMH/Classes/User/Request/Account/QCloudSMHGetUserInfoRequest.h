//
//  QCloudSMHUpdateUserInfoRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHUserDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查询用户
 */
@interface QCloudSMHGetUserInfoRequest : QCloudSMHUserBizRequest

@property (nonatomic,strong)NSString * userId;

/// 是否返回所属团队，true | false
@property (nonatomic,assign)BOOL withBelongingTeams;

@end

NS_ASSUME_NONNULL_END
