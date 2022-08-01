//
//  QCloudSMHGetUpdatePhoneCodeRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 发送短信验证码
 更新手机号全局生效，更改生效后，用户登录其它组织也需要使用需要用新手机号
 
 可能错误码：
 InvalidPhoneNumber: 手机号码格式不正确
 PhoneNumberNotInAllowlist: 手机号码不在白名单中
 SmsFrequencyLimit: 频率限制，1分钟只能发一次
 SendSmsFailed: 发送失败，请重试
 */
@interface QCloudSMHGetUpdatePhoneCodeRequest : QCloudSMHBaseRequest

/// 新手机号国家码，如 +86
@property (nonatomic,strong)NSString *countryCode;

/// 新手机号码，如 18888888888
@property (nonatomic,strong)NSString *phone;

/// user 令牌
@property (nonatomic,strong)NSString *userToken;
@end

NS_ASSUME_NONNULL_END
