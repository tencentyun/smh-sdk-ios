//
//  QCloudSMHOffcialFreeLoginRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 根据短信验证码获取用户登录信息。 官方免费注册 + 登录
 */
@interface QCloudSMHOffcialFreeLoginRequest : QCloudSMHBaseRequest

///  短信验证码，如 1234，必选参数
@property (nonatomic,strong)NSString * code;

/// : 设备名称，例如 iPhone 12 Pro 等，用于区分客户端，可选参数
@property (nonatomic,strong)NSString * deviceId;

/// : 国家代码，如 +86，可选参数，未绑定手机号时才需传入
@property (nonatomic,strong)NSString * countryCode;

/// : 手机号码，如 18912345678，可选参数，未绑定手机号时才需传入
@property (nonatomic,strong)NSString * phoneNumber;

/// 验证码ticket 选填,
@property (nonatomic,strong)NSString * captchaTicket;

/// 验证码随机码 选填
@property (nonatomic,strong)NSString * captchaRandstr;

/// 企业名称 必填
@property (nonatomic,strong)NSString * orgName;

/// 企业所属行业 必填
@property (nonatomic,strong)NSString * business;

/// 职务 可选参数
@property (nonatomic,strong)NSString * role;

/// 公司规模，可选参数
@property (nonatomic,strong)NSString * scale;

/// 企业邀请码，可选参数
@property (nonatomic,strong)NSString *inviteCode;

/// 自定义域名，可选参数
@property (nonatomic,strong)NSString *domain;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
