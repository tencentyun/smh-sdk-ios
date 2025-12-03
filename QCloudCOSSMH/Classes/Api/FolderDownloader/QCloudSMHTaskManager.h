//
//  QCloudSMHTaskManager.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>
#import "QCloudSMHTaskDatabaseManager.h"
#import "QCloudSMHTaskManagerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudSMHFolderTask;
@class QCloudSMHFileTask;
@class QCloudSMHTaskManager;
@class QCloudSMHDownloadRequest;
@class QCloudSMHBaseTask;

#pragma mark - 任务事件订阅者协议

/**
 * 任务事件订阅者协议
 * 订阅者通过实现此协议来监听任务的进度更新和完成事件
 */
@protocol QCloudSMHTaskEventSubscriber <NSObject>

@optional

/**
 * 任务进度更新回调（包含状态信息）
 * @param taskId 任务ID
 * @param path 任务路径
 * @param bytesProcessed 已处理字节数
 * @param totalBytes 总字节数
 * @param completedFiles 已完成文件数
 * @param totalFiles 总文件数
 * @param taskType 任务类型
 */
- (void)onTaskProgressUpdated:(NSString *)taskId
                         path:(NSString *)path
                bytesProcessed:(int64_t)bytesProcessed
                   totalBytes:(int64_t)totalBytes
             completedFiles:(int)completedFiles
                   totalFiles:(int)totalFiles
                     taskType:(QCloudSMHTaskType)taskType;

/**
 * 任务状态变更回调
 * @param taskId 任务ID
 * @param path 任务路径
 * @param state 任务状态
 * @param oldState 任务旧状态
 * @param error 错误信息（如果失败）
 * @param taskType 任务类型
 */
- (void)onTaskStateChanged:(NSString *)taskId
                path:(NSString *)path
                state:(QCloudSMHTaskState)state
             oldState:(QCloudSMHTaskState)oldState
                 error:(NSError * _Nullable)error
              taskType:(QCloudSMHTaskType)taskType;

/**
 * 任务删除回调
 * @param taskId 任务ID
 * @param path 任务路径
 * @param taskType 任务类型
 * @param error 错误信息（如果失败）
 * @param statistics 任务统计信息
 */
@optional
- (void)onTaskDeleted:(NSString *)taskId path:(NSString *)path taskType:(QCloudSMHTaskType)taskType error:(NSError * _Nullable)error statistics:(NSDictionary * _Nullable)statistics;

@end

#pragma mark - 任务管理器

/**
 * 任务管理器
 * 统一管理文件夹任务和文件任务的生命周期
 * 负责任务创建、缓存、调度、并发控制、事件订阅等
 */
@interface QCloudSMHTaskManager : NSObject

#pragma mark - 单例模式

/**
 * 获取任务管理器单例
 * @return 任务管理器实例
 */
+ (instancetype)sharedManager;

/**
 * 重置单例（仅用于测试）
 * 释放当前单例实例，下次调用 sharedManager 时会创建新实例
 * 注意：此方法会取消所有进行中的任务
 */
+ (void)resetSharedManager;


#pragma mark - 数据库和配置

/**
 * 数据库管理器
 * 用于访问SQLite数据库中的任务记录
 */
@property (nonatomic, strong, readonly) QCloudSMHTaskDatabaseManager *databaseManager;

/**
 * 任务管理器配置
 * 包含并发数、缓存大小、超时时间等配置参数
 */
@property (nonatomic, strong, readonly) QCloudSMHTaskManagerConfig *config;

#pragma mark - 任务创建

/**
 * 创建文件夹下载任务
 * 创建一个新的文件夹任务对象
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remoteFolderPath 远程文件夹路径
 * @param localFolderURL 本地保存文件夹URL
 * @param conflictStrategy 文件冲突处理策略
 * @param enableResumeDownload 是否启用断点续传
 * @param enableCRC64Verification 是否启用CRC64校验
 * @return 创建的文件夹任务对象
 */
- (QCloudSMHFolderTask *)createFolderTaskWithLibraryId:(NSString *)libraryId
                                               spaceId:(NSString *)spaceId
                                                userId:(NSString *)userId
                                      remoteFolderPath:(NSString *)remoteFolderPath
                                        localFolderURL:(NSURL *)localFolderURL
                                      conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy
                                   enableResumeDownload:(BOOL)enableResumeDownload
                                enableCRC64Verification:(BOOL)enableCRC64Verification;

/**
 * 创建文件下载任务
 * 创建一个新的文件任务对象
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remotePath 远程文件路径
 * @param localURL 本地保存文件夹URL
 * @param fileName 文件名
 * @param fileSize 文件大小
 * @param conflictStrategy 文件冲突处理策略
 * @param enableResumeDownload 是否启用断点续传
 * @param enableCRC64Verification 是否启用CRC64校验
 * @return 创建的文件任务对象
 */
- (QCloudSMHFileTask *)createFileTaskWithLibraryId:(NSString *)libraryId
                                           spaceId:(NSString *)spaceId
                                            userId:(NSString *)userId
                                        remotePath:(NSString *)remotePath
                                          localURL:(NSURL *)localURL
                                          fileName:(NSString *)fileName
                                         fileSize:(int64_t)fileSize
                                 conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy
                              enableResumeDownload:(BOOL)enableResumeDownload
                           enableCRC64Verification:(BOOL)enableCRC64Verification;


