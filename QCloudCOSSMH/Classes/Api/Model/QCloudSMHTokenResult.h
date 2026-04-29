//
//  QCloudSMHTokenResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 访问令牌结果（对应 createToken / renewToken 响应）
@interface QCloudSMHTokenResult : NSObject
/** 访问令牌的具体值 */
@property (nonatomic, strong) NSString *accessToken;
/** 访问令牌的有效时长，单位为秒 */
@property (nonatomic, assign) NSInteger expiresIn;
@end
NS_ASSUME_NONNULL_END
