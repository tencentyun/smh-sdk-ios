//
//  QCloudSMHBaseTask.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHBaseTask.h"
#import "QCloudSMHTaskIDGenerator.h"
#import "QCloudSMHTaskError.h"
#import "QCloudSMHFolderTask.h"
#import "QCloudSMHTaskManager.h"
#import <QCloudCore/QCloudCore.h>


@interface QCloudSMHBaseTask ()

/**
 * 状态锁
 */
@property (nonatomic, strong) NSRecursiveLock *lock;

/**
 * 任务已处理字节数
 */
@property (nonatomic, assign) int64_t bytesProcessed;

/**
 * 任务总字节数
 */
@property (nonatomic, assign) int64_t totalBytes;

/**
 * 任务以处理的文件数
 */
@property (nonatomic, assign) int32_t filesProcessed;

/**
 * 任务总文件数
 */
@property (nonatomic, assign) int32_t totalFiles;

/**
 * 任务创建时间
 */
@property (nonatomic, assign) NSTimeInterval createdTime;

/**
 * 是否加载了父任务
 */
@property (nonatomic, assign) BOOL loadedParentTask;

@end

@implementation QCloudSMHBaseTask

@synthesize state = _state;
@synthesize totalBytes = _totalBytes;
@synthesize bytesProcessed = _bytesProcessed;
@synthesize filesProcessed = _filesProcessed;
@synthesize totalFiles = _totalFiles;
@synthesize error = _error;
@synthesize createdTime = _createdTime;
@synthesize enableStart = _enableStart;

#pragma mark - 初始化

- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                 remotePath:(NSString *)remotePath
                   localURL:(NSURL *)localURL
             enableResumeDownload:(BOOL)enableResumeDownload
          enableCRC64Verification:(BOOL)enableCRC64Verification
                conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy {
    self = [super init];
    if (self) {
        _libraryId = [libraryId copy];
        _spaceId = [spaceId copy];
        _userId = [userId copy];
        _remotePath = [remotePath copy];
        _localURL = [localURL copy];
        _taskId = [QCloudSMHTaskIDGenerator generateTaskIDWithLibraryId:self.libraryId
                                                                spaceId:self.spaceId
                                                                 userId:self.userId
                                                        remotePath:self.remotePath
                                                          localURL:self.localURL];
        _state = QCloudSMHTaskStateIdle;
        _enableResumeDownload = enableResumeDownload;
        _enableCRC64Verification = enableCRC64Verification;
        _conflictStrategy = conflictStrategy;
        _lock = [[NSRecursiveLock alloc] init];
        _createdTime = [[NSDate date] timeIntervalSince1970];
        _enableStart = YES;
        
        [self restoreStateFromDatabase];
    }
    return self;
}


#pragma mark - QCloudSMHBaseTask 实现

- (void)start {
    [NSException raise:@"AbstractMethodException" format:@"子类必须重写 start 方法"];
}

- (void)pause {
    // 子类必须重写此方法
    [NSException raise:@"AbstractMethodException" format:@"子类必须重写 pause 方法"];
}

- (void)cancel {
    // 子类必须重写此方法
    [NSException raise:@"AbstractMethodException" format:@"子类必须重写 cancel 方法"];
}

