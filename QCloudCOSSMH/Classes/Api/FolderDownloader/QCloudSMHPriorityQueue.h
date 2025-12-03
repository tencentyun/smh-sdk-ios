//
//  QCloudSMHPriorityQueue.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/12/01
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 优先级队列项
 * 用于管理任务ID和对应的优先级
 */
@interface QCloudSMHPriorityQueueItem : NSObject

/**
 * 任务ID
 */
@property (nonatomic, strong, nonnull) NSString *taskId;

/**
 * 优先级（越大越优先）
 * Idle: 10, Paused: 5, Failed: 1
 */
@property (nonatomic, assign) NSInteger priority;

/**
 * 初始化优先级队列项
 */
- (instancetype)initWithTaskId:(NSString *)taskId priority:(NSInteger)priority;

@end

/**
 * 优先级队列
 * 基于优先级排序的任务队列
 * 插入时自动按优先级排序，确保高优先级任务总是优先调度
 * 
 * 注意：队列本身不提供线程安全性，调用方需通过外部锁保证并发安全
 */
@interface QCloudSMHPriorityQueue : NSObject

/**
 * 初始化优先级队列
 */
- (instancetype)init;

/**
 * 添加任务到队列
 * 自动按优先级排序，O(n) 时间复杂度
 *
 * @param taskId 任务ID
 * @param priority 优先级（越大越优先）
 */
- (void)addTaskId:(NSString *)taskId withPriority:(NSInteger)priority;

/**
 * 获取队列中第一个任务ID（最高优先级）
 * 不移除任务
 *
 * @return 任务ID，如果队列为空返回nil
 */
- (NSString * _Nullable)peek;

/**
 * 移除并获取队列中第一个任务ID（最高优先级）
 *
 * @return 任务ID，如果队列为空返回nil
 */
- (NSString * _Nullable)poll;

/**
 * 移除指定的任务ID
 *
 * @param taskId 要移除的任务ID
 * @return 是否成功移除
 */
- (BOOL)removeTaskId:(NSString *)taskId;

/**
 * 检查队列中是否包含指定任务ID
 *
 * @param taskId 任务ID
 * @return 是否包含
 */
- (BOOL)containsTaskId:(NSString *)taskId;

/**
 * 获取队列中的任务数量
 *
 * @return 任务数量
 */
- (NSInteger)count;

/**
 * 判断队列是否为空
 *
 * @return 是否为空
 */
- (BOOL)isEmpty;

/**
 * 清空队列
 */
- (void)clear;

/**
 * 获取所有任务ID的副本
 *
 * @return 任务ID数组
 */
- (NSArray<NSString *> *)allTaskIds;

@end

NS_ASSUME_NONNULL_END
