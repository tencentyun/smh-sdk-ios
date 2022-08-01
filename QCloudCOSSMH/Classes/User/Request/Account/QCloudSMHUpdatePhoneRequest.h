//
//  QCloudSMHUpdatePhoneRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 更新手机号全局生效，更改生效后，用户登录其它组织也需要使用需要用新手机号
 */
@interface QCloudSMHUpdatePhoneRequest : QCloudSMHBaseRequest


/// 默认+86 可以不传
@property (nonatomic,strong)NSString *countryCode;


/// 手机号
@property (nonatomic,strong)NSString *phone;

/// 验证码
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *userToken;
@end

NS_ASSUME_NONNULL_END
