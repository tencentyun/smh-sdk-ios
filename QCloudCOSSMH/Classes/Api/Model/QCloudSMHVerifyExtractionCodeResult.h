//
//  QCloudSMHVerifyExtractionCodeResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 验证提取码响应（对应 verifyExtractionCode 响应）
@interface QCloudSMHVerifyExtractionCodeResult : NSObject
/** 分享访问令牌，用于后续访问分享内容，有效期为 10 分钟 */
@property (nonatomic, strong) NSString *accessToken;
/** 令牌过期时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *expireTime;
@end
NS_ASSUME_NONNULL_END
