//
//  QCloudSMHDownloadDetail.m
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/20.
//

#import "QCloudSMHDownloadDetail.h"
#import "QCloudSMHTaskRecord.h"
#import "QCloudSMHTaskDatabaseManager.h"
#import "QCloudSMHTaskManager.h"
#import "QCloudSMHTaskError.h"
#import "QCloudSMHFolderTask.h"

@interface QCloudSMHDownloadDetail ()

@property (nonatomic, copy) NSString *rootLocalPath;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@end

@implementation QCloudSMHDownloadDetail

/**
 * 根据数据库任务记录初始化下载详情
 * 将数据库记录的信息转换为可展示的下载详情对象
 */
- (instancetype)initWithTaskRecord:(QCloudSMHTaskRecord *)record {
    if (!record) {
        return nil;
    }
    
    if (self = [super init]) {
        
        QCloudSMHBaseTask *task = [QCloudSMHTaskManager.sharedManager createTaskFromRecord:record];
        
        if (task.taskType == QCloudSMHTaskTypeFolder) {
            QCloudSMHFolderTask *folderTask = (QCloudSMHFolderTask *)task;
            [folderTask handleSubTaskProgressUpdate];
            [folderTask handleSubTaskCompletion];
        }
        // 复制远程路径
        _remotePath = task.remotePath;
        // 复制进度信息
        _bytesProcessed = task.bytesProcessed;
        _totalBytes = task.totalBytes;
        _filesProcessed = task.filesProcessed;
        _totalFiles = task.totalFiles;
        // 判断是否为文件
        _isFile = (task.taskType == QCloudSMHTaskTypeFile);
        // 复制库、空间、用户信息
        _libraryId = [task.libraryId copy];
        _spaceId = [task.spaceId copy];
        _userId = [task.userId copy];
        // 保存本地根路径和文件名，用于计算完整路径
        _rootLocalPath = task.localURL.path;
        _fileName = [record.fileName copy];
        // 保存创建时间和更新时间，将NSDate转换为NSString
        _createTime = [self formatDateToString:record.createdAt];
        _updateTime = [self formatDateToString:record.updatedAt];
        
        _state = task.state;
        if (record.errorMessage) {
            _error = [NSError errorWithDomain:QCloudSMHTaskErrorDomain
                                         code:record.errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: record.errorMessage}];
        }
        
    }
    
    return self;
}

/**
 * 计算本地保存的完整路径
 * 由本地根目录 + 远程路径 + 文件名组成
 */
- (NSString *)localPath {
    // 构建本地文件保存目录
    NSString *directoryURLStr = [[self.rootLocalPath stringByAppendingPathComponent:self.remotePath] stringByDeletingLastPathComponent];
   
    // 构建本地文件保存路径
    return [directoryURLStr stringByAppendingPathComponent:self.fileName];
}

#pragma mark - 私有方法

/**
 * 将NSDate转换为格式化的NSString
 * 格式为：yyyy-MM-dd HH:mm:ss
 *
 * @param date NSDate对象
 * @return 格式化后的时间字符串，如果date为nil则返回nil
 */
- (nullable NSString *)formatDateToString:(nullable NSDate *)date {
    if (!date) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end
