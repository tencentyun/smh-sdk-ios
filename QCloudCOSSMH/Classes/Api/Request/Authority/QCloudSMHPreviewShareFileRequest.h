#import "QCloudSMHBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 分享文件预览
/// @discussion 通过分享链接预览文件，接口通过 302 重定向返回可直接用于预览的文件 URL。
@interface QCloudSMHPreviewShareFileRequest : QCloudSMHBaseRequest
/// 分享 Code，必选参数
@property (nonatomic, strong) NSString *shareCode;
/// 文件 inode，必选参数
@property (nonatomic, strong) NSString *inodes;
/// 分享访问令牌，通过 verifyExtractionCode 获取
@property (nonatomic, strong, nullable) NSString *accessToken;
/// 是否使用内网域名生成文件访问链接，0 或 1，可选参数，默认不使用
@property (nonatomic, assign) NSInteger internalDomain;
- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
