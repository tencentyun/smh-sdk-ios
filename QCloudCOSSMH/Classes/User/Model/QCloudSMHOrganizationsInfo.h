//
//  QCloudSMHOrganizationsInfo.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHOrganizationInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHOrganizationsInfo : NSObject

/// 整数，用户 ID
@property (nonatomic, strong) NSString *userId;

/// 字符串，用户令牌，必选参数（区别于 SMH 的 Access Token 访问令牌）
@property (nonatomic, strong) NSString *userToken;

///  整数，过期时间（秒）
@property (nonatomic, assign) NSInteger expiresIn;

/// 布尔值，该用户是否申请过个人版（注销过的也算）
@property (nonatomic, assign) BOOL hasAppliedPersonalOrg;

///是否已有对应渠道的体验版本
@property (nonatomic, assign) BOOL hasAppliedChannelOrg;

/// 布尔值，绑定的手机号是否为新手机号
@property (nonatomic, assign) BOOL isNewUser;

///  当前登录用户所属组织
@property (nonatomic, strong) NSArray <QCloudSMHOrganizationInfo *>*organizations;

@end

NS_ASSUME_NONNULL_END
