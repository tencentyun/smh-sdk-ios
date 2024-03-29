//
//  QCloudSMHVerifySMSCode.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 短信验证码登录
 
 InvalidPhoneNumber: 手机号码格式不正确
 PhoneNumberNotInAllowlist: 手机号码不在白名单中
 SmsCodeInvalidOrExpired: 短信验证码无效或过期，当前有效期为 10 分钟
 SmsFrequencyLimit: 频率限制，1分钟只能发一次
 WrongSmsCode: 验证码错误，可重试（错误 3 次后将不可重试，返回错误码 SmsCodeInvalidOrExpired）
 SmsCodeVerificationExceeded: 验证码错误，可重试（错误 3 次后将不可重试，返回错误码 SmsCodeInvalidOrExpired）
 */
@interface QCloudSMHVerifySMSCodeRequest : QCloudSMHBaseRequest

/// 国家代码，如 +86
@property (nonatomic,strong)NSString *countryCode;

/// 手机号码，如 18912345678
@property (nonatomic,strong)NSString *phone;

/// 短信验证码，如 1234
@property (nonatomic,strong)NSString *code;

///  设备名称，可选值，例如 iPhone 12 Pro 等，用于区分客户端
@property (nonatomic,strong)NSString *deviceID;

/// 客户端版本号，可选值，如 1.2.0
@property (nonatomic,strong)NSString *clientVersion;

/// 企业邀请码，可选参数
@property (nonatomic,strong)NSString *inviteCode;

/// 自定义域名，可选参数
@property (nonatomic,strong)NSString *domain;

/// 图形验证码 ticket，可选参数
@property (nonatomic,strong)NSString *captchaTicket;

/// 图形验证码 randstr，可选参数
@property (nonatomic,strong)NSString *captchaRandstr;

///  渠道参数，可选参数，比如腾讯会议值为meeting，Hiflow连接器为hiflow，游客为visitor
@property (nonatomic,assign)QCloudSMHChannelFlag pf;

/// 是否仅允许登录企业版，1 - 仅企业版可登录，0 - 所有版本账号都可登录，默认 0，可选参数
@property (nonatomic,assign)QCloudSMHAllowEditionType allowEdition;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHOrganizationsInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
