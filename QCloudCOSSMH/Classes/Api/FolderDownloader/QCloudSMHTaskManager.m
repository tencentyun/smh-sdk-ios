//
//  QCloudSMHTaskManager.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHTaskManager.h"
#import "QCloudSMHFolderTask.h"
#import "QCloudSMHFileTask.h"
#import "QCloudSMHTaskManagerConfig.h"
#import "QCloudSMHTaskError.h"
#import "QCloudSMHDownloadRequest.h"
#import "QCloudSMHPriorityQueue.h"

@interface QCloudSMHTaskManager () {
    NSRecursiveLock *_taskLock;
    NSRecursiveLock *_subscriberLock;
}

#pragma mark - 任务管理（双缓存池 + 文件等待队列 + 文件夹优先级队列）
@property (nonatomic, strong) NSMutableDictionary<NSString *, QCloudSMHBaseTask *> *folderTaskCache;  // 文件夹任务缓存池
@property (nonatomic, strong) NSMutableDictionary<NSString *, QCloudSMHBaseTask *> *fileTaskCache;    // 文件任务缓存池
@property (nonatomic, strong) NSMutableArray<NSString *> *fileWaitingQueue;                          // 文件任务等待队列
@property (nonatomic, strong) QCloudSMHPriorityQueue *folderWaitingQueue;                            // 文件夹任务优先级队列

#pragma mark - 数据库和配置
@property (nonatomic, strong) QCloudSMHTaskDatabaseManager *databaseManager;
@property (nonatomic, strong) QCloudSMHTaskManagerConfig *config;

#pragma mark - 订阅管理
@property (nonatomic, strong) NSMutableArray<id<QCloudSMHTaskEventSubscriber>> *subscribers;

// 用户主动订阅的Task
@property (nonatomic, strong) NSMutableSet<QCloudSMHBaseTask *> *subscribedQueueSet;                // 用户主动订阅的任务对象集合

@end

@implementation QCloudSMHTaskManager

#pragma mark - 单例模式

static QCloudSMHTaskManager *sharedInstance = nil;
static dispatch_once_t onceToken;

/**
 * 获取任务管理器单例
 * 使用 dispatch_once 保证线程安全的单例创建
 */
+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * 重置单例（仅用于测试）
 * 释放当前单例实例，下次调用 sharedManager 时会创建新实例
 */
+ (void)resetSharedManager {
    @synchronized (self) {
        if (sharedInstance) {
            // 取消所有任务
            for (QCloudSMHBaseTask *task in sharedInstance.folderTaskCache.allValues) {
                if (![QCloudSMHBaseTask isTerminalState:task.state]) {
                    [task cancel];
                }
            }
            for (QCloudSMHBaseTask *task in sharedInstance.fileTaskCache.allValues) {
                if (![QCloudSMHBaseTask isTerminalState:task.state]) {
                    [task cancel];
                }
            }
        }
        sharedInstance = nil;
        onceToken = 0;
        NSLog(@"✅ QCloudSMHTaskManager 单例已重置");
    }
}

/**
 * 初始化任务管理器
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

/**
 * 设置默认值
 * 初始化所有内部属性和数据结构
 */
- (void)setupDefaultValues {
    // 创建递归锁用于保护任务缓存和订阅者列表
    _taskLock = [[NSRecursiveLock alloc] init];
    _subscriberLock = [[NSRecursiveLock alloc] init];
    
    // 初始化双缓存池
    _folderTaskCache = [NSMutableDictionary dictionary];   // 文件夹任务缓存池
    _fileTaskCache = [NSMutableDictionary dictionary];     // 文件任务缓存池
    
    // 初始化双等待队列（当缓存满时，新任务加入对应队列）
    _fileWaitingQueue = [NSMutableArray array];            // 文件任务等待队列
    _folderWaitingQueue = [[QCloudSMHPriorityQueue alloc] init];  // 文件夹任务优先级队列
    
    // 初始化用户主动订阅队列
    _subscribedQueueSet = [NSMutableSet set];
    
    // 初始化数据库管理器和配置
    _databaseManager = [QCloudSMHTaskDatabaseManager sharedManager];
    _config = [[QCloudSMHTaskManagerConfig alloc] init];
    
    // 初始化事件订阅者列表
    _subscribers = [NSMutableArray array];
}

#pragma mark - 任务创建

/**
 * 根据下载请求创建任务
 * 根据请求类型创建对应的文件或文件夹任务
 */
