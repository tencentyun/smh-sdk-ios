//
//  QCloudSMHSSOLoginRedirectRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/**
 进行 SSO 登录的重定向，跳到第三方登录平台进行身份认证
 */
@interface QCloudSMHSSOLoginRedirectRequest :QCloudSMHBaseRequest

@property (nonatomic,strong)NSString * domain;

@property (nonatomic,strong)NSString * corpId;

/// ，可选参数，是否自动重定向，若true则由后端直接重定向，否则返回重定向跳转地址，默认为true
@property (nonatomic,assign)BOOL autoRedirect;


@property (nonatomic,strong)NSString * from;

@property (nonatomic,strong)NSString * SSOWay;

@property (nonatomic,strong)NSString * customState;

-(void)setFinishBlock:(void (^ _Nullable)(NSString * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
