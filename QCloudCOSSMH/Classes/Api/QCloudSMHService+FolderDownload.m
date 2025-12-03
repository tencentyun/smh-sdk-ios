//
//  QCloudSMHService+FolderDownload.m
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/13.
//

#import "QCloudSMHService+FolderDownload.h"
#import "QCloudSMHTaskManager.h"
#import "QCloudSMHTaskDatabaseManager.h"
#import "QCloudSMHTaskIDGenerator.h"
#import "QCloudSMHFolderTask.h"

#import <objc/runtime.h>

@interface QCloudSMHService ()<QCloudSMHTaskEventSubscriber> {
    NSRecursiveLock *_callbackLock;
}

/// 任务进度监听列表
@property (nonatomic, strong) NSMutableDictionary<NSString *,  QCloudSMHFolderProgressCallback> *progressCallbackList;

/// 任务完成回调列表
@property (nonatomic, strong) NSMutableDictionary<NSString *,  QCloudSMHFolderStateChangedCallback> *stateChangedCallbackList;

@end

@implementation QCloudSMHService (FolderDownload)

#pragma mark - 初始化

/**
 * 初始化文件夹/文件下载模块
 * 订阅任务管理器的事件，以便接收任务进度和状态变化通知
 */
- (void)setupDownload {
    [[QCloudSMHTaskManager sharedManager] subscribeTaskEvents:self];
}

/**
 * 解除初始化
 * 取消订阅任务管理器的事件
 */
- (void)teardownDownload {
    [[QCloudSMHTaskManager sharedManager] unsubscribeTaskEvents:self];
}

/**
 * 更新文件夹下载配置
 * 动态调整下载任务的并发数、超时时间等参数
 */
- (void)updateDownloadFolerConfig:(QCloudSMHTaskManagerConfig *)config {
    [QCloudSMHTaskManager.sharedManager updateConfig:config];
}

/**
 * 启动文件夹/文件下载任务
 * 流程：创建任务 -> 保存到数据库 -> 加入缓存 -> 启动下载
 */
- (void)downloadFolder:(QCloudSMHDownloadRequest *)request {
    // 根据请求创建对应的任务对象（文件任务或文件夹任务）
    QCloudSMHBaseTask *task = [QCloudSMHTaskManager.sharedManager getTaskFromSubscribedQueue:request.requestId];
    if (!task) {
        task = [QCloudSMHTaskManager.sharedManager createTaskWithRequest:request];
    } else {
        task.enableResumeDownload = request.enableResumeDownload;
        task.enableCRC64Verification = request.enableCRC64Verification;
        task.conflictStrategy = request.conflictStrategy;
    }
    // 启动任务的下载流程
    [QCloudSMHTaskManager.sharedManager startTask:task];
}

/**
 * 查询单个文件夹/文件的下载记录
 * 根据库ID、空间ID、用户ID、远程路径和本地路径从数据库查询对应的任务
 */
- (QCloudSMHDownloadDetail *)getFolderDownloadDetail:(QCloudSMHDownloadRequest *)request {
    // 从数据库查询匹配的任务记录
    QCloudSMHTaskRecord *record = [QCloudSMHTaskDatabaseManager.sharedManager queryTaskRecordWithLibraryId:request.libraryId
                                                                                                   spaceId:request.spaceId
                                                                                                    userId:request.userId
                                                                                                remotePath:request.path
                                                                                                 localPath:request.localURL.path];
    // 将数据库记录转换为下载详情对象
    return [[QCloudSMHDownloadDetail alloc] initWithTaskRecord:record];
}

/**
 * 分页查询文件夹目录下的所有下载记录
 * 支持多条件筛选、排序和分组，用于展示下载列表
 */
- (NSArray<QCloudSMHDownloadDetail *> *)getFolderDownloadDetails:(QCloudSMHDownloadRequest *)request
                                                        page:(nullable NSNumber *)page
                                                    pageSize:(nullable NSNumber *)pageSize
                                                   orderType:(QCloudSMHSortField)orderType
                                              orderDirection:(QCloudSMHSortOrder)orderDirection
                                                    grouping:(QCloudSMHGroup)group
                                              directoryFilter:(QCloudSMHDirectoryFilter)directoryFilter
                                                      states:(nullable NSArray<NSNumber *> *)states {
    // 从数据库查询符合条件的任务记录列表
    NSArray<QCloudSMHTaskRecord *> *records = [QCloudSMHTaskDatabaseManager.sharedManager queryTaskRecordsWithLibraryId:request.libraryId
                                                                                                              spaceId:request.spaceId
                                                                                                               userId:request.userId
                                                                                                     parentRemotePath:request.path
                                                                                                            localPath:request.localURL.path
                                                                                                                 page:page
                                                                                                             pageSize:pageSize
                                                                                                            orderType:orderType
                                                                                                       orderDirection:orderDirection
                                                                                                             group:group
                                                                                                      directoryFilter:directoryFilter
                                                                                                                states:states];
    // 将数据库记录转换为下载详情对象数组
    NSMutableArray<QCloudSMHDownloadDetail *> *details = [NSMutableArray array];
    for (QCloudSMHTaskRecord *record in records) {
        QCloudSMHDownloadDetail *detail = [[QCloudSMHDownloadDetail alloc] initWithTaskRecord:record];
        [details addObject:detail];
    }
    return details;
}

/**
 * 监听文件夹/文件下载的进度和状态变化
 * 将回调块存储到字典中，当任务有更新时会调用对应的回调
 */
