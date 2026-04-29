//
//  QCloudSMHEmptyHistoryResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 清空历史版本响应结果（对应 emptyHistory 响应）
@interface QCloudSMHEmptyHistoryResult : NSObject

/// 异步任务 ID
@property (nonatomic, assign) NSInteger taskId;

@end

NS_ASSUME_NONNULL_END
