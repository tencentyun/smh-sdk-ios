#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHSaveShareFileResult.h"

NS_ASSUME_NONNULL_BEGIN
/// 转存分享文件
@interface QCloudSMHSaveShareFileRequest : QCloudSMHBaseRequest
/// 分享 Code，必选参数
@property (nonatomic, strong) NSString *shareCode;
/// 目标空间 ID，即用户要转存到的空间，必选参数
@property (nonatomic, strong) NSString *targetSpaceId;
/// 目标路径，转存文件的存放位置（路径必须存在，该接口不会自动创建路径）
@property (nonatomic, strong, nullable) NSString *targetPath;
/// 从分享的根目录到待分享文件的路径，必选参数
@property (nonatomic, strong) NSString *sourceInodesPath;
/// 要转存的文件或目录的 inode 列表，必选参数，最大 1000
@property (nonatomic, strong) NSArray<NSString *> *inodes;
/// 文件名冲突时的处理方式：ask / rename / overwrite
@property (nonatomic, strong, nullable) NSString *conflictResolutionStrategy;
/// 分享访问令牌，通过 verifyExtractionCode 获取
@property (nonatomic, strong, nullable) NSString *accessToken;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSaveShareFileResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
