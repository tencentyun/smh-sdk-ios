//
//  QCloudSMHFolderTask.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHFolderTask.h"
#import "QCloudSMHService.h"
#import "QCloudSMHFileTask.h"

#import "QCloudSMHListContentsRequest.h"
#import "QCloudSMHTaskManager.h"
#import "QCloudSMHTaskError.h"

@interface QCloudSMHFolderTask ()

#pragma mark - 任务管理
// 记录直系子任务ID (仅用于控制Start/Pause/Cancel)
@property (nonatomic, strong) NSMutableArray<NSString *> *subTaskIds;
@property (nonatomic, strong) QCloudSMHListContentsRequest *request;

// 是否订阅了子任务通知
@property (nonatomic, assign) BOOL isSubscribed;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *activeTaskProgress;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *activeTaskTotalBytes;

#pragma mark - 进度聚合
@property (nonatomic, assign) int64_t cachedBytesProcessed;
@property (nonatomic, assign) int64_t cachedTotalBytes;

#pragma mark - 状态聚合
// 存储各状态的任务数量
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *stateCounts;

@end

@implementation QCloudSMHFolderTask

@synthesize scanCompleted = _scanCompleted;
@synthesize nextMarker = _nextMarker;
@synthesize enableResume = _enableResume;

#pragma mark - 初始化

/**
 * 初始化文件夹下载任务
 * 调用父类初始化，然后初始化子任务管理相关的属性
 */
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                 remotePath:(NSString *)remotePath
                   localURL:(NSURL *)localURL
             enableResumeDownload:(BOOL)enableResumeDownload
          enableCRC64Verification:(BOOL)enableCRC64Verification
                conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy {
    self = [super initWithLibraryId:libraryId
                            spaceId:spaceId
                             userId:userId
                         remotePath:remotePath
                           localURL:localURL
               enableResumeDownload:enableResumeDownload
            enableCRC64Verification:enableCRC64Verification
                   conflictStrategy:conflictStrategy];
    if (self) {
        // 初始化直系子任务列表
        _subTaskIds = [NSMutableArray array];
        
        // 初始化活跃任务缓存
        _activeTaskProgress = [NSMutableDictionary dictionary];
        _activeTaskTotalBytes = [NSMutableDictionary dictionary];
        
        // 初始化缓存统计
        _cachedBytesProcessed = 0;
        _cachedTotalBytes = 0;
        
        // 初始化状态计数
        _stateCounts = [NSMutableDictionary dictionary];
        
        // 初始化恢复标志
        _enableResume = NO;
        
        // 从数据库聚合恢复状态
        [self restoreAggregatedStateFromDatabase];
        
        // 恢复直系子任务ID (仅用于控制)
        [self restoreDirectSubTaskIdsFromDatabase];
    }
    return self;
}

- (QCloudSMHTaskManager *)taskManager {
    return QCloudSMHTaskManager.sharedManager;
}

#pragma mark - 内存管理

- (void)dealloc {
    [self unsubscribeFromSubTaskNotifications];
}

- (void)resetTask {
    [self.lock lock];
    _nextMarker = nil;
    _scanCompleted = NO;
    _subTaskIds = [NSMutableArray array];
    [_activeTaskProgress removeAllObjects];
    [_activeTaskTotalBytes removeAllObjects];
    
    _cachedBytesProcessed = 0;
    _cachedTotalBytes = 0;
    [_stateCounts removeAllObjects];
    [self.lock unlock];
    
    // 删除数据库中的子任务记录，重新开始下载
    [self.taskManager.databaseManager deleteDescendantTasksWithLibraryId:self.libraryId
                                                                       spaceId:self.spaceId
                                                                        userId:self.userId
                                                                  remotePath:self.remotePath
                                                                   localPath:self.localURL.path];

    [super resetTask];
}

#pragma mark - QCloudSMHBaseTask 实现

- (QCloudSMHTaskType)taskType {
    return QCloudSMHTaskTypeFolder;
}

