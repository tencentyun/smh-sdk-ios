//
//  QCloudSMHFileDeletionCheckRequest.h
//  QCloudCOSSMH
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHFileDeletionCheckResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查询文件删除原因
 用户查询文件删除的原因，可能是用户主动删除或者 quota 超限删除。
 要求权限：admin 或者 space_admin。
 */
@interface QCloudSMHFileDeletionCheckRequest : QCloudSMHBizRequest

/**
 文件的 Inode
 */
@property (nonatomic, strong) NSString *inode;

- (void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFileDeletionCheckResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
