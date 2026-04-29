//
//  QCloudSMHCreateTokenRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHTokenResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 生成访问令牌（使用 librarySecret 认证，不使用 AccessToken）
@interface QCloudSMHCreateTokenRequest : QCloudSMHBaseRequest
/// 媒体库 ID，必选
@property (nonatomic, strong) NSString *libraryId;
/// 媒体库密钥，必选
@property (nonatomic, strong) NSString *librarySecret;
/// 空间 ID，可同时指定多个空间 ID，使用英文逗号分隔
@property (nonatomic, strong) NSString *spaceId;
/// 用户身份识别
@property (nonatomic, strong) NSString *userId;
/// 客户端识别
@property (nonatomic, strong) NSString *clientId;
/// SessionId
@property (nonatomic, strong) NSString *sessionId;
/// 令牌有效时长及每次使用令牌后自动续期的有效时长，单位为秒，默认 86400，取值范围 300~315360000
@property (nonatomic, assign) NSInteger period;
/// 授予的权限，如为空则只授予读取权限。
/// 可选值：admin / create_space / delete_space / space_admin / create_directory / delete_directory /
/// delete_directory_permanent / move_directory / copy_directory / upload_file / upload_file_force /
/// begin_upload / begin_upload_force / confirm_upload / create_symlink / create_symlink_force /
/// delete_file / delete_file_permanent / move_file / move_file_force / copy_file / copy_file_force /
/// delete_recycled / restore_recycled
@property (nonatomic, strong) NSString *grant;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
