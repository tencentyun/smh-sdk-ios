//
//  QCloudSMHVerifyYufuCodeRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/7/06.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 根据玉符授权 code 获取用户登录信息。
 
 1：第一次登录，只需要传 code 和 TenantName，如果接口返回 403 NotBindPhoneNumber，则调用发送验证码接口，获取到验证码后
 填写 code TenantName smsCode 和phoneNumber，重新调用接口，就绑定成功并登录成功。
 2：后面再登录 只需要传code 和 TenantName即可登录成功。
 
 可能的错误码 NotBindPhoneNumber
 */
@interface QCloudSMHVerifyYufuCodeRequest : QCloudSMHBaseRequest

/**
 玉符租户 ID，字符串，必选参数，和 Domain 二选一；
 */
@property (nonatomic,strong)NSString * tenantName;

/**
 企业自定义域名，字符串，必选参数，和 TenantName 二选一；
 */
@property (nonatomic,strong)NSString * domain;

/**
 玉符登录类型，字符串，必选参数，值为：domain 或 tenantName；
 */
@property (nonatomic,assign)QCloudSMHYufuLoginType type;
/**
 玉符验证码，字符串，必选参数
 */
@property (nonatomic,strong)NSString * code;
/**
 设备名称，例如 iPhone 12 Pro 等，用于区分客户端，可选参数
 */
@property (nonatomic,strong)NSString * deviceId;
/**
 国家代码，如 +86，可选参数，未绑定手机号时才需传入
 */
@property (nonatomic,strong)NSString * countryCode;
/**
 手机号码，如 18912345678，可选参数，未绑定手机号时才需传入
 */
@property (nonatomic,strong)NSString * phoneNumber;
/**
 短信验证码，可选参数，未绑定手机号时才需传入
 */
@property (nonatomic,strong)NSString * smsCode;

/**
 授权类型，可选参数，默认为web，其他可选值：mobile 用于移动端授权登录。
 */
@property (nonatomic,assign)QCloudSMHLoginAuthType authType;

/// 是否仅允许登录企业版，1 - 仅企业版可登录，0 - 所有版本账号都可登录，默认 0，可选参数
@property (nonatomic,assign)QCloudSMHAllowEditionType allowEdition;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