- (void)start {
    [self subscribeToSubTaskNotifications];
    
    if (!self.enableStart) {
        // 初始化进度聚合
        [self handleSubTaskProgressUpdate];
        // 初始化状态检查
        [self handleSubTaskCompletion];
        return;
    }
    QCloudLogDebug(@"%@ 任务启动", self.remotePath);
    if (self.scanCompleted) {
        if (self.enableResume) {
            [self resumeAllSubTasks];
            self.enableResume = NO;
        } else {
            [self startAllSubTasks];
        }
    } else {
        self.state = QCloudSMHTaskStateScanning;
        [self startFolderScan];
    }
}

- (void)pause {
    if ([QCloudSMHBaseTask isInactiveState:self.state]) {
        return;
    }
    [self pauseAllSubTasks];
    [self unsubscribeFromSubTaskNotifications];
    self.state = QCloudSMHTaskStatePaused;
}

- (void)cancel {
    if ([QCloudSMHBaseTask isTerminalState:self.state]) {
        return;
    }
    [self unsubscribeFromSubTaskNotifications];
    [self.request cancel];
    [self cancelAllSubTasks];
    self.error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                                      code:QCloudSMHTaskErrorUserCancel
                                   userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"用户取消了 %@ 任务的下载", self.remotePath]}];
    self.state = QCloudSMHTaskStateFailed;
}

- (void)delete {
    [self unsubscribeFromSubTaskNotifications];
    [self.request cancel];
    [self deleteAllSubTasks];
    
    [super delete];
}

#pragma mark - 文件夹扫描

/**
 * 启动文件夹扫描
 * 开始扫描远程文件夹内容
 */
- (void)startFolderScan {
    // 提前创建当前目录结构
    NSError *error = [self ensureCurrentDirectoryExists];
    if (error) {
        [self handleScanError:error];
        return;
    }
    // 扫描文件夹
    [self performFolderScan];
}

/**
 * 执行文件夹扫描
 * 调用API列出文件夹内容，支持分页扫描
 */
- (void)performFolderScan {
    if (!_request) {
        _request = [[QCloudSMHListContentsRequest alloc] init];
    }
    _request.libraryId = self.libraryId;
    _request.spaceId = self.spaceId;
    _request.userId = self.userId;
    _request.dirPath = self.remotePath;
    _request.marker = self.nextMarker;
    _request.priority = QCloudAbstractRequestPriorityNormal;
    __weak typeof(self) weakSelf = self;
    [_request setFinishBlock:^(QCloudSMHContentListInfo *outputObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if ([QCloudSMHBaseTask isInactiveState:strongSelf.state]) {
            strongSelf->_request = nil;
            return;
        }
        
        if (error) {
            [strongSelf handleScanError:error];
            strongSelf->_request = nil;
            return;
        }
        
        [strongSelf handleScanResult:outputObject];
    }];
    
    [[QCloudSMHService defaultSMHService] batchListContents:_request];
}

/**
 * 处理文件夹扫描结果
 * 分离文件和子文件夹，创建对应的任务，处理分页
 */
- (void)handleScanResult:(QCloudSMHContentListInfo *)result {
    // 分离子文件夹和文件
    NSMutableArray *subFolderPaths = [NSMutableArray array];
    NSMutableArray *subFileContents = [NSMutableArray array];
    for (QCloudSMHContentInfo *content in result.contents) {
        if (content.type == QCloudSMHContentInfoTypeDir) {
            // 子文件夹路径
            NSString *remotePath = [content.paths componentsJoinedByString:@"/"];
            [subFolderPaths addObject:remotePath];
        } else {
            // 文件内容
            [subFileContents addObject:content];
        }
    }
    
    // 为子文件夹创建下载任务
    [self scanSubFolder:subFolderPaths];
    // 为文件创建下载任务
    [self createFileTaskForContent:subFileContents];
    
    // 线程安全地更新分页标记
    [self.lock lock];
    self.nextMarker = [result.nextMarker copy];
    BOOL shouldCompleteScanning = !result.nextMarker || result.nextMarker.length == 0;
    [self.lock unlock];
    
    if (shouldCompleteScanning) {
        // 扫描完成，开始下载
        self.scanCompleted = YES;
        // 启动所有子任务
        [self startAllSubTasks];
    } else {
        // 继续扫描下一页
        [self performFolderScan];
    }
}

