//
//  QCloudSMHFileExtraInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHFileExtraInfo : NSObject

///  空间 ID
@property (nonatomic, strong) NSString * spaceId;

/// 文件目录路径
@property (nonatomic, strong) NSString * path;

/// 收藏 ID，如果未收藏则无此字段
@property (nonatomic, strong) NSString * favoriteId;


@property (nonatomic, strong) NSString * favoriteGroupId;

/// 是否被共享
@property (nonatomic, assign) BOOL isAuthorized;

/// authType: 0（共享给我） | 1（我共享的）；
@property (nonatomic, strong) NSString * authType;

@property (nonatomic, assign) QCloudSMHVirusAuditStatus virusAuditStatus;
@property (nonatomic, assign) QCloudSMHSensitiveWordAuditStatus sensitiveWordAuditStatus;

@property (nonatomic, assign) BOOL hasApplied;
@property (nonatomic, assign) BOOL canApply;

@property (nonatomic, strong) NSArray <NSString *> * currentRoleIds;


@end


@interface QCloudSMHFileExtraReqInfo : NSObject


/// 空间所在组织id
@property (nonatomic, strong) NSString *spaceOrgId;

/// 空间 ID
@property (nonatomic, strong) NSString *spaceId;

/// 文件路径
@property (nonatomic, strong) NSString *path;

@end

NS_ASSUME_NONNULL_END
