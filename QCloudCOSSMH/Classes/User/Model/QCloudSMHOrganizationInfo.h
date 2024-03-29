//
//  QCloudSMHOrganizationInfo.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHOrganizationDetailInfo.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

@class  QCloudSMHOrgUser;
@interface QCloudSMHOrganizationInfo : NSObject

/// 整数，组织 ID
@property (nonatomic, strong) NSString *organizationID;

@property (nonatomic, strong) NSString *libraryId;

/// 字符串，组织名称
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isTemporary;


/// 是否限制登录 true受限制，false不受限制
@property (assign, nonatomic) BOOL ipLimitEnabled;
/// 组织配置参数
@property (nonatomic,strong) QCloudSMHOrgExtensionData *extensionData;

@property (assign, nonatomic) BOOL expired;

@property (nonatomic,strong) QCloudSMHOrgUser *orgUser;

///  布尔值，是否为最后一次登录的组织
@property (assign, nonatomic) BOOL isLastSignedIn;
@end

@interface QCloudSMHOrgUser : NSObject

/// 头像
@property (nonatomic, strong) NSString *avatar;

/// 昵称
@property (nonatomic, strong) NSString *nickname;

/// 角色
@property (nonatomic, assign) QCloudSMHOrgUserRole role;

/// 是否冻结
@property (nonatomic,assign) BOOL enabled;

/// 是否注销
@property (nonatomic, assign) BOOL deregister;

@end


NS_ASSUME_NONNULL_END