/**
 * 处理文件夹扫描错误
 * 设置错误信息并更新任务状态
 */
- (void)handleScanError:(NSError *)error {
    if (error) {
        NSError *tempError = error.domain == QCloudSMHTaskErrorDomain ? error : [NSError errorWithDomain:QCloudSMHTaskErrorDomain
        code:QCloudSMHTaskErrorInternalError
     userInfo:@{NSLocalizedDescriptionKey: error.localizedDescription}];
        // 将扫描错误转换为任务错误
        self.error = tempError;
    }
    // 更新任务状态为失败
    self.state = !error ? QCloudSMHTaskStateCompleted : QCloudSMHTaskStateFailed;
    QCloudLogDebug(@"%@ 文件夹扫描失败: %@", self.remotePath, error);
}

#pragma mark - 子任务创建

- (void)scanSubFolder:(NSArray<NSString *> *)subRemotePaths {
    if (subRemotePaths.count == 0) {
        return;
    }
    NSMutableArray *taskArray = [NSMutableArray array];
    for (NSString *remotePath in subRemotePaths) {
        QCloudSMHFolderTask *task = [self.taskManager createFolderTaskWithLibraryId:self.libraryId
                                                                            spaceId:self.spaceId
                                                                             userId:self.userId
                                                                   remoteFolderPath:remotePath
                                                                     localFolderURL:self.localURL
                                                                   conflictStrategy:self.conflictStrategy
                                                               enableResumeDownload:self.enableResumeDownload
                                                            enableCRC64Verification:self.enableCRC64Verification];
        [taskArray addObject:task];
        [self recordSubTaskId:task.taskId isDirectSubTask:YES];
    }
    [self.taskManager.databaseManager batchSaveTasks:taskArray];
}

- (void)createFileTaskForContent:(NSArray<QCloudSMHContentInfo *> *)contents {
    if (contents.count == 0) {
        return;
    }
    NSMutableArray *taskArray = [NSMutableArray array];
    
    for (QCloudSMHContentInfo *content in contents) {
        NSString *remotePath = [content.paths componentsJoinedByString:@"/"];
        int64_t fileSize = [content.size longLongValue];
        
        QCloudSMHFileTask *task = [self.taskManager createFileTaskWithLibraryId:self.libraryId
                                                                            spaceId:self.spaceId
                                                                             userId:self.userId
                                                                         remotePath:remotePath
                                                                           localURL:self.localURL
                                                                           fileName:content.name
                                                                           fileSize:fileSize
                                                                   conflictStrategy:self.conflictStrategy
                                                               enableResumeDownload:self.enableResumeDownload
                                                            enableCRC64Verification:self.enableCRC64Verification];
        [taskArray addObject:task];
        [self recordSubTaskId:task.taskId isDirectSubTask:YES];
        // 通知父任务，子任务以创建
        [self.taskManager notifyTaskCreated:task];
    }
    
    [self.taskManager.databaseManager batchSaveTasks:taskArray];
}

- (void)recordSubTaskId:(NSString *)taskId isDirectSubTask:(BOOL)isDirect {
    // 仅记录直系子任务用于控制
    if (isDirect) {
        [self.lock lock];
        if (![self.subTaskIds containsObject:taskId]) {
            [self.subTaskIds addObject:taskId];
        }
        [self.lock unlock];
    }
}

#pragma mark - 子任务操作

