#import "QCloudSMHBizRequest.h"
#import "QCloudSMHShareListResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 列出分享
/// @discussion 要求权限：admin、分享创建者。管理员可以按创建者进行筛选。
@interface QCloudSMHListSharesRequest : QCloudSMHBizRequest
/// 返回数量，默认 10，最大 100，可选参数
@property (nonatomic, assign) NSInteger limit;
/// 分页标记，用于获取下一页，不填则从第一页开始，可选参数
@property (nonatomic, strong, nullable) NSString *marker;
/// 排序字段，可选值：createTime / expireTime / name / creatorId，默认为 createTime
@property (nonatomic, strong, nullable) NSString *orderBy;
/// 排序方式，可选值：asc（升序）/ desc（降序），默认为 asc
@property (nonatomic, strong, nullable) NSString *orderByType;
/// 按创建者 ID 筛选，仅管理员指定有效，可选参数
@property (nonatomic, strong, nullable) NSString *creatorId;
/// 是否返回文件信息，设置为 YES 时返回 fileInfo 字段，默认不返回
@property (nonatomic, assign) BOOL withFileInfo;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
