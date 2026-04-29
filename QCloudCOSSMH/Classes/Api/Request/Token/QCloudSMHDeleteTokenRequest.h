//
//  QCloudSMHDeleteTokenRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 删除指定访问令牌（无需认证）
@interface QCloudSMHDeleteTokenRequest : QCloudSMHBaseRequest
/// 媒体库 ID
@property (nonatomic, strong) NSString *libraryId;
/// 访问令牌
@property (nonatomic, strong) NSString *accessToken;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
