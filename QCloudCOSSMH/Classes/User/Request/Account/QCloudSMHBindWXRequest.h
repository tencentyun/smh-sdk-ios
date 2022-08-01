//
//  QCloudSMHBindWXRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHUserDetailInfo.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于云盘用户绑定微信账号。
 */
@interface QCloudSMHBindWXRequest : QCloudSMHUserBizRequest

/// 授权类型，可选参数，默认为web，其他可选值：mobile 用于移动端授权登录。
@property (nonatomic,assign)QCloudSMHLoginAuthType authType;

/// AuthCode: 授权码；
@property (nonatomic,strong)NSString * authCode;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHUserDetailInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
