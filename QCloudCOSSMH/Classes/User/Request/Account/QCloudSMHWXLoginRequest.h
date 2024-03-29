//
//  QCloudSMHWXLoginRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 根据微信授权 code 获取用户登录信息。
 */
@interface QCloudSMHWXLoginRequest : QCloudSMHBaseRequest

/// : 微信授权code
@property (nonatomic,strong)NSString * code;

/// : 设备名称，例如 iPhone 12 Pro 等，用于区分客户端，可选参数
@property (nonatomic,strong)NSString * deviceId;

/// : 国家代码，如 +86，可选参数，未绑定手机号时才需传入
@property (nonatomic,strong)NSString * countryCode;

/// : 手机号码，如 18912345678，可选参数，未绑定手机号时才需传入
@property (nonatomic,strong)NSString * phoneNumber;

/// : 短信验证码，可选参数，未绑定手机号时才需传入
@property (nonatomic,strong)NSString * smsCode;

/// 授权类型，可选参数，默认为web，其他可选值：mobile 用于移动端授权登录。
@property (nonatomic,assign)QCloudSMHLoginAuthType authType;

/// 是否仅允许登录企业版，1 - 仅企业版可登录，0 - 所有版本账号都可登录，默认 0，可选参数
@property (nonatomic,assign)QCloudSMHAllowEditionType allowEdition;

/// 企业邀请码，可选参数
@property (nonatomic,strong)NSString *inviteCode;

/// 自定义域名，可选参数
@property (nonatomic,strong)NSString *domain;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