- (QCloudSMHBaseTask *)createTaskWithRequest:(QCloudSMHDownloadRequest *)request {
    QCloudSMHBaseTask *task = nil;
    if (request.type == QCloudSMHTaskTypeFolder) {
        // 创建文件夹任务
        task = [self createFolderTaskWithLibraryId:request.libraryId
                                                         spaceId:request.spaceId
                                                          userId:request.userId
                                                remoteFolderPath:request.path
                                                  localFolderURL:request.localURL
                                                conflictStrategy:request.conflictStrategy
                                            enableResumeDownload:request.enableResumeDownload
                                         enableCRC64Verification:request.enableCRC64Verification];
    } else if (request.type == QCloudSMHTaskTypeFile) {
        // 创建文件任务
        task = [self createFileTaskWithLibraryId:request.libraryId
                                                        spaceId:request.spaceId
                                                         userId:request.userId
                                                     remotePath:request.path
                                                       localURL:request.localURL
                                                       fileName:request.path.lastPathComponent
                                                       fileSize:0
                                               conflictStrategy:request.conflictStrategy
                                           enableResumeDownload:request.enableResumeDownload
                                        enableCRC64Verification:request.enableCRC64Verification];
        
    }
    return task;
}

/**
 * 创建文件夹下载任务
 */
- (QCloudSMHFolderTask *)createFolderTaskWithLibraryId:(NSString *)libraryId
                                               spaceId:(NSString *)spaceId
                                                userId:(NSString *)userId
                                      remoteFolderPath:(NSString *)remoteFolderPath
                                        localFolderURL:(NSURL *)localFolderURL
                                      conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy
                                   enableResumeDownload:(BOOL)enableResumeDownload
                                enableCRC64Verification:(BOOL)enableCRC64Verification {
    QCloudSMHFolderTask *task = [[QCloudSMHFolderTask alloc] initWithLibraryId:libraryId
                                                                       spaceId:spaceId
                                                                        userId:userId
                                                                    remotePath:remoteFolderPath
                                                                      localURL:localFolderURL
                                                          enableResumeDownload:enableResumeDownload
                                                       enableCRC64Verification:enableCRC64Verification
                                                              conflictStrategy:conflictStrategy];
    return task;
}

/**
 * 创建文件下载任务
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
                           enableCRC64Verification:(BOOL)enableCRC64Verification {
    QCloudSMHFileTask *task = [[QCloudSMHFileTask alloc] initWithLibraryId:libraryId
                                                                   spaceId:spaceId
                                                                    userId:userId
                                                                remotePath:remotePath
                                                              localFileURL:localURL
                                                                  fileSize:fileSize
                                                                  fileName:fileName
                                                      enableResumeDownload:enableResumeDownload
                                                   enableCRC64Verification:enableCRC64Verification
                                                          conflictStrategy:conflictStrategy];
    return task;
}

/**
 * 从数据库记录创建任务实例
 */
- (QCloudSMHBaseTask *)createTaskFromRecord:(QCloudSMHTaskRecord *)record {
    if (!record) {
        return nil;
    }
    
    QCloudSMHBaseTask *task = nil;
    
    if (record.taskType == QCloudSMHTaskTypeFolder) {
        QCloudSMHFolderTask *folderTask = [[QCloudSMHFolderTask alloc] initWithLibraryId:record.libraryId
                                                                                 spaceId:record.spaceId
                                                                                  userId:record.userId
                                                                              remotePath:record.remotePath
                                                                                localURL:[NSURL fileURLWithPath:record.localPath] enableResumeDownload:record.enableResumeDownload enableCRC64Verification:record.enableCRC64Verification conflictStrategy:record.conflictStrategy];
        
        folderTask.scanCompleted = record.scanCompleted;
        folderTask.nextMarker = record.nextMarker;
        folderTask.enableResume = record.enableResume;
        task = folderTask;
    } else if (record.taskType == QCloudSMHTaskTypeFile) {
        QCloudSMHFileTask *fileTask = [[QCloudSMHFileTask alloc] initWithLibraryId:record.libraryId
                                                                           spaceId:record.spaceId
                                                                            userId:record.userId
                                                                        remotePath:record.remotePath
                                                                      localFileURL:[NSURL fileURLWithPath:record.localPath]
                                                                          fileSize:record.totalBytes
                                                                          fileName:record.fileName
                                                              enableResumeDownload:record.enableResumeDownload
                                                           enableCRC64Verification:record.enableCRC64Verification
                                                                  conflictStrategy:record.conflictStrategy];
        
        fileTask.fileName = record.fileName;
        task = fileTask;
    } else {
        // 无效的任务类型
        QCloudLogError(@"无效的任务类型: %ld，任务ID: %@", (long)record.taskType, record.remotePath);
        return nil;
    }
    
    return task;
}


/**
 * 通知任务已创建（发送初始进度）
 */
