//
//  QCloudSMHBaseTask.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHCommonEnum.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * 任务进度回调
 * @param taskId 任务ID
 * @param bytesProcessed 已处理字节数
 * @param totalBytes 总字节数
 * @param completedFiles 已完成文件数
 * @param totalFiles 总文件数
 */
typedef void (^QCloudSMHTaskProgressCallback)(NSString *taskId, int64_t bytesProcessed, int64_t totalBytes, int completedFiles, int totalFiles);

/**
 * 任务状态变化回调
 * @param taskId 任务ID
 * @param state 当前状态
 * @param oldState 旧状态
 */
typedef void (^QCloudSMHTaskStateChangeCallback)(NSString *taskId, QCloudSMHTaskState state, QCloudSMHTaskState oldState, NSError * _Nullable error);


#pragma mark - 基础任务类

/**
 * 基础任务类 - 提供任务管理的通用实现
 */
@interface QCloudSMHBaseTask : NSObject

#pragma mark - 基础属性

/**
 * 任务唯一标识
 */
@property (nonatomic, copy, readonly) NSString *taskId;

/**
 * 库ID
 */
@property (nonatomic, copy, readonly) NSString *libraryId;

/**
 * 空间ID
 */
@property (nonatomic, copy, readonly) NSString *spaceId;

/**
 * 用户ID
 */
@property (nonatomic, copy, readonly) NSString *userId;

/**
 * 远程路径（文件路径或文件夹路径）
 */
@property (nonatomic, copy, readonly) NSString *remotePath;

/**
 * 本地保存URL（文件URL或文件夹URL）
 */
@property (nonatomic, strong, readonly) NSURL *localURL;

/**
 * 文件重名冲突策略 (默认: QCloudSMHConflictStrategyEnumOverWrite)
 */
@property (nonatomic, assign) QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 * 是否启用断点续传 (默认: YES)
 */
@property (nonatomic, assign) BOOL enableResumeDownload;

/**
 * 是否启用crc64校验(默认: YES)
 */
@property (nonatomic, assign) BOOL enableCRC64Verification;

/**
 * 任务状态
 */
@property (nonatomic, assign) QCloudSMHTaskState state;

/**
 * 任务类型
 */
@property (nonatomic, assign) QCloudSMHTaskType taskType;

/**
 * 错误信息
 */
@property (nonatomic, strong, nullable) NSError *error;

/**
 * 任务创建时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval createdTime;

/**
 * 是否需要启动任务（默认启动）
 */
@property (nonatomic, assign) BOOL enableStart;

#pragma mark - 回调块

/**
 * 进度回调
 */
@property (nonatomic, copy, nullable) QCloudSMHTaskProgressCallback progressCallback;

/**
 * 状态变化回调
 */
@property (nonatomic, copy, nullable) QCloudSMHTaskStateChangeCallback stateChangeCallback;


#pragma mark - 初始化
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                 remotePath:(NSString *)remotePath
                   localURL:(NSURL *)localURL
             enableResumeDownload:(BOOL)enableResumeDownload
          enableCRC64Verification:(BOOL)enableCRC64Verification
                conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy;

#pragma mark - 任务操作方法

/**
 * 开始任务
 */
- (void)start;

/**
 * 暂停任务
 */
- (void)pause;

/**
 * 取消任务
 */
- (void)cancel;

/**
 * 删除任务
 */
- (void)delete;

#pragma mark - 任务状态判断
/**
 * 判断任务是否处于非活动状态
 */
+ (BOOL)isInactiveState:(QCloudSMHTaskState)state;

/**
 * 判断任务是否处于终止状态
 */
+ (BOOL)isTerminalState:(QCloudSMHTaskState)state;


#pragma mark - 数据库恢复
/**
 * 从数据库恢复任务状态
 */
- (BOOL)restoreStateFromDatabase;

/**
 * 保存任务状态到数据库
 */
- (void)saveStateToDatabase;

#pragma mark - 内部属性（子类仅可访问）

@property (nonatomic, strong, readonly) NSRecursiveLock *lock;

/**
 * 任务已处理字节数
 */
@property (nonatomic, assign, readonly) int64_t bytesProcessed;

/**
 * 任务总字节数
 */
@property (nonatomic, assign, readonly) int64_t totalBytes;

/**
 * 任务以处理的文件数
 */
@property (nonatomic, assign, readonly) int32_t filesProcessed;

/**
 * 任务总文件数
 */
@property (nonatomic, assign, readonly) int32_t totalFiles;


/**
 * 内部方法：在子线程中安全地更新进度信息
 */
- (void)updateProgressWithBytesProcessed:(int64_t)bytesProcessed
                              totalBytes:(int64_t)totalBytes
                           filesProcessed:(int32_t)filesProcessed
                              totalFiles:(int32_t)totalFiles;


/**
 * 重置任务任务（包含进度和状态）
 */
- (void)resetTask;

/**
 * 重置任务状态
 */
- (void)resetState;

/**
 * 确保当前目录存在
 */
- (NSError *)ensureCurrentDirectoryExists;

/**
 * 通知任务进度更新
 */
- (void)notifyTaskProgressUpdate;

/**
 * 通知状态变化
 */
- (void)notifyStateChange:(QCloudSMHTaskState)oldState;
@end

NS_ASSUME_NONNULL_END

