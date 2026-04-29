//
//  QCloudSMHFileDeletionCheckResult.h
//  QCloudCOSSMH
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 文件删除原因查询结果
 */
@interface QCloudSMHFileDeletionCheckResult : NSObject

/**
 文件删除的原因，RemovedByQuota 或者 Unknown
 */
@property (nonatomic, strong) NSString *reason;

/**
 文件删除的时间
 */
@property (nonatomic, strong) NSString *deletedAt;

/**
 quota 超限删除流水保留天数
 */
@property (nonatomic, assign) NSInteger quotaCleanupRecordRetentionDays;

@end

NS_ASSUME_NONNULL_END