/**
 * 根据下载请求创建任务
 * 根据请求类型创建对应的文件或文件夹任务
 *
 * @param request 下载请求对象
 * @return 创建的任务对象（文件任务或文件夹任务）
 */
- (QCloudSMHBaseTask *)createTaskWithRequest:(QCloudSMHDownloadRequest *)request;



/**
 * 从数据库记录创建任务实例
 */
- (QCloudSMHBaseTask *)createTaskFromRecord:(QCloudSMHTaskRecord *)record;



/**
 * 通知任务已创建（发送初始进度）
 */
- (void)notifyTaskCreated:(QCloudSMHBaseTask *)task;

#pragma mark - 任务控制

/**
 * 启动任务
 */
- (void)startTask:(QCloudSMHBaseTask *)task;

/**
 * 启动指定ID的任务
 * 将任务从等待队列移到执行队列，开始下载
 *
 * @param taskId 任务ID
 */
- (void)startTaskById:(NSString *)taskId;

/**
 * 恢复指定ID的任务
 */
- (void)resumeTaskById:(NSString *)taskId;

/**
 * 暂停指定ID的任务
 * 暂停任务的下载，保存进度以便后续恢复
 *
 * @param taskId 任务ID
 */
- (void)pauseTaskById:(NSString *)taskId;

/**
 * 取消指定ID的任务
 * 取消任务的下载，删除已下载的部分文件
 *
 * @param taskId 任务ID
 */
- (void)cancelTaskById:(NSString *)taskId;

/**
 * 删除指定ID的任务
 * 删除任务记录和已下载的文件
 *
 * @param taskId 任务ID
 */
- (void)deleteTaskById:(NSString *)taskId;

#pragma mark - 任务查询

/**
 * 从缓存池获取任务
 * 仅查询内存缓存中的任务，不访问数据库
 *
 * @param taskId 任务ID
 * @return 任务对象，如果缓存中不存在则返回nil
 */
- (QCloudSMHBaseTask * _Nullable)getTaskById:(NSString *)taskId;

/**
 * 获取任务，如果缓存中不存在则从数据库加载
 * 先查询缓存，如果不存在则从数据库加载
 *
 * @param taskId 任务ID
 * @return 任务对象，如果不存在则返回nil
 */
- (QCloudSMHBaseTask *_Nullable)getOrLoadTaskById:(NSString *)taskId;

#pragma mark - 数据库操作

/**
 * 保存任务状态到数据库
 * 将任务的当前状态和进度保存到数据库
 *
 * @param task 要保存的任务对象
 */
- (void)saveTaskStateToDatabase:(QCloudSMHBaseTask *)task;


#pragma mark - 缓存池管理

/**
 * 添加任务到缓存池
 * 将任务加入内存缓存，便于快速访问
 *
 * @param task 要添加的任务对象
 */
- (void)addTaskToCache:(QCloudSMHBaseTask *)task;

/**
 * 从对应的缓存池中移除任务
 */
- (void)removeTaskFromCache:(NSString *)taskId;

/**
 * 从等待中移除任务
 */
- (void)removeTaskFromWaitingQueue:(NSString *)taskId;

/**
 * 判断是否存在待处理/正在处理的任务
 */
- (BOOL)containNeedHandleTask:(NSString *)taskId;



#pragma mark - 配置更新

/**
 * 更新任务管理器配置
 * 动态调整并发数、缓存大小、超时时间等参数
 *
 * @param config 新的配置对象
 */
- (void)updateConfig:(QCloudSMHTaskManagerConfig *)config;

#pragma mark - 事件订阅管理

/**
 * 订阅任务事件
 * 注册为任务事件订阅者，以便接收任务进度和状态变化通知
 *
 * @param subscriber 订阅者对象，必须实现 QCloudSMHTaskEventSubscriber 协议
 */
- (void)subscribeTaskEvents:(id<QCloudSMHTaskEventSubscriber>)subscriber;

/**
 * 取消订阅任务事件
 * 注销任务事件订阅，停止接收任务通知
 *
 * @param subscriber 订阅者对象
 */
- (void)unsubscribeTaskEvents:(id<QCloudSMHTaskEventSubscriber>)subscriber;

/**
 * 添加任务到用户主动订阅队列
 * 将任务对象直接存储在订阅队列中，便于快速访问和管理
 *
 * @param task 要添加的任务对象
 * @param error 如果添加失败（队列满或任务无效），返回错误信息
 * @return 是否成功添加到队列
 */
- (BOOL)addTaskToSubscribedQueue:(QCloudSMHBaseTask *)task error:(NSError * _Nullable * _Nullable)error;

/**
 * 从用户订阅队列中移除任务
 * 根据任务ID查找并移除队列中对应的任务对象
 *
 * @param taskId 要移除的任务ID
 */
- (void)removeTaskIdFromSubscribedQueue:(NSString *)taskId;

/**
 * 从用户订阅队列中获取任务
 * 根据任务ID查找并返回队列中对应的任务对象
 *
 * @param taskId 任务ID
 * @return 若找到返回任务对象，否则返回nil
 */
- (nullable QCloudSMHBaseTask *)getTaskFromSubscribedQueue:(NSString *)taskId;

@end

NS_ASSUME_NONNULL_END
