//
//  QCloudSMHCreateShareRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/24.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCreateShareResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 创建分享
/// @discussion 用于创建外链分享，支持分享多个文件或目录。要求对分享的文件有权限即可。
/// 创建成功后返回分享链接和相关信息。
@interface QCloudSMHCreateShareRequest : QCloudSMHBizRequest
/// 分享名称，必选参数
@property (nonatomic, strong) NSString *name;
/// 要分享的文件或目录路径数组，必选参数，最多 1000 条
@property (nonatomic, strong) NSArray<NSString *> *filePath;
/// 是否永久有效，默认为 NO。当为 NO 时，expireTime 必选
@property (nonatomic, assign) BOOL isPermanent;
/// 过期时间，ISO 8601 格式（如 "2024-12-31T23:59:59Z"），当 isPermanent 为 NO 时必选
@property (nonatomic, strong, nullable) NSString *expireTime;
/// 提取码，可选参数（6位以下字符串）
@property (nonatomic, strong, nullable) NSString *extractionCode;
/// 是否允许预览，默认为 NO
@property (nonatomic, assign) BOOL canPreview;
/// 是否允许下载，默认为 NO
@property (nonatomic, assign) BOOL canDownload;
/// 是否允许保存到网盘，默认为 NO
@property (nonatomic, assign) BOOL canSaveToNetdisk;
/// 是否禁止匿名用户访问，默认为 NO
@property (nonatomic, assign) BOOL forbidAnonymousUser;
/// 预览次数限制，可选参数（canPreview 为 NO 时忽略此参数）
@property (nonatomic, assign) NSInteger previewLimit;
/// 下载次数限制，可选参数（canDownload 为 NO 时忽略此参数）
@property (nonatomic, assign) NSInteger downloadLimit;
/// 访问用户数限制，可选参数（设置时禁止匿名用户访问，否则冲突报错）
@property (nonatomic, assign) NSInteger userLimit;
/// 指定分享给的用户列表，可选参数（设置时禁止匿名用户访问，否则冲突报错）
@property (nonatomic, strong, nullable) NSArray<NSString *> *shareToUsers;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHCreateShareResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