- (void)performActionOnAllSubTasks:(SEL)selector {
    [self.lock lock];
    // 只对直系子任务进行操作控制
    NSArray<NSString *> *taskIds = [self.subTaskIds copy];
    [self.lock unlock];
    
    if (!taskIds || taskIds.count == 0) {
        // 如果没有子任务，启动操作应该直接标记为完成
        if (selector == @selector(startTaskById:)) {
            [self handleSubTaskCompletion];
        }
        return;
    }
    
    for (NSString *taskId in taskIds) {
        @try {
            if (selector == @selector(startTaskById:)) {
                // 更新状态
                [self.taskManager startTaskById:taskId];
                self.state = QCloudSMHTaskStateDownloading;
            } else if (selector == @selector(resumeTaskById:)) {
                [self.taskManager resumeTaskById:taskId];
                self.state = QCloudSMHTaskStateDownloading;
            }
            else if (selector == @selector(pauseTaskById:)) {
                [self.taskManager pauseTaskById:taskId];
            } else if (selector == @selector(cancelTaskById:)) {
                [self.taskManager cancelTaskById:taskId];
            } else if (selector == @selector(deleteTaskById:)) {
                [self.taskManager deleteTaskById:taskId];
            }
        } @catch (NSException *exception) {
            QCloudLogError(@"执行子任务操作异常 (%@): %@", self.remotePath, exception.reason);
        }
    }
}

- (void)startAllSubTasks {
    [self performActionOnAllSubTasks:@selector(startTaskById:)];
}

- (void)resumeAllSubTasks {
    [self performActionOnAllSubTasks:@selector(resumeTaskById:)];
}

- (void)pauseAllSubTasks {
    [self performActionOnAllSubTasks:@selector(pauseTaskById:)];
}

- (void)cancelAllSubTasks {
    [self performActionOnAllSubTasks:@selector(cancelTaskById:)];
}

- (void)deleteAllSubTasks {
    [self performActionOnAllSubTasks:@selector(deleteTaskById:)];
}

/**
 * 获取所有任务总数（即总文件数）
 * 包括所有状态的文件任务计数
 * @return 所有任务的总数
 */
- (NSInteger)getTotalTaskCount {
    [self.lock lock];
    NSInteger total = 0;
    for (NSNumber *count in [self.stateCounts allValues]) {
        total += [count integerValue];
    }
    [self.lock unlock];
    return total;
}

/**
 * 获取所有状态的任务计数
 * @param outIdle 输出参数：Idle状态计数
 * @param outScanning 输出参数：Scanning状态计数
 * @param outDownloading 输出参数：Downloading状态计数
 * @param outPaused 输出参数：Paused状态计数
 * @param outFailed 输出参数：Failed状态计数
 * @param outCompleted 输出参数：Completed状态计数
 * @return 所有任务总数
 */
- (NSInteger)getAllStateCountsWithIdle:(NSInteger *)outIdle
                              scanning:(NSInteger *)outScanning
                           downloading:(NSInteger *)outDownloading
                                paused:(NSInteger *)outPaused
                                failed:(NSInteger *)outFailed
                             completed:(NSInteger *)outCompleted {
    [self.lock lock];
    
    NSInteger idle = [self.stateCounts[@(QCloudSMHTaskStateIdle)] integerValue];
    NSInteger scanning = [self.stateCounts[@(QCloudSMHTaskStateScanning)] integerValue];
    NSInteger downloading = [self.stateCounts[@(QCloudSMHTaskStateDownloading)] integerValue];
    NSInteger paused = [self.stateCounts[@(QCloudSMHTaskStatePaused)] integerValue];
    NSInteger failed = [self.stateCounts[@(QCloudSMHTaskStateFailed)] integerValue];
    NSInteger completed = [self.stateCounts[@(QCloudSMHTaskStateCompleted)] integerValue];
    
    if (outIdle) *outIdle = idle;
    if (outScanning) *outScanning = scanning;
    if (outDownloading) *outDownloading = downloading;
    if (outPaused) *outPaused = paused;
    if (outFailed) *outFailed = failed;
    if (outCompleted) *outCompleted = completed;
    
    NSInteger total = idle + scanning + downloading + paused + failed + completed;
    [self.lock unlock];
    
    return total;
}


