//
//  QCloudSMHCalibrateDirectoryStatsResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 修正目录统计数据响应结果（对应 calibrateDirectoryStats 响应）
@interface QCloudSMHCalibrateDirectoryStatsResult : NSObject

/// 异步方式修正时的任务 ID，可通过查询任务接口查询任务状态
@property (nonatomic, assign) NSInteger taskId;

@end

NS_ASSUME_NONNULL_END
