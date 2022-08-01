//
//  QCloudSMHCancelLoginQrcodeRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 取消二维码扫码登录
 取消二维码，使登录二维码失效
 */
@interface QCloudSMHCancelLoginQrcodeRequest : QCloudSMHUserBizRequest

/// 二维码 UUID，必选参数
@property (nonatomic,strong)NSString * code;

@end

NS_ASSUME_NONNULL_END
