//
//  QCloudSMHFileTask.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHFileTask.h"
#import "QCloudSMHService.h"
#import "QCloudSMHTaskError.h"
#import "QCloudSMHTaskManager.h"

@interface QCloudSMHFileTask ()

#pragma mark - 下载控制
@property (nonatomic, strong) QCloudCOSSMHDownloadObjectRequest *downloadRequest;

@end

@implementation QCloudSMHFileTask

#pragma mark - 初始化

- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                  remotePath:(NSString *)remotePath
                    localFileURL:(NSURL *)localURL
                       fileSize:(int64_t)fileSize
                         fileName:(NSString *)fileName
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
        _fileName = fileName;
    }
    return self;
}

#pragma mark - QCloudSMHBaseTask 协议实现

/**
 * 返回任务类型
 */
- (QCloudSMHTaskType)taskType {
    return QCloudSMHTaskTypeFile;
}

/**
 * 启动文件下载任务
 * 检查冲突、创建目录、创建下载请求并启动下载
 */
- (void)start {
    if (!self.enableStart) {
        return;
    }
    QCloudLogDebug(@"%@ 任务启动", self.remotePath);
    // 更新任务状态为下载中
    self.state = QCloudSMHTaskStateDownloading;
    // 开始文件下载
    [self startDownload];
}

/**
 * 暂停文件下载任务
 * 取消当前的下载请求，保存进度以便后续恢复
 */
- (void)pause {
    if ([QCloudSMHBaseTask isInactiveState:self.state]) {
        return;
    }
    // 更新任务状态为已暂停
    self.state = QCloudSMHTaskStatePaused;
    // 取消下载请求
    [self.downloadRequest cancel];
}

/**
 * 取消文件下载任务
 * 删除已下载的部分文件
 */
- (void)cancel {
    if ([QCloudSMHBaseTask isTerminalState:self.state]) {
        return;
    }
    self.error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                                                  code:QCloudSMHTaskErrorUserCancel
                                                   userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"用户取消了 %@ 任务的下载", self.remotePath]}];
    self.state = QCloudSMHTaskStateFailed;
    // 删除已下载的文件和断点续传文件
    [self.downloadRequest remove];
}

/**
 * 删除文件下载任务
 * 删除已下载的文件、从数据库删除记录
 */
- (void)delete {
    // 删除已下载的文件和断点续传文件
    [super delete];
    
    [self.downloadRequest remove];
}

#pragma mark - 文件下载实现

/**
 * 启动文件下载
 * 流程：检查冲突 -> 创建目录 -> 创建下载请求 -> 启动下载
 */
- (void)startDownload {
    NSString *fileName = self.fileName;
    // 构建本地文件保存目录
    NSURL *directoryURL = [[self.localURL URLByAppendingPathComponent:self.remotePath isDirectory:YES] URLByDeletingLastPathComponent];
    // 构建本地文件保存路径
    NSURL *downloadURL = [directoryURL URLByAppendingPathComponent:fileName];
    
    // 检查文件冲突，根据冲突策略处理
    NSError *error = [self checkFileConflictWithDownloadURL:downloadURL];
    if (error) {
        [self handleDownloadComplete:nil error:error];
        return;
    }
    
    // 确保本地目录存在
    error = [self ensureCurrentDirectoryExists];
    if (error) {
        [self handleDownloadComplete:nil error:error];
        return;
    }
    
    // 如果文件名因冲突策略被改变，更新下载URL
    if (![fileName isEqualToString:self.fileName]) {
        downloadURL = [[downloadURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:self.fileName];
    }
    
    // 创建下载请求
    QCloudCOSSMHDownloadObjectRequest *request = [self createDownloadRequestWithURL:downloadURL];
    self.downloadRequest = request;
    // 启动下载
    [[QCloudSMHService defaultSMHService] smhDownload:request];
}

/**
 * 创建下载请求对象
 * 配置下载参数、进度回调、完成回调
 */
- (QCloudCOSSMHDownloadObjectRequest *)createDownloadRequestWithURL:(NSURL *)downloadURL {
    QCloudCOSSMHDownloadObjectRequest *request = [[QCloudCOSSMHDownloadObjectRequest alloc] init];
    // 配置下载参数
    request.libraryId = self.libraryId;
    request.spaceId = self.spaceId;
    request.userId = self.userId;
    request.filePath = self.remotePath;
    request.downloadingURL = downloadURL;
    request.enableCRC64Verification = self.enableCRC64Verification;
    request.resumableDownload = self.enableResumeDownload;
    request.priority = QCloudAbstractRequestPriorityNormal;
    
    __weak typeof(self) weakSelf = self;
    
    // 设置下载进度回调
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        // 更新任务进度
        [strongSelf updateProgressWithBytesProcessed:totalBytesDownload
                                          totalBytes:totalBytesExpectedToDownload
                                       filesProcessed:(totalBytesExpectedToDownload == totalBytesDownload ? 1 : 0)
                                          totalFiles:1];
    }];
    
    // 设置下载完成回调
    [request setFinishBlock:^(id outputObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            // 区分用户取消和其他错误
            if (error.code == QCloudNetworkErrorCodeCanceled) {
                return;
            }
        }
        // 处理下载完成
        [strongSelf handleDownloadComplete:outputObject error:error];
    }];
    
    return request;
}

