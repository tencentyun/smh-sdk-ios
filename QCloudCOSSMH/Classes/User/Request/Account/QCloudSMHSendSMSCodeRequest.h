//
//  QCloudSMHSemdSMSCode.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudSMHSendSMSCodeType) {
    QCloudSMHSendSMSCodeSignIn = 0, // 手机号登录
    QCloudSMHSendSMSCodeBindMeetingPhone, // 会议绑定手机
    QCloudSMHSendSMSCodeBindWechatPhone, // 微信账号绑定手机
    QCloudSMHSendSMSCodeBindYufuPhone, // 玉符账号绑定手机
};

/**
 发送短信验证码至新手机号
 */
@interface QCloudSMHSendSMSCodeRequest : QCloudSMHBaseRequest

/// +86
@property (nonatomic,strong)NSString *countryCode;

/// 手机号
@property (nonatomic,strong)NSString *phone;

/// 短信类型，
/// QCloudSMHSendSMSCodeSignIn = 0,
/// QCloudSMHSendSMSCodeBindMeetingPhone,
/// QCloudSMHSendSMSCodeBindWechatPhone,
/// QCloudSMHSendSMSCodeBindYufuPhone
@property (nonatomic,assign)QCloudSMHSendSMSCodeType type;

/// 图形验证码 ticket，可选参数
@property (nonatomic,strong)NSString *captchaTicket;

/// 图形验证码 randstr，可选参数
@property (nonatomic,strong)NSString *captchaRandstr;

/// 渠道参数pf 会议渠道值为 meeting
@property (nonatomic,strong)NSString * pf;

@end

NS_ASSUME_NONNULL_END
