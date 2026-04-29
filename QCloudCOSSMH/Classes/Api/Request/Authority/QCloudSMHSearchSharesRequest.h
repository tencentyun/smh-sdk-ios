#import "QCloudSMHBizRequest.h"
#import "QCloudSMHShareListResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 搜索分享
/// @discussion 仅限管理员（admin）调用，普通用户调用将返回 403 NoPermission。
/// 本接口 QPS 使用上限为 10，不可用于业务的高频操作页面。
@interface QCloudSMHSearchSharesRequest : QCloudSMHBizRequest
/// 分享名称，模糊搜索，可选参数
@property (nonatomic, strong, nullable) NSString *name;
/// 创建者 ID，按创建者精确筛选，可选参数
@property (nonatomic, strong, nullable) NSString *creatorId;
/// 排序字段，可选值：createTime / expireTime / name / creatorId，默认为 createTime
@property (nonatomic, strong, nullable) NSString *orderBy;
/// 排序方式，可选值：asc（升序）/ desc（降序），默认为 asc
@property (nonatomic, strong, nullable) NSString *orderByType;
/// 过期时间范围起始，ISO 8601 格式，可选参数
@property (nonatomic, strong, nullable) NSString *expireTimeStart;
/// 过期时间范围结束，ISO 8601 格式（必须大于等于开始时间），可选参数
@property (nonatomic, strong, nullable) NSString *expireTimeEnd;
/// 创建时间范围起始，ISO 8601 格式，可选参数
@property (nonatomic, strong, nullable) NSString *createTimeStart;
/// 创建时间范围结束，ISO 8601 格式（必须大于等于开始时间），可选参数
@property (nonatomic, strong, nullable) NSString *createTimeEnd;
/// 返回数量，默认 10，最大 50
@property (nonatomic, assign) NSInteger limit;
/// 分页标记，用于获取下一页，不填则从第一页开始
@property (nonatomic, strong, nullable) NSString *marker;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHShareListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
