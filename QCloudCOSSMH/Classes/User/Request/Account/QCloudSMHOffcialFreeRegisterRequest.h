//
//  QCloudSMHOffcialFreeRegisterRequest.h
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
@interface QCloudSMHOffcialFreeRegisterRequest : QCloudSMHBaseRequest

/// : 设备名称，例如 iPhone 12 Pro 等，用于区分客户端，可选参数
@property (nonatomic,strong)NSString * deviceId;

/// 用户token 必填,
@property (nonatomic,strong)NSString * userToken;

/// 是否仅查询免费活动状态, 仅查询状态填1,默认为0 选填
@property (nonatomic,assign)BOOL checkOnly;

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