- (void)notifyTaskCreated:(QCloudSMHBaseTask *)task {
    if (!task || task.taskType == QCloudSMHTaskTypeFolder) {
        return;
    }
    [self postStateChanedNotificationForTaskId:task.taskId
                                          path:task.remotePath
                                         state:task.state
                                      oldState:task.state
                                         error:nil
                                      taskType:task.taskType];
    
    [self postProgressNotificationForTaskId:task.taskId
                                       path:task.remotePath
                              bytesProcessed:task.bytesProcessed
                                 totalBytes:task.totalBytes
                             completedFiles:task.filesProcessed
                                 totalFiles:task.totalFiles
                                   taskType:task.taskType];
}


#pragma mark - 缓存池管理

/**
 * 添加任务到对应的缓存池（双缓存池）
 */
- (void)addTaskToCache:(QCloudSMHBaseTask *)task {
    if (!task || !task.taskId) {
        return;
    }
    
    if (task.taskType == QCloudSMHTaskTypeFile) {
        [self addFileTaskToCache:task];
    } else if (task.taskType == QCloudSMHTaskTypeFolder) {
        [self addFolderTaskToCache:task];
    }
}

/**
 * 添加文件任务到缓存池
 */
- (void)addFileTaskToCache:(QCloudSMHBaseTask *)task {
    [_taskLock lock];
    
    if (self.fileTaskCache[task.taskId] || [self.fileWaitingQueue containsObject:task.taskId]) {
        [_taskLock unlock];
        QCloudLogWarning(@"文件任务 %@ 已存在于缓存或等待队列中，忽略重复添加", task.remotePath);
        return;
    }
    
    BOOL isCacheFull = self.fileTaskCache.count >= self.config.maxFileCacheSize;
    
    if (isCacheFull) {
        [self.fileWaitingQueue addObject:task.taskId];
        [_taskLock unlock];
        QCloudLogDebug(@"文件任务 %@ 已加入文件等待队列（文件缓存池已满：%ld/%ld）等待队列长度：%ld",
              task.remotePath, (long)self.fileTaskCache.count, (long)self.config.maxFileCacheSize, self.fileWaitingQueue.count);
        return;
    }
    
    self.fileTaskCache[task.taskId] = task;
    NSUInteger cacheCount = self.fileTaskCache.count;
    [_taskLock unlock];
    
    QCloudLogDebug(@"文件任务 %@ 已添加到文件缓存池（%ld/%ld）",
          task.remotePath, (long)cacheCount, (long)self.config.maxFileCacheSize);
    
    [self startAndObserveTask:task];
}

/**
 * 添加文件夹任务到缓存池
 */
- (void)addFolderTaskToCache:(QCloudSMHBaseTask *)task {
    [_taskLock lock];
    
    if (self.folderTaskCache[task.taskId] || [self.folderWaitingQueue containsTaskId:task.taskId]) {
        [_taskLock unlock];
        QCloudLogWarning(@"文件夹任务 %@ 已存在于缓存或等待队列中，忽略重复添加", task.remotePath);
        return;
    }
    
    BOOL isCacheFull = self.folderTaskCache.count >= self.config.maxFolderCacheSize;
    
    if (isCacheFull) {
        NSString *ancestorTaskIdToEvict = [self findAncestorTaskInCache:task];
        
        if (ancestorTaskIdToEvict) {
            QCloudSMHBaseTask *ancestorTask = self.folderTaskCache[ancestorTaskIdToEvict];
            QCloudLogDebug(@"文件夹缓存池已满，将祖先任务 %@ 迁移到文件夹等待队列",
                         ancestorTask.remotePath);
            
            [self moveTaskToWaitingQueueLocked:(QCloudSMHFolderTask *)ancestorTask];
            [_taskLock unlock];
            
            [self addFolderTaskToCache:task];
        } else {
            [self moveTaskToWaitingQueueLocked:(QCloudSMHFolderTask *)task];
            [_taskLock unlock];
        }
        return;
    }
    
    self.folderTaskCache[task.taskId] = task;
    NSUInteger cacheCount = self.folderTaskCache.count;
    [_taskLock unlock];
    
    QCloudLogDebug(@"文件夹任务 %@ 已添加到文件夹缓存池（%ld/%ld）",
          task.remotePath, (long)cacheCount, (long)self.config.maxFolderCacheSize);
    
    [self startAndObserveTask:task];
}

/**
 * 从等待队列中移除任务（从两个等待队列中移除）
 */
- (void)removeTaskFromWaitingQueue:(NSString *)taskId {
    [_taskLock lock];
    [self.fileWaitingQueue removeObject:taskId];
    [self.folderWaitingQueue removeTaskId:taskId];
    [_taskLock unlock];
}

