//
//  QCloudSMHTaskResult.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//  一个批量任务中每一个子任务的结果

#import <Foundation/Foundation.h>
#import "QCloudSMHBatchTaskStatusEnum.h"
@class QCloudSMHTaskResultInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHTaskResult : NSObject



#pragma mark -查询接口相关
//每一个具体任务的状态码
@property (nonatomic,assign) QCloudSMHBatchTaskStatus status;
//每一个具体任务的状态码
@property (nonatomic,copy) NSArray *paths;

/**
 复制相关
 */
@property (nonatomic,copy) NSArray *fromPaths;
@property (nonatomic,copy) NSArray *toPaths;

/**
 删除相关
 */
//回收站的id
@property (nonatomic,strong) NSString *recycledItemId;
/**
 错误信息
 */
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *message;
@end

NS_ASSUME_NONNULL_END
