//
//  QCloudSMHListSpaceRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSpaceListResult.h"
NS_ASSUME_NONNULL_BEGIN
/// 列出租户空间
/// @discussion 如需列出所有租户空间，需要 admin 或 space_admin 权限，否则仅列出当前访问令牌所代表的用户所创建的租户空间。
@interface QCloudSMHListSpaceRequest : QCloudSMHBizRequest
/// 用于顺序列出分页的标识，不填则从第一页开始，可选参数
@property (nonatomic, strong) NSString *marker;
/// 用于顺序列出分页时本次列出的项目数限制，可选参数
@property (nonatomic, assign) NSInteger limit;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpaceListResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