/**
 * 将文件夹任务移动到优先级等待队列中
 *
 * @param task 文件夹任务对象
 */
- (void)moveTaskToWaitingQueueLocked:(QCloudSMHFolderTask *)task {
    // 计算优先级
    NSInteger priority = [self calculatePriorityForFolderTask:task];
    
    // 添加到优先级等待队列
    [self.folderWaitingQueue addTaskId:task.taskId withPriority:priority];
    
    if ([self getTaskById:task.taskId]) {
        task.enableStart = NO;
        
        // 检查是否需要取消订阅事件
        if (![self getTaskFromSubscribedQueueLocked:task.taskId]) {
            [task unsubscribeFromSubTaskNotifications];
        }
        
        // 从缓存池移除
        [self removeTaskFromCache:task.taskId];
    }
    
    QCloudLogDebug(@"文件夹任务 %@ 已添加到优先级等待队列（优先级：%ld）",
                 task.remotePath, (long)priority);
}

/**
 * 在缓存池中查找新任务的祖先任务
 * 从新任务的父路径开始，逐级查找，直到找到在缓存中的祖先任务
 *
 * @param newTask 新任务对象
 * @return 找到的祖先任务ID，如果不存在则返回nil
 *
 */
- (NSString *)findAncestorTaskInCache:(QCloudSMHBaseTask *)newTask {
    if (!newTask) {
        return nil;
    }
    
    NSString *currentPath = newTask.remotePath;
    
    // 逐级向上查找祖先目录
    while (currentPath && currentPath.length > 0) {
        currentPath = [currentPath stringByDeletingLastPathComponent];
        
        // 空路径表示已到达根目录
        if (!currentPath || currentPath.length == 0) {
            break;
        }
        
        // 在缓存中查找是否存在这个祖先目录对应的任务
        for (NSString *cachedTaskId in self.folderTaskCache.allKeys) {
            QCloudSMHBaseTask *cachedTask = self.folderTaskCache[cachedTaskId];
            if (cachedTask.state == QCloudSMHTaskStateScanning ||
                cachedTask.state == QCloudSMHTaskStateIdle) {
                continue;
            }
            if ([cachedTask.remotePath isEqualToString:currentPath]) {
                // 检查是否属于同一个库、空间、用户
                if ([cachedTask.libraryId isEqualToString:newTask.libraryId] &&
                    [cachedTask.spaceId isEqualToString:newTask.spaceId] &&
                    [cachedTask.userId isEqualToString:newTask.userId]) {
                    return cachedTaskId;
                }
            }
        }
    }
    
    return nil;
}

/**
 * 判断是否存在待处理/正在处理的任务
 */
- (BOOL)containNeedHandleTask:(NSString *)taskId {
    if (!taskId) {
        return NO;
    }
   
    [_taskLock lock];
    // 1. 快速检查缓存池中的任务
    NSArray *allCachedTaskIds = [self.folderTaskCache.allKeys arrayByAddingObjectsFromArray:self.fileTaskCache.allKeys];
    // 2. 复制两个等待队列进行查询（减少锁持有时间）
    NSArray *fileWaitingTaskIds = [self.fileWaitingQueue copy];
    BOOL existsInFolderWaitingQueue = [self.folderWaitingQueue containsTaskId:taskId];
    [_taskLock unlock];
    
    if ([allCachedTaskIds containsObject:taskId]) {
        return YES;
    }
    if ([fileWaitingTaskIds containsObject:taskId]) {
        return YES;
    }
    if (existsInFolderWaitingQueue) {
        return YES;
    }
    return NO;
}

/**
 * 从对应的缓存池中移除任务
 */
- (void)removeTaskFromCache:(NSString *)taskId {
    if (!taskId) {
        return;
    }
    
    [_taskLock lock];
    
    QCloudSMHBaseTask *task = self.fileTaskCache[taskId];
    if (task) {
        [self.fileTaskCache removeObjectForKey:taskId];
        NSUInteger remainingCount = self.fileTaskCache.count;
        [_taskLock unlock];
        QCloudLogDebug(@"%@ 已从文件缓存池中移除（%ld/%ld）",
              task.remotePath, (long)remainingCount, (long)self.config.maxFileCacheSize);
        
        return;
    }
    
    task = self.folderTaskCache[taskId];
    if (task) {
        [self.folderTaskCache removeObjectForKey:taskId];
        NSUInteger remainingCount = self.folderTaskCache.count;
        [_taskLock unlock];
        QCloudLogDebug(@"%@ 已从文件夹缓存池中移除（%ld/%ld）",
              task.remotePath, (long)remainingCount, (long)self.config.maxFolderCacheSize);
        return;
    }
    
    [_taskLock unlock];
}