#pragma mark - 数据库恢复

- (BOOL)restoreStateFromDatabase {
    if (![super restoreStateFromDatabase]) {
        return NO;
    }
    
    @try {
        QCloudSMHTaskRecord *record = [self.taskManager.databaseManager getTaskById:self.taskId];
        if (!record) {
            QCloudLogDebug(@"未找到文件夹任务记录: %@", self.remotePath);
            return NO;
        }
        [self.lock lock];
        _scanCompleted = record.scanCompleted;
        _nextMarker = record.nextMarker;
        _enableResume = record.enableResume;
        [self.lock unlock];
        
        
        return YES;
    } @catch (NSException *exception) {
        QCloudLogDebug(@"恢复文件夹任务状态异常 (%@): %@", self.remotePath, exception.reason);
        return NO;
    }
}

/**
 * 从数据库聚合恢复状态
 * 只执行两条SQL查询，极大降低内存占用
 */
- (void)restoreAggregatedStateFromDatabase {
    @try {
        // 1. 聚合统计进度 (TotalBytes, ProcessedBytes)
        NSDictionary *stats = [self.taskManager.databaseManager aggregateDescendantTaskStatsWithLibraryId:self.libraryId
                                                                                                  spaceId:self.spaceId
                                                                                                   userId:self.userId
                                                                                           rootRemotePath:self.remotePath
                                                                                                localPath:self.localURL.path];
        
        // 2. 聚合统计状态 (各状态计数)
        NSDictionary *counts = [self.taskManager.databaseManager countDescendantTaskStatesWithLibraryId:self.libraryId
                                                                                                spaceId:self.spaceId
                                                                                                 userId:self.userId
                                                                                         rootRemotePath:self.remotePath
                                                                                              localPath:self.localURL.path];
        
        [self.lock lock];
        if (stats && stats.count > 0) {
            _cachedTotalBytes = [stats[@"totalBytes"] longLongValue];
            _cachedBytesProcessed = [stats[@"bytesProcessed"] longLongValue];
        }
        
        [_stateCounts removeAllObjects];
        if (counts) {
            [_stateCounts addEntriesFromDictionary:counts];
        }
        [self.lock unlock];
        
    } @catch (NSException *exception) {
        QCloudLogError(@"恢复聚合状态异常 (%@): %@", self.remotePath, exception.reason);
    }
}

/**
 * 仅恢复直系子任务ID
 * 用于 startAllSubTasks 等操作
 * 优化：只查询taskId，避免加载完整记录
 */
- (void)restoreDirectSubTaskIdsFromDatabase {
    @try {
        NSArray<NSString *> *taskIds = [self.taskManager.databaseManager
            getTaskIdsWithLibraryId:self.libraryId
                            spaceId:self.spaceId
                             userId:self.userId
                   parentRemotePath:self.remotePath
                          localPath:self.localURL.path
                      includeStates:@[@(QCloudSMHTaskStateIdle),
                                      @(QCloudSMHTaskStatePaused),
                                      @(QCloudSMHTaskStateScanning),
                                      @(QCloudSMHTaskStateDownloading)]];
        
        [self.lock lock];
        [self.subTaskIds removeAllObjects];
        if (taskIds.count > 0) {
            [self.subTaskIds addObjectsFromArray:taskIds];
        }
        [self.lock unlock];
        
    } @catch (NSException *exception) {
        QCloudLogError(@"恢复直系子任务ID异常 (%@): %@", self.remotePath, exception.reason);
    }
}


#pragma mark - 状态更新

- (void)setScanCompleted:(BOOL)scanCompleted {
    [self.lock lock];
    _scanCompleted = scanCompleted;
    [self.lock unlock];
}

- (BOOL)scanCompleted {
    [self.lock lock];
    BOOL value = _scanCompleted;
    [self.lock unlock];
    return value;
}

