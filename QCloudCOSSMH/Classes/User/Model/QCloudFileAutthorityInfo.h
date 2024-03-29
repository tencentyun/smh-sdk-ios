//
//  QCloudFileAutthorityInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/27.
//

#import <Foundation/Foundation.h>
@class QCloudSMHTeamInfo;
@class QCloudSMHTeamMemberInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudFileAutthorityInfo : NSObject

/// 字符串，角色名称
@property (nonatomic,strong) NSString *name;

/// 整数，权限标签，0 无标签，1 继承标签，2 默认标签
@property (nonatomic,strong) NSString *tag;

/// 整数，角色id
@property (nonatomic,strong) NSString *roleId;

/// 具体授权的用户 ID，当授权给用户时返回整數，授权给团队时返回 null；
@property (nonatomic,strong) NSString *userId;

///  具体授权的用户信息，仅当授权给用户时返回，非必返；
@property (nonatomic,strong) QCloudSMHTeamMemberInfo * user;

/// 字符串或 null，具体授权的团队空间 ID，当授权给团队时返回字符串，授权给用户时返回 null；
@property (nonatomic,strong) NSString *spaceId;

/// 对象，具体授权的团队信息，仅当授权给团队时返回，非必返；
@property (nonatomic,strong) QCloudSMHTeamInfo * team;

/// : 布尔型，是否禁止访问者
@property (nonatomic,assign) BOOL isForbidden;

/// : 布尔型，是否默认权限
@property (nonatomic,assign) BOOL isDefault;

/// 指定显示的分类，可空，当有返回时，优先判断显示到对应的标签
@property (nonatomic,assign)NSInteger displayTag;

/// : 继承角色ID，当继承了多个角色时，才返回
@property (nonatomic,strong) NSString *inheritRoleId;

@end

NS_ASSUME_NONNULL_END