/**
 * 任务调度
 */
- (void)scheduleTaskFromWaitingQueue {
    [self scheduleFolderTasksFromWaitingQueue];
    [self scheduleFileTasksFromWaitingQueue];
}

/**
 * 从文件等待队列中调度任务
 */
- (void)scheduleFileTasksFromWaitingQueue {
    [self scheduleTasksFromWaitingQueueWithCacheDict:self.fileTaskCache
                                          waitQueue:self.fileWaitingQueue
                                         maxCacheSize:self.config.maxFileCacheSize];
}

/**
 * 从文件夹等待队列中调度任务
 */
- (void)scheduleFolderTasksFromWaitingQueue {
    [self scheduleTasksFromWaitingQueueWithCacheDict:self.folderTaskCache
                                          waitQueue:self.folderWaitingQueue
                                         maxCacheSize:self.config.maxFolderCacheSize];
}

/**
 * 从等待队列调度任务到缓存池（通用方法）
 */
- (void)scheduleTasksFromWaitingQueueWithCacheDict:(NSMutableDictionary *)cacheDict
                                        waitQueue:(id)waitQueue
                                       maxCacheSize:(NSInteger)maxCacheSize {
    
    [_taskLock lock];
    // 判断等待队列类型，获取队列大小
    NSInteger queueCount = 0;
    if ([waitQueue isKindOfClass:[NSMutableArray class]]) {
        queueCount = ((NSMutableArray *)waitQueue).count;
    } else if ([waitQueue isKindOfClass:[QCloudSMHPriorityQueue class]]) {
        queueCount = ((QCloudSMHPriorityQueue *)waitQueue).count;
    }
    NSInteger maxIterations = queueCount + 5;
    [_taskLock unlock];
    
    for (NSInteger i = 0; i < maxIterations; i++) {
        [_taskLock lock];
        
        // 检查缓存是否已满
        if (cacheDict.count >= maxCacheSize) {
            [_taskLock unlock];
            break;
        }
        
        NSString *taskId = nil;
        BOOL isFileQueue = [waitQueue isKindOfClass:[NSMutableArray class]];
        
        if (isFileQueue) {
            NSMutableArray *fileQueue = (NSMutableArray *)waitQueue;
            if (fileQueue.count > 0) {
                taskId = fileQueue.firstObject;
                [fileQueue removeObjectAtIndex:0];
            }
        } else {
            QCloudSMHPriorityQueue *folderQueue = (QCloudSMHPriorityQueue *)waitQueue;
            taskId = [folderQueue poll];  // 从优先级队列中取出优先级最高的任务
        }
        
        if (!taskId || taskId.length == 0) {
            [_taskLock unlock];
            break;
        }
        
        [_taskLock unlock];
        
        QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
        QCloudLogDebug(@"%@ 任务移除等待队列", task.remotePath);
        if (!task) continue;
        
        [self addTaskToCache:task];
    }
}

#pragma mark - 任务启动与监听

/**
 * 启动任务并监听其状态和进度变化
 */
- (void)startAndObserveTask:(QCloudSMHBaseTask *)task {
    __weak typeof(self) weakSelf = self;
    __weak typeof(task) weakTask = task;
    
    // 监听任务状态变化
    task.stateChangeCallback = ^(NSString *taskId, QCloudSMHTaskState state, QCloudSMHTaskState oldState, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakTask) strongTask = weakTask;
        if (!strongSelf || !strongTask) return;
        
        // 文件夹任务扫描完成，转入下载阶段：从缓存池移除，加入等待队列
        if (strongTask.taskType == QCloudSMHTaskTypeFolder &&
            state == QCloudSMHTaskStateDownloading) {
            
            // 添加到优先级等待队列
            [strongSelf->_taskLock lock];
            [strongSelf moveTaskToWaitingQueueLocked:(QCloudSMHFolderTask *)strongTask];
            [strongSelf->_taskLock unlock];
            
            // 触发调度，从等待队列拉取新任务到缓存
            [strongSelf scheduleFolderTasksFromWaitingQueue];
        }
        
        // 发送状态变更通知
        [strongSelf postStateChanedNotificationForTaskId:taskId
                                                    path:strongTask.remotePath
                                                   state:state
                                                oldState:oldState
                                                   error:error
                                                taskType:strongTask.taskType];
        // 如果任务进入终止状态，从缓存池中移除
        if ([QCloudSMHBaseTask isInactiveState:state]) {
            [strongSelf removeTaskFromWaitingQueue:taskId];
            [strongSelf removeTaskFromCache:taskId];
            QCloudLogDebug(@"任务 %@ 已终止，状态: %ld", strongTask.remotePath, (long)state);
            // 任务调度
            [strongSelf scheduleTaskFromWaitingQueue];
        }
    };
    
    // 监听任务进度更新
    task.progressCallback = ^(NSString * _Nonnull taskId, int64_t bytesProcessed, int64_t totalBytes, int completedFiles, int totalFiles) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakTask) strongTask = weakTask;
        if (!strongSelf || !strongTask) return;
        
        // 发送进度更新通知
        [strongSelf postProgressNotificationForTaskId:taskId
                                                 path:strongTask.remotePath
                                        bytesProcessed:bytesProcessed
                                           totalBytes:totalBytes
                                       completedFiles:completedFiles
                                           totalFiles:totalFiles
                                             taskType:strongTask.taskType];
    };
    
    [task start];
}