#pragma mark - 下载完成处理

/**
 * 处理文件下载完成
 * 更新任务状态、清理资源、记录日志
 */
- (void)handleDownloadComplete:(id)outputObject error:(NSError *)error {
    if (error) {
        // 下载失败
        self.error = error;
        QCloudLogDebug(@"%@ 文件下载失败：%@", self.remotePath, error);
    } else {
        // 下载成功
        QCloudLogDebug(@"%@ 文件下载完成", self.remotePath);
    }
    // 更新任务状态
    self.state = error ? QCloudSMHTaskStateFailed : QCloudSMHTaskStateCompleted;
}

#pragma mark - 文件冲突处理

/**
 * 检查文件冲突
 * 根据冲突策略处理已存在的文件
 */
- (NSError *)checkFileConflictWithDownloadURL:(NSURL *)downloadURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 文件不存在，无冲突
    if (![fileManager fileExistsAtPath:downloadURL.path]) {
        return nil;
    }
    
    // 根据冲突策略处理
    switch (self.conflictStrategy) {
        case QCloudSMHConflictStrategyEnumOverWrite:
            // 覆盖策略：删除已存在的文件
            return [self handleOverWriteConflict:downloadURL fileManager:fileManager];
            
        case QCloudSMHConflictStrategyEnumRename:
            // 重命名策略：生成新的文件名
            return [self handleRenameConflict:downloadURL fileManager:fileManager];
            
        case QCloudSMHConflictStrategyEnumAsk:
            // 询问策略：返回错误，由上层处理
            return [self createFileConflictError:downloadURL];
            
        default:
            return nil;
    }
}

- (NSError *)handleOverWriteConflict:(NSURL *)downloadURL fileManager:(NSFileManager *)fileManager {
    [fileManager removeItemAtURL:downloadURL error:nil];
    return nil;
}

- (NSError *)handleRenameConflict:(NSURL *)downloadURL fileManager:(NSFileManager *)fileManager {
    NSURL *newURL = [self generateUniqueFileName:downloadURL fileManager:fileManager];
    self.fileName = [newURL lastPathComponent];
    return nil;
}

- (NSError *)createFileConflictError:(NSURL *)downloadURL {
    NSString *errorMessage = [NSString stringWithFormat:@"%@ 文件已存在，请检查路径：%@", self.fileName, self.localURL];
    return [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                               code:QCloudSMHTaskErrorPathConflict
                           userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
}

- (NSURL *)generateUniqueFileName:(NSURL *)originalURL fileManager:(NSFileManager *)fileManager {
    NSString *fileName = [originalURL lastPathComponent];
    NSString *extension = [fileName pathExtension];
    NSString *baseName = [fileName stringByDeletingPathExtension];
    NSURL *directoryURL = [originalURL URLByDeletingLastPathComponent];
    
    for (NSInteger i = 1; i < 1000; i++) {
        NSString *newFileName = [self generateFileNameWithBaseName:baseName
                                                          extension:extension
                                                            attempt:i];
        NSURL *newURL = [directoryURL URLByAppendingPathComponent:newFileName];
        
        if (![fileManager fileExistsAtPath:newURL.path]) {
            return newURL;
        }
    }
    
    return originalURL;
}

- (NSString *)generateFileNameWithBaseName:(NSString *)baseName
                                 extension:(NSString *)extension
                                   attempt:(NSInteger)attempt {
    if (extension.length > 0) {
        return [NSString stringWithFormat:@"%@ (%ld).%@", baseName, (long)attempt, extension];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld)", baseName, (long)attempt];
    }
}

@end
