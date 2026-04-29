//
//  QCloudSMHDeleteUserTokensRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 删除特定用户的所有访问令牌（使用 librarySecret 认证，不使用 AccessToken）
@interface QCloudSMHDeleteUserTokensRequest : QCloudSMHBaseRequest
/// 媒体库 ID
@property (nonatomic, strong) NSString *libraryId;
/// 媒体库密钥
@property (nonatomic, strong) NSString *librarySecret;
/// 用户 ID
@property (nonatomic, strong) NSString *userId;
/// 客户端识别，多个 ClientId 用英文逗号分隔，一次最多不超过 100 个
@property (nonatomic, strong, nullable) NSString *clientId;
/// 会话识别，多个 SessionId 用英文逗号分隔，一次最多不超过 100 个
@property (nonatomic, strong, nullable) NSString *sessionId;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