- (void)setNextMarker:(NSString *)nextMarker {
    [self.lock lock];
    _nextMarker = [nextMarker copy];
    [self.lock unlock];
}

- (NSString *)nextMarker {
    [self.lock lock];
    NSString *value = [_nextMarker copy];
    [self.lock unlock];
    return value;
}

- (void)setIsSubscribed:(BOOL)isSubscribed {
    [self.lock lock];
    _isSubscribed = isSubscribed;
    [self.lock unlock];
}



- (void)setEnableResume:(BOOL)enableResume {
    [self.lock lock];
    _enableResume = enableResume;
    [self.lock unlock];
}

- (BOOL)enableResume {
    [self.lock lock];
    BOOL value = _enableResume;
    [self.lock unlock];
    return value;
}

- (void)setState:(QCloudSMHTaskState)state {
    [super setState:state];
    
    if ([QCloudSMHBaseTask isInactiveState:state]) {
        [self unsubscribeFromSubTaskNotifications];
    }
}


#pragma mark - 子任务回调处理

- (void)handleSubTaskProgressUpdate {
    [self aggregateSubTasksProgress];
}

- (void)handleSubTaskCompletion {
    [self checkAllSubTasksCompletion];
}

- (void)aggregateSubTasksProgress {
    [self.lock lock];
    int64_t totalBytesAll = self.cachedTotalBytes;
    int64_t bytesProcessedAll = self.cachedBytesProcessed;
    
    // filesProcessed 直接从 Completed 状态计数获取
    NSInteger filesProcessedAll = [self.stateCounts[@(QCloudSMHTaskStateCompleted)] integerValue];
    
    // totalFiles 实时计算
    NSInteger totalFilesAll = 0;
    for (NSNumber *count in [self.stateCounts allValues]) {
        totalFilesAll += [count integerValue];
    }
    
    [self.lock unlock];
    
    [self updateProgressWithBytesProcessed:bytesProcessedAll
                                totalBytes:totalBytesAll
                            filesProcessed:(int32_t)filesProcessedAll
                                totalFiles:(int32_t)totalFilesAll];
}

- (void)checkAllSubTasksCompletion {
    NSInteger idle, scanning, downloading, paused, failed, completed;
    NSInteger total = [self getAllStateCountsWithIdle:&idle
                                             scanning:&scanning
                                          downloading:&downloading
                                               paused:&paused
                                               failed:&failed
                                            completed:&completed];
    
    // O(1) 状态判断逻辑
    QCloudSMHTaskState targetState = QCloudSMHTaskStateIdle;
    
    if (downloading > 0) {
        targetState = QCloudSMHTaskStateDownloading;
    } else if (scanning > 0) {
        targetState = QCloudSMHTaskStateScanning;
    } else if (idle > 0) {
        targetState = QCloudSMHTaskStateIdle;
    } else if (paused > 0) {
        targetState = QCloudSMHTaskStatePaused;
    } else if (failed > 0) {
        // 有失败且无其他活跃状态，则整体失败
        [self setFailedStateWithError];
        return;
    } else if (completed == total && total > 0) {
        targetState = QCloudSMHTaskStateCompleted;
        [self handleSubTaskProgressUpdate];
    } else if (total == 0 && self.scanCompleted) {
        // 扫描完成且无子任务
        targetState = QCloudSMHTaskStateCompleted;
    } else {
        // 其他情况保持当前状态，或默认为 Idle
        return;
    }
    if (total != completed + paused + failed) {
        return;
    }
        
    if (self.state != targetState && self.state != QCloudSMHTaskStateFailed) {
         self.state = targetState;
    }
}

- (void)setFailedStateWithError {
    NSString *errorMsg = @"子任务失败或被取消";
    NSError *error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                                         code:QCloudSMHTaskErrorInternalError
                                     userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
    self.error = error;
    self.state = QCloudSMHTaskStateFailed;
    QCloudLogDebug(@"%@ 文件夹下载失败：%@", self.remotePath, error);
}

#pragma mark - 通知监听

