//
//  QCloudSMHVerifyAccountLoginRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 进行 SSO 登录的重定向，跳到第三方登录平台进行身份认证
 */
@interface QCloudSMHVerifyAccountLoginRequest :QCloudSMHBaseRequest

@property (nonatomic,strong)NSString * corpId;

/// 手机号，绑定手机号时必填
@property (nonatomic,strong)NSString * phoneNumber;

/// 国际码，绑定手机号时传，默认值为 +86
@property (nonatomic,strong)NSString * countryCode;

/// 验证码，绑定手机号时必填
@property (nonatomic,strong)NSString * smsCode;

/// 邀请码
@property (nonatomic,strong)NSString * inviteCode;

/// UA里的设备信息
@property (nonatomic,strong)NSString * deviceId;

/// 当前域名，可以是自定义域名
@property (nonatomic,strong)NSString * domain;

/// 指定 SSO 协议，可选参数，默认为 Organization.extensionData.ssoWay 值
@property (nonatomic,strong)NSString * SSOWay;

@property (nonatomic,strong)NSString * ldapType;

/// 登陆凭证，sso登录时必传
/// cas时为ticket值
/// oauth/oidc 时为code值
@property (nonatomic,strong)NSString * credential;

/// credential 和 （accountName、accountPassword） 二选一
@property (nonatomic,strong)NSString * accountName;
@property (nonatomic,strong)NSString * accountPassword;


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