#pragma mark - 任务查询

/**
 * 从缓存池中获取任务（双缓存池版本）
 * 先从文件缓存池查找，再从文件夹缓存池查找
 */
- (QCloudSMHBaseTask *_Nullable)getTaskById:(NSString *)taskId {
    if (!taskId) {
        return nil;
    }
    
    [_taskLock lock];
    QCloudSMHBaseTask *task = self.fileTaskCache[taskId];
    if (!task) {
        task = self.folderTaskCache[taskId];
    }
    [_taskLock unlock];
    
    return task;
}

/**
 * 获取任务，如果缓存中不存在则从数据库加载
 */
- (QCloudSMHBaseTask *_Nullable)getOrLoadTaskById:(NSString *)taskId {
    // 缓存
    QCloudSMHBaseTask *task = [self getTaskById:taskId];
    // 订阅队列
    if (!task) {
        task = [self getTaskFromSubscribedQueue:taskId];
    }
    // 数据库
    if (!task) {
        QCloudSMHTaskRecord *record = [self.databaseManager getTaskById:taskId];
        task = [self createTaskFromRecord:record];
    }
    return task;
}

#pragma mark - 任务控制
- (void)startTask:(QCloudSMHBaseTask *)task {
    BOOL resumed = NO;
    QCloudSMHTaskState oldState = task.state;
    if (task.taskType == QCloudSMHTaskTypeFolder) {
        resumed = ((QCloudSMHFolderTask *)task).enableResume;
        if (!resumed && task.state == QCloudSMHTaskStatePaused) {
            return;
        }
    }
    if (![self.databaseManager isTaskExistsById:task.taskId]) {
        // 保存任务到数据库
        [QCloudSMHTaskDatabaseManager.sharedManager saveTask:task];
    }
    
    if ([QCloudSMHBaseTask isTerminalState:task.state]) {
        [task resetTask];
    } else if (task.state != QCloudSMHTaskStateIdle) {
        [task resetState];
    }
    
    if (oldState != task.state) {
        [self postStateChanedNotificationForTaskId:task.taskId
                                              path:task.remotePath
                                             state:task.state
                                          oldState:oldState
                                             error:nil
                                          taskType:task.taskType];
    }
    
    // 在缓存中，则不用重复添加
    if ([self containNeedHandleTask:task.taskId]) {
        QCloudLogDebug(@"任务 %@ 已在缓存中，无需重复添加", task.remotePath);
        return;
    }
    
    [self addTaskToCache:task];
}

- (void)startTaskById:(NSString *)taskId {
    QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
    [self startTask:task];
}

- (void)resumeTaskById:(NSString *)taskId {
    QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
    if (!task || task.state != QCloudSMHTaskStatePaused) {
        return;
    }
    if (task.taskType == QCloudSMHTaskTypeFolder) {
        QCloudSMHFolderTask *folderTask = (QCloudSMHFolderTask *)task;
        folderTask.enableResume = YES;
        [folderTask restoreAggregatedStateFromDatabase];
    }
    
    [self startTask:task];
}


- (void)pauseTaskById:(NSString *)taskId {
    QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
    if (!task || task.state == QCloudSMHTaskStatePaused) {
        return;
    }
    [self removeTaskFromWaitingQueue:taskId];
    
    [task pause];
    
    NSInteger count = task.taskType == QCloudSMHTaskTypeFile ? self.fileTaskCache.count : self.folderTaskCache.count;
    
    QCloudLogDebug(@"暂停任务 %@，已从缓存池中移除，当前活跃任务数: %ld", task.remotePath, count);
}

- (void)cancelTaskById:(NSString *)taskId {
    QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
    if (!task || [QCloudSMHBaseTask isTerminalState:task.state]) {
        return;
    }
    [self removeTaskFromWaitingQueue:taskId];
    
    [task cancel];
    
    NSInteger count = task.taskType == QCloudSMHTaskTypeFile ? self.fileTaskCache.count : self.folderTaskCache.count;
    
    QCloudLogDebug(@"取消任务 %@，已从缓存池中移除，当前活跃任务数: %ld", task.remotePath, count);
}

