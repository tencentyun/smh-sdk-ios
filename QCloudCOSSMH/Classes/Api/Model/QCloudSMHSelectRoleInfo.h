//
//  QCloudSMHSelectRoleInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    QCloudSMHRoleMember,
    QCloudSMHRoleGrop,
} QCloudSMHRoleType;

@interface QCloudSMHSelectRoleInfo : NSObject

@property (nonatomic,assign) QCloudSMHRoleType type;

/// 授权目标id，如果目标是组织则传 对应spaceId,如果为成员则传 userId;
@property (nonatomic, strong)NSString *targetId;

/// 角色id
@property (nonatomic, strong)NSString *roleId;

/// 角色名称
@property (nonatomic, strong)NSString *name;

-(id)initWithType:(QCloudSMHRoleType)type targetId:(NSString *)targetId roleId:(NSString *)roleId name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
