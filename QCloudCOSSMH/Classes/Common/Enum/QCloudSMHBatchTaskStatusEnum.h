//
//  QCloudSMHBatchTaskStatusEnum.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudSMHBatchTaskStatus) {
    QCloudSMHBatchTaskStatusWating = 1,
    QCloudSMHBatchTaskStatusSucceed,
    QCloudSMHBatchTaskStatusFaliure
};
QCloudSMHBatchTaskStatus QCloudSMHBatchTaskStatusTypeFromStatus(NSInteger status);
NS_ASSUME_NONNULL_END