- (void)deleteTaskById:(NSString *)taskId {
    QCloudSMHBaseTask *task = [self getOrLoadTaskById:taskId];
    if (!task) {
        return;
    }
    
    // 构建统计信息 (用于 FolderTask 扣减进度)
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    stats[@"bytesProcessed"] = @(task.bytesProcessed);
    stats[@"totalBytes"] = @(task.totalBytes);
    stats[@"filesProcessed"] = @(task.filesProcessed);
    stats[@"totalFiles"] = @(task.totalFiles);
    stats[@"taskState"] = @(task.state);
    
    [self removeTaskFromWaitingQueue:taskId];
    [self removeTaskFromCache:taskId];
    
    //  调度新的任务
    [self scheduleTaskFromWaitingQueue];
    
    // 传递统计信息
    [self postDeleteNotificationForTaskId:taskId path:task.remotePath taskType:task.taskType statistics:stats];
    
    [task delete];
    
    NSInteger count = task.taskType == QCloudSMHTaskTypeFile ? self.fileTaskCache.count : self.folderTaskCache.count;
    QCloudLogDebug(@"删除任务 %@，已从缓存池中移除，当前活跃任务数: %ld", task.remotePath, count);
}

#pragma mark - 数据库操作

/**
 * 保存任务状态到数据库
 */
- (void)saveTaskStateToDatabase:(QCloudSMHBaseTask *)task {
    [self.databaseManager updateTask:task];
}

#pragma mark - 事件分发

/**
 * 获取订阅者列表副本（线程安全）
 */
- (NSArray<id<QCloudSMHTaskEventSubscriber>> *)getSubscribersCopy {
    [_subscriberLock lock];
    NSArray<id<QCloudSMHTaskEventSubscriber>> *subscribersCopy = [self.subscribers copy];
    [_subscriberLock unlock];
    return subscribersCopy;
}

/**
 * 分发进度更新事件给所有订阅者
 */
- (void)postProgressNotificationForTaskId:(NSString *)taskId
                                     path:(NSString *)path
                            bytesProcessed:(int64_t)bytesProcessed
                               totalBytes:(int64_t)totalBytes
                           completedFiles:(int)completedFiles
                               totalFiles:(int)totalFiles
                                 taskType:(QCloudSMHTaskType)taskType {
    NSArray<id<QCloudSMHTaskEventSubscriber>> *subscribersCopy = [self getSubscribersCopy];
    
    for (id<QCloudSMHTaskEventSubscriber> subscriber in subscribersCopy) {
        if ([subscriber respondsToSelector:@selector(onTaskProgressUpdated:path:bytesProcessed:totalBytes:completedFiles:totalFiles:taskType:)]) {
            [subscriber onTaskProgressUpdated:taskId
                                         path:path
                               bytesProcessed:bytesProcessed
                                   totalBytes:totalBytes
                               completedFiles:completedFiles
                                   totalFiles:totalFiles
                                     taskType:taskType];
        }
    }
}

/**
 * 分发状态变更事件给所有订阅者
 */
- (void)postStateChanedNotificationForTaskId:(NSString *)taskId
                                        path:(NSString *)path
                                    state:(QCloudSMHTaskState)state
                                 oldState:(QCloudSMHTaskState)oldState
                                     error:(NSError *_Nullable)error
                                  taskType:(QCloudSMHTaskType)taskType {
    NSArray<id<QCloudSMHTaskEventSubscriber>> *subscribersCopy = [self getSubscribersCopy];
    
    for (id<QCloudSMHTaskEventSubscriber> subscriber in subscribersCopy) {
        if ([subscriber respondsToSelector:@selector(onTaskStateChanged:path:state:oldState:error:taskType:)]) {
            [subscriber onTaskStateChanged:taskId path:path state:state oldState:oldState error:error taskType:taskType];
        }
    }
}

/**
 * 分发删除事件给所有订阅者
 */
- (void)postDeleteNotificationForTaskId:(NSString *)taskId path:(NSString *)path taskType:(QCloudSMHTaskType)taskType statistics:(NSDictionary *)statistics {
    NSArray<id<QCloudSMHTaskEventSubscriber>> *subscribersCopy = [self getSubscribersCopy];
    
    for (id<QCloudSMHTaskEventSubscriber> subscriber in subscribersCopy) {
        if ([subscriber respondsToSelector:@selector(onTaskDeleted:path:taskType:error:statistics:)]) {
            [subscriber onTaskDeleted:taskId path:path taskType:taskType error:nil statistics:statistics];
        }
    }
}