- (void)subscribeToSubTaskNotifications {
    if (self.isSubscribed) {
        return;
    }
    self.isSubscribed = YES;
    QCloudLogDebug(@"%@ 订阅子任务通知", self.remotePath);
    [self.taskManager subscribeTaskEvents:self];
}

- (void)unsubscribeFromSubTaskNotifications {
    if (!self.isSubscribed) {
        return;
    }
    self.isSubscribed = NO;
    QCloudLogDebug(@"%@ 取消订阅子任务通知", self.remotePath);
    [self.taskManager unsubscribeTaskEvents:self];
}

#pragma mark - QCloudSMHTaskEventSubscriber 协议实现

- (void)onTaskProgressUpdated:(NSString *)taskId
                           path:(NSString *)path
                  bytesProcessed:(int64_t)bytesProcessed
                       totalBytes:(int64_t)totalBytes
                    completedFiles:(int)completedFiles
                        totalFiles:(int)totalFiles
                           taskType:(QCloudSMHTaskType)taskType {
    if (![self belongsToSubTask:path]) return;
    
    // 文件夹类型不参与字节统计
    if (taskType == QCloudSMHTaskTypeFolder) return;
    
    [self.lock lock];
    
    // 计算增量
    int64_t lastBytes = 0;
    int64_t lastTotalBytes = 0;

    if (self.activeTaskProgress[taskId] == nil || self.activeTaskTotalBytes[taskId] == nil) {
        // 懒加载：从数据库获取基准值
        QCloudSMHTaskRecord *record = [self.taskManager.databaseManager getTaskById:taskId];
        if (record) {
            self.activeTaskProgress[taskId] = @(record.bytesProcessed);
            self.activeTaskTotalBytes[taskId] = @(record.totalBytes);
        } else {
            // 极端情况：任务不存在？
            self.activeTaskProgress[taskId] = @(0);
            self.activeTaskTotalBytes[taskId] = @(0);
        }
    }
    
    lastBytes = [self.activeTaskProgress[taskId] longLongValue];
    int64_t delta = bytesProcessed - lastBytes;

    lastTotalBytes = [self.activeTaskTotalBytes[taskId] longLongValue];
    int64_t deltaTotal = totalBytes - lastTotalBytes;
    
    
    // 更新活跃缓存
    self.activeTaskProgress[taskId] = @(bytesProcessed);
    self.activeTaskTotalBytes[taskId] = @(totalBytes);

    if (delta > 0) {
        self.cachedBytesProcessed += delta;
    }
    if (deltaTotal > 0) {
        self.cachedTotalBytes += deltaTotal;
    }
    
    [self.lock unlock];
    
    [self handleSubTaskProgressUpdate];
}

- (void)onTaskStateChanged:(NSString *)taskId
                        path:(NSString *)path
                       state:(QCloudSMHTaskState)state
                    oldState:(QCloudSMHTaskState)oldState
                       error:(NSError *)error
                    taskType:(QCloudSMHTaskType)taskType {
    if (![self belongsToSubTask:path]) return;
    if ([QCloudSMHBaseTask isTerminalState:state]) {
        [self.lock lock];
        [self.subTaskIds removeObject:taskId];
        [self.lock unlock];
    } else {
        [self recordSubTaskId:taskId isDirectSubTask:[self isDirectSubTask:path]];
    }
   
    // 文件夹类型不参与字节统计
    if (taskType == QCloudSMHTaskTypeFolder) return;
    
    [self.lock lock];
    
    if (oldState == state) {
        NSNumber *key = @(state);
        NSInteger count = [self.stateCounts[key] integerValue];
        self.stateCounts[key] = @(count + 1);
    } else {
        [self updateStateCountFromOldState:oldState toNewState:state];
    }
    
    if ([QCloudSMHBaseTask isInactiveState:state]) {
        [self.activeTaskProgress removeObjectForKey:taskId];
        [self.activeTaskTotalBytes removeObjectForKey:taskId];
    }
    
    [self.lock unlock];
    
    // 检查完成情况
    if ([QCloudSMHBaseTask isInactiveState:state]) {
        [self handleSubTaskCompletion];
    }
}

