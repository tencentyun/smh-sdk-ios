//
//  QCloudSMHGroupModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

/// 创建群组参数
@interface QCloudSMHCreateGroupItem : NSObject

/// 用户 UserId
@property (nonatomic,copy) NSString *userId;

/// 用户 所在组织id
@property (nonatomic,copy) NSString *orgId;

/// 用户角色，groupAdmin | user，必填项；
@property (nonatomic,assign) QCloudSMHGroupRole role;

/// 普通群组成员权限 ID，如果是普通成员，该字段是必填项；如果是群组管理员，该字段被忽略；
@property (nonatomic,copy) NSString *authRoleId;

@end

/// 创建群组结果
@interface QCloudSMHCreateGroupResult : NSObject

/// 新建群组 ID
@property (nonatomic,copy) NSString *groupId;

@end


@interface QCloudSMHCreateGroupCountResult : NSObject

/// 用户 ID
@property (nonatomic,copy) NSString *ownerId;

/// 创建的群组数量
@property (nonatomic,assign) NSInteger count;

@end


NS_ASSUME_NONNULL_END