#pragma mark - 订阅管理

- (void)subscribeTaskEvents:(id<QCloudSMHTaskEventSubscriber>)subscriber {
    if (!subscriber) {
        return;
    }
    
    [_subscriberLock lock];
    if (![self.subscribers containsObject:subscriber]) {
        [self.subscribers addObject:subscriber];
    }
    NSUInteger count = self.subscribers.count;
    [_subscriberLock unlock];
    
    QCloudLogDebug(@"订阅者已注册，当前订阅者数: %ld", (long)count);
}

- (void)unsubscribeTaskEvents:(id<QCloudSMHTaskEventSubscriber>)subscriber {
    if (!subscriber) {
        return;
    }
    
    [_subscriberLock lock];
    [self.subscribers removeObject:subscriber];
    NSUInteger count = self.subscribers.count;
    [_subscriberLock unlock];
    
    QCloudLogDebug(@"订阅者已注销，当前订阅者数: %ld", (long)count);
}

/**
 * 添加任务到用户主动订阅队列
 * @param task 任务对象
 * @param error 错误信息输出参数
 *
 * @return 是否成功添加到队列
 */
- (BOOL)addTaskToSubscribedQueue:(QCloudSMHBaseTask *)task error:(NSError * _Nullable * _Nullable)error {
    if (!task) {
        *error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain code:QCloudSMHTaskErrorInternalError userInfo:@{NSLocalizedDescriptionKey: @"任务对象为空"}];
        return NO;
    }
    
    [_taskLock lock];
    
    // 检查是否已在队列中（使用内部方法，避免重复加锁）
    QCloudSMHBaseTask *existingTask = [self getTaskFromSubscribedQueueLocked:task.taskId];
    
    if (existingTask) {
        [_taskLock unlock];
        QCloudLogDebug(@"任务 %@ 已在用户订阅队列中，无需重复添加", task.remotePath);
        return YES;
    }
    
    // 添加任务对象到队列
    [self.subscribedQueueSet addObject:task];
    NSInteger count = self.subscribedQueueSet.count;
    [_taskLock unlock];
    
    QCloudLogDebug(@"任务 %@ 已添加到用户订阅队列（当前任务数：%ld）",
                  task.remotePath, (long)count);
    
    return YES;
}

/**
 * 从用户订阅队列中移除任务
 */
- (void)removeTaskIdFromSubscribedQueue:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return;
    }
    
    [_taskLock lock];
    
    // 查找与该taskId匹配的任务对象
    QCloudSMHBaseTask *taskToRemove = [self getTaskFromSubscribedQueueLocked:taskId];
    
    if (taskToRemove) {
        if (taskToRemove.taskType == QCloudSMHTaskTypeFolder) {
            [self unsubscribeTaskEvents:(QCloudSMHFolderTask *)taskToRemove];
        }
        NSInteger count = self.subscribedQueueSet.count;
        [_taskLock unlock];
        
        QCloudLogDebug(@"任务 %@ 已从用户订阅队列中移除（剩余：%ld）", taskToRemove.remotePath, (long)count);
    } else {
        [_taskLock unlock];
    }
}

/**
 * 从用户订阅队列中获取任务
 */
- (nullable QCloudSMHBaseTask *)getTaskFromSubscribedQueue:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return nil;
    }
    
    [_taskLock lock];
    
    QCloudSMHBaseTask *foundTask = [self getTaskFromSubscribedQueueLocked:taskId];
    
    [_taskLock unlock];
    
    return foundTask;
}

/**
 * 内部私有方法：从订阅队列中获取任务（假设已持有_taskLock）
 * 用于避免在已持有锁的场景下重复加锁
 */
- (nullable QCloudSMHBaseTask *)getTaskFromSubscribedQueueLocked:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return nil;
    }
    
    QCloudSMHBaseTask *foundTask = nil;
    for (QCloudSMHBaseTask *task in self.subscribedQueueSet) {
        if ([task.taskId isEqualToString:taskId]) {
            foundTask = task;
            break;
        }
    }
    
    return foundTask;
}


#pragma mark - 优先级计算

/**
 * 计算文件夹任务的优先级
 *
 * @param task 文件夹任务对象
 * @return 计算得出的优先级
 */
- (NSInteger)calculatePriorityForFolderTask:(QCloudSMHBaseTask *)task {
    switch (task.state) {
        case QCloudSMHTaskStateIdle:
            return 10;
        default:
            return 5;
    }
}

#pragma mark - 配置管理

- (void)updateConfig:(QCloudSMHTaskManagerConfig *)config {
    if (!config) {
        return;
    }
    
    _config = config;
}


@end