- (void)onTaskDeleted:(NSString *)taskId 
                 path:(NSString *)path 
             taskType:(QCloudSMHTaskType)taskType 
                error:(NSError *)error 
           statistics:(NSDictionary *)statistics {
    if (![self belongsToSubTask:path]) return;
    
    [self.lock lock];
    [self.subTaskIds removeObject:taskId];
    
    // 移除活跃缓存
    [self.activeTaskProgress removeObjectForKey:taskId];
    [self.activeTaskTotalBytes removeObjectForKey:taskId];
    
    // 维护状态计数
    if (taskType == QCloudSMHTaskTypeFile && statistics && statistics[@"taskState"]) {
        QCloudSMHTaskState delState = [statistics[@"taskState"] intValue];
        // 移除统计时，不应增加Idle计数，而是单纯减少旧状态计数
        NSNumber *oldKey = @(delState);
        NSInteger oldCount = [self.stateCounts[oldKey] integerValue];
        if (oldCount > 0) {
            self.stateCounts[oldKey] = @(oldCount - 1);
        }
    }
    
    // 扣减进度
    if (statistics && taskType == QCloudSMHTaskTypeFile) {
        int64_t bytes = [statistics[@"bytesProcessed"] longLongValue];
        int64_t total = [statistics[@"totalBytes"] longLongValue];
        self.cachedBytesProcessed -= bytes;
        self.cachedTotalBytes -= total;
    }
    
    [self.lock unlock];
    
    [self handleSubTaskProgressUpdate];
    [self handleSubTaskCompletion];
}

// 辅助：更新状态计数
- (void)updateStateCountFromOldState:(QCloudSMHTaskState)oldState toNewState:(QCloudSMHTaskState)newState {
    if (oldState == newState) return;
    // 减旧
    NSNumber *oldKey = @(oldState);
    NSInteger oldCount = [self.stateCounts[oldKey] integerValue];
    if (oldCount > 0) {
        self.stateCounts[oldKey] = @(oldCount - 1);
    }
    
    // 加新
    NSNumber *newKey = @(newState);
    NSInteger newCount = [self.stateCounts[newKey] integerValue];
    self.stateCounts[newKey] = @(newCount + 1);
}

#pragma mark - 子任务判断

/**
 * 规范化路径（移除末尾斜杠）
 */
- (NSString *)normalizePath:(NSString *)path {
    if (!path.length) {
        return path;
    }
    return [path hasSuffix:@"/"] ? [path substringToIndex:path.length - 1] : path;
}

/**
 * 是否是子任务（基于远程路径检查）
 * 检查path是否属于此文件夹或其子文件夹
 */
- (BOOL)belongsToSubTask:(NSString *)path {
    if (!path.length || !self.remotePath.length) {
        return NO;
    }
    
    NSString *normalizedFolder = [self normalizePath:self.remotePath];
    NSString *normalizedPath = [self normalizePath:path];
    
    return ![normalizedPath isEqualToString:normalizedFolder] && 
           [normalizedPath hasPrefix:[normalizedFolder stringByAppendingString:@"/"]];
}

/**
 * 是否是直系子任务
 * 检查 path 是否为当前文件夹的直接子节点（不包含孙子节点）
 */
- (BOOL)isDirectSubTask:(NSString *)path {
    if (!path || ![self belongsToSubTask:path]) {
        return NO;
    }
    
    NSString *normalizedFolder = [self normalizePath:self.remotePath];
    NSString *normalizedPath = [self normalizePath:path];
    
    NSString *relativePath = [normalizedPath substringFromIndex:normalizedFolder.length + 1]; // +1 跳过斜杠
    
    // 如果剩余路径中还包含斜杠，说明是孙子节点或更深层节点
    return [relativePath rangeOfString:@"/"].location == NSNotFound;
}

@end

