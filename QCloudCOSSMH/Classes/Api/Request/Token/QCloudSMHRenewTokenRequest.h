//
//  QCloudSMHRenewTokenRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHTokenResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 续期访问令牌（无需认证）
@interface QCloudSMHRenewTokenRequest : QCloudSMHBaseRequest
/// 媒体库 ID
@property (nonatomic, strong) NSString *libraryId;
/// 访问令牌
@property (nonatomic, strong) NSString *accessToken;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