- (BOOL)observerFolderDownloadForRequest:(QCloudSMHDownloadRequest *)request
                                   error:(NSError * _Nullable * _Nullable)error
                             progress:(QCloudSMHFolderProgressCallback)progress
                            stateChanged:(QCloudSMHFolderStateChangedCallback)stateChanged {
    
    QCloudSMHBaseTask *task = [QCloudSMHTaskManager.sharedManager getTaskFromSubscribedQueue:request.requestId];
    if (!task) {
        task = [QCloudSMHTaskManager.sharedManager createTaskWithRequest:request];
    }
    if (task.taskType == QCloudSMHTaskTypeFolder) {
        QCloudSMHFolderTask *folderTask = (QCloudSMHFolderTask *)task;
        [folderTask subscribeToSubTaskNotifications];
        [folderTask handleSubTaskProgressUpdate];
        [folderTask handleSubTaskCompletion];
    }
    // 添加任务到订阅队列（直接传递Task对象）
    BOOL success = [QCloudSMHTaskManager.sharedManager addTaskToSubscribedQueue:task error:error];
    
    if (!success) {
        return NO;
    }
    
    // 使用递归锁保护回调字典的并发访问
    [self.callbackLock lock];
    // 存储进度回调块
    if (progress) {
        [self.progressCallbackList setObject:progress forKey:request.requestId];
        progress(task.remotePath, task.taskType, task.bytesProcessed, task.totalBytes, task.filesProcessed, task.totalFiles);
    }
    // 存储状态变化回调块
    if (stateChanged) {
        [self.stateChangedCallbackList setObject:stateChanged forKey:request.requestId];
        stateChanged(task.remotePath, task.taskType, task.state, task.error);
    }
    [self.callbackLock unlock];
    return YES;
}

/**
 * 移除指定下载任务的监听回调
 * 停止接收该任务的进度和状态更新通知
 */
- (void)removeObserverFolderDownloadForRequest:(QCloudSMHDownloadRequest *)request {
    // 使用递归锁保护回调字典的并发访问
    [self.callbackLock lock];
    // 移除进度回调
    [self.progressCallbackList removeObjectForKey:request.requestId];
    // 移除状态变化回调
    [self.stateChangedCallbackList removeObjectForKey:request.requestId];
    [self.callbackLock unlock];
    
    [QCloudSMHTaskManager.sharedManager removeTaskIdFromSubscribedQueue:request.requestId];
}

#pragma mark - QCloudSMHTaskEventSubscriber 协议实现

/**
 * 任务进度更新回调
 * 当任务管理器检测到任务进度变化时调用此方法
 */
- (void)onTaskProgressUpdated:(NSString *)taskId path:(NSString *)path bytesProcessed:(int64_t)bytesProcessed totalBytes:(int64_t)totalBytes completedFiles:(int)completedFiles totalFiles:(int)totalFiles taskType:(QCloudSMHTaskType)taskType {
    // 线程安全地获取进度回调块
    [self.callbackLock lock];
    QCloudSMHFolderProgressCallback callback = self.progressCallbackList[taskId];
    [self.callbackLock unlock];
    
    if (!callback) {
        return;
    }
    
    // 调用用户注册的进度回调块
    callback(path, taskType, bytesProcessed, totalBytes, completedFiles, totalFiles);
}

- (void)onTaskStateChanged:(NSString *)taskId path:(NSString *)path state:(QCloudSMHTaskState)state oldState:(QCloudSMHTaskState)oldState error:(NSError *)error taskType:(QCloudSMHTaskType)taskType {
    // 线程安全地获取状态变化回调块
    [self.callbackLock lock];
    QCloudSMHFolderStateChangedCallback callback = self.stateChangedCallbackList[taskId];
    [self.callbackLock unlock];
    
    if (!callback) {
        return;
    }
    // 调用用户注册的状态变化回调块
    callback(path, taskType, state, error);
}


#pragma mark - 关联对象 Getter/Setter

/**
 * 获取或创建递归锁
 * 用于保护回调字典的并发访问，防止多线程竞态条件
 */
- (NSRecursiveLock *)callbackLock {
    NSRecursiveLock *lock = objc_getAssociatedObject(self, _cmd);
    if (!lock) {
        lock = [[NSRecursiveLock alloc] init];
        objc_setAssociatedObject(self, @selector(callbackLock), lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lock;
}

/**
 * 获取或创建进度回调字典
 * 存储任务ID到进度回调块的映射
 */
- (NSMutableDictionary<NSString *, QCloudSMHFolderProgressCallback> *)progressCallbackList {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(progressCallbackList), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

/**
 * 设置进度回调字典
 */
- (void)setProgressCallbackList:(NSMutableDictionary<NSString *, QCloudSMHFolderProgressCallback> *)progressCallbackList {
    objc_setAssociatedObject(self, @selector(progressCallbackList), progressCallbackList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 * 获取或创建状态变化回调字典
 * 存储任务ID到状态变化回调块的映射
 */
- (NSMutableDictionary<NSString *, QCloudSMHFolderStateChangedCallback> *)stateChangedCallbackList {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(stateChangedCallbackList), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

/**
 * 设置状态变化回调字典
 */
- (void)setStateChangedCallbackList:(NSMutableDictionary<NSString *, QCloudSMHFolderStateChangedCallback> *)stateChangedCallbackList {
    objc_setAssociatedObject(self, @selector(stateChangedCallbackList), stateChangedCallbackList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
