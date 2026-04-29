#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHShareFileListResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 列出分享文件（使用分享访问令牌，通过 verifyExtractionCode 获取）
@interface QCloudSMHListShareFilesRequest : QCloudSMHBaseRequest
/// 分享 Code，从分享链接中获取，必选参数
@property (nonatomic, strong) NSString *shareCode;
/// 分享访问令牌，通过 verifyExtractionCode 获取，必选参数
@property (nonatomic, strong) NSString *accessToken;
/// 文件 inode 链，用 / 分隔多级目录的 inode，为空时访问分享根目录，最大支持 64 层
@property (nonatomic, strong, nullable) NSString *inodes;
/// 每页返回的数量，默认 10，取值范围 0-100（超过 100 会返回 InvalidParameter）
@property (nonatomic, assign) NSInteger limit;
/// 分页标记，用于获取下一页，不传表示第一页
@property (nonatomic, strong, nullable) NSString *marker;
/// 排序字段，可选值：name / size / updatedAt / 空字符串（默认排序）
@property (nonatomic, strong, nullable) NSString *orderBy;
/// 排序方式，可选值：asc（升序）/ desc（降序），默认为 asc
@property (nonatomic, strong, nullable) NSString *orderByType;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareFileListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
