//
//  QCloudSMHCheckLoginQrcodeRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 二维码验证
 可能错误码：
 QrCodeInvalidOrExpired: 二维码无效或过期
 */
@interface QCloudSMHCheckLoginQrcodeRequest : QCloudSMHUserBizRequest

/// 二维码 UUID
@property (nonatomic,strong)NSString * code;

@end

NS_ASSUME_NONNULL_END
