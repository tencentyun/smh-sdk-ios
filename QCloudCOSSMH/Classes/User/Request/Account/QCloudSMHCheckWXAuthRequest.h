//
//  QCloudSMHCheckWXAuthRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHChechWXAuthResult.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于检查微信授权是否有效
 */
@interface QCloudSMHCheckWXAuthRequest : QCloudSMHUserBizRequest

/// 授权类型，可选参数，默认为web，其他可选值：mobile 用于移动端授权登录。
@property (nonatomic,assign)QCloudSMHLoginAuthType authType;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHChechWXAuthResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
