//
//  QCloudSMHBaseContentInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/15.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHUserInfo.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHTeamInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHContentGroupInfo : NSObject

/// 团队 ID
@property (nonatomic, copy) NSString * groupId;

/// name 群组名称
@property (nonatomic, copy) NSString * name;

/// 组织ID
@property (nonatomic, copy) NSString * orgId;

@end

@interface QCloudSMHBaseContentInfo : NSObject

/// 空间标签
@property (nonatomic, assign) QCloudSpaceTagEnum spaceTag;

/// 共享群组空间信息；和 用户空间信息、团队空间信息三选一返回
@property (nonatomic, strong) QCloudSMHContentGroupInfo * group;

/// 用户空间信息；和共享群组空间信息、团队空间信息三选一返回
@property (nonatomic, strong)  QCloudSMHUserInfo *user;

/// 团队空间信息； 和共享群组空间信息、用户空间信息三选一返回
@property (nonatomic, strong)  QCloudSMHTeamInfo *team;


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;

@end



NS_ASSUME_NONNULL_END