- (void)delete {
    [QCloudSMHTaskManager.sharedManager.databaseManager deleteTaskById:self.taskId];
    
    if (self.stateChangeCallback) {
        self.stateChangeCallback(self.taskId, QCloudSMHTaskStateFailed, self.state, [NSError errorWithDomain:QCloudSMHTaskErrorDomain code:QCloudSMHTaskErrorUserDelete userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ 任务被删除", self.remotePath]}]);
    }
}

#pragma mark - 状态管理（支持数据库持久化）
/**
 * 内部方法：在子线程中安全地更新进度信息
 *
 */
- (void)updateProgressWithBytesProcessed:(int64_t)bytesProcessed
                              totalBytes:(int64_t)totalBytes
                           filesProcessed:(int32_t)filesProcessed
                              totalFiles:(int32_t)totalFiles {
    [self.lock lock];
    _bytesProcessed = bytesProcessed;
    _totalBytes = totalBytes;
    _filesProcessed = filesProcessed;
    _totalFiles = totalFiles;
    [self.lock unlock];
    
    // 通知进度变化
    [self notifyTaskProgressUpdate];
}

/**
 * 设置任务状态，并自动保存到数据库
 */
- (void)setState:(QCloudSMHTaskState)state {
    QCloudSMHTaskState oldState;
    [self.lock lock];
    if (_state == state) {
        [self.lock unlock];
        return;
    }
    oldState = _state;
    _state = state;
    [self.lock unlock];
    
    // 保存状态到数据库
    [self saveStateToDatabase];
    // 通知状态变化
    [self notifyStateChange:oldState];
}

/**
 * 设置错误信息，并自动保存到数据库
 */
- (void)setError:(NSError *)error {
    [self.lock lock];
    _error = error;
    [self.lock unlock];
}

- (void)setEnableStart:(BOOL)enableStart {
    [self.lock lock];
    _enableStart = enableStart;
    [self.lock unlock];
    
    [self saveStateToDatabase];
}

- (QCloudSMHTaskType)taskType {
    // 子类必须重写此方法
    [NSException raise:@"AbstractMethodException" format:@"子类必须重写 taskType 方法"];
    return QCloudSMHTaskTypeFile;
}

- (QCloudSMHTaskState)state {
    [self.lock lock];
    QCloudSMHTaskState currentState = _state;
    [self.lock unlock];
    return currentState;
}

- (int64_t)bytesProcessed {
    [self.lock lock];
    int64_t bytes = _bytesProcessed;
    [self.lock unlock];
    return bytes;
}

- (int64_t)totalBytes {
    [self.lock lock];
    int64_t total = _totalBytes;
    [self.lock unlock];
    return total;
}

- (int32_t)filesProcessed {
    [self.lock lock];
    int32_t files = _filesProcessed;
    [self.lock unlock];
    return files;
}

- (int32_t)totalFiles {
    [self.lock lock];
    int32_t total = _totalFiles;
    [self.lock unlock];
    return total;
}

- (NSError *)error {
    [self.lock lock];
    NSError *err = _error;
    [self.lock unlock];
    return err;
}

- (BOOL)enableStart {
    [self.lock lock];
    BOOL enableStart = _enableStart;
    [self.lock unlock];
    return enableStart;
}

#pragma mark - 任务状态判断

/**
 * 判断任务是否处于非活跃状态
 */
+ (BOOL)isInactiveState:(QCloudSMHTaskState)state {
    return state == QCloudSMHTaskStatePaused ||
           state == QCloudSMHTaskStateCompleted ||
           state == QCloudSMHTaskStateFailed;
}

/**
 * 判断任务是否处于终止状态
 */
+ (BOOL)isTerminalState:(QCloudSMHTaskState)state {
    return state == QCloudSMHTaskStateCompleted || state == QCloudSMHTaskStateFailed;
}

#pragma mark - 数据库持久化

/**
 * 保存任务状态到数据库
 */
- (void)saveStateToDatabase {
    [QCloudSMHTaskManager.sharedManager saveTaskStateToDatabase:self];
}

/**
 * 从数据库恢复任务状态
 */
- (BOOL)restoreStateFromDatabase {
    // 从数据库获取任务记录
    QCloudSMHTaskRecord *record = [QCloudSMHTaskManager.sharedManager.databaseManager getTaskById:self.taskId];
    if (!record) {
        return NO;
    }
    
    // 恢复任务状态
    [_lock lock];
    _state = record.taskState;
    _bytesProcessed = record.bytesProcessed;
    _totalBytes = record.totalBytes;
    _filesProcessed = record.filesProcessed;
    _totalFiles = record.totalFiles;
    _enableStart = record.enableStart;
    // 将NSDate转换为NSTimeInterval
    if (record.createdAt) {
        _createdTime = [record.createdAt timeIntervalSince1970];
    }
    if (record.errorMessage) {
        _error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                                     code:record.errorCode
                                 userInfo:@{NSLocalizedDescriptionKey: record.errorMessage}];
    }
    [_lock unlock];
    
    return YES;
}

- (void)resetTask {
    [self.lock lock];
    _bytesProcessed = 0;
    _totalBytes = 0;
    _filesProcessed = 0;
    _totalFiles = 0;
    [self.lock unlock];
    
    [self resetState];
}

- (void)resetState {
    [self.lock lock];
    QCloudSMHTaskState oldState = _state;
    _error = nil;
    _enableStart = YES;
    _state = QCloudSMHTaskStateIdle;
    [self.lock unlock];
    
    [self notifyStateChange:oldState];
    
    [self saveStateToDatabase];
}

#pragma mark - 通知机制

/**
 * 通知状态变化
 */
- (void)notifyStateChange:(QCloudSMHTaskState)oldState {
    // 通知状态变化回调
    if (self.stateChangeCallback) {
        self.stateChangeCallback(self.taskId, self.state, oldState, self.error);
    }
}

/**
 * 通知任务进度更新
 */
- (void)notifyTaskProgressUpdate {
    // 触发最终进度回调
    if (self.progressCallback) {
        self.progressCallback(self.taskId, self.bytesProcessed, self.totalBytes, self.filesProcessed, self.totalFiles);
    }
}

#pragma mark - 目录创建

/**
 * 确保当前目录存在
 */
- (NSError *)ensureCurrentDirectoryExists {
    // 直接根据 localPath + remotePath 组合路径创建目录
    NSURL *directoryURL = nil;
    if (self.taskType == QCloudSMHTaskTypeFolder) {
        directoryURL = [self.localURL URLByAppendingPathComponent:self.remotePath isDirectory:YES];
    } else {
        directoryURL = [[self.localURL URLByAppendingPathComponent:self.remotePath isDirectory:YES] URLByDeletingLastPathComponent];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 检查目录是否已存在
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:directoryURL.path isDirectory:&isDirectory] && isDirectory) {
        return nil;
    }
    
    // 目录不存在，创建目录
    NSError *error = nil;
    if (![fileManager createDirectoryAtURL:directoryURL
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
        QCloudLogDebug(@"创建文件夹失败 %@: %@", directoryURL.path, error.localizedDescription);
        return [NSError errorWithDomain:QCloudSMHTaskErrorDomain code:QCloudSMHTaskCreateFolderFailed userInfo:error.userInfo];
    }
    
    return nil;
}


@end

