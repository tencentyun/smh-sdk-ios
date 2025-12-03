//
//  QCloudSMHDownloadRequest.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHDownloadRequest.h"
#import "QCloudSMHFolderTask.h"
#import "QCloudSMHTaskManager.h"
#import "QCloudSMHTaskIDGenerator.h"
#import "QCloudSMHService.h"

@interface QCloudSMHDownloadRequest ()

@property (nonatomic, strong) QCloudSMHTaskManager *taskManager;

@end


@implementation QCloudSMHDownloadRequest

#pragma mark - 初始化方法

/**
 * 初始化文件夹/文件下载请求
 * 设置下载参数并初始化默认值
 */
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                             path:(NSString *)path
                             type:(QCloudSMHTaskType)type
                         localURL:(NSURL *)localURL {
    if (self = [super init]) {
        // 设置下载参数
        _libraryId = libraryId;
        _spaceId = spaceId;
        _userId = userId;
        _localURL = localURL;
        _path = path;
        _type = type;
        // 初始化默认值
        [self setupDefaultValues];
    }
    return self;
}

/**
 * 设置默认配置值
 */
- (void)setupDefaultValues {
    // 默认启用断点续传
    _enableResumeDownload = YES;
    // 默认启用CRC64校验
    _enableCRC64Verification = YES;
    // 默认冲突策略为覆盖
    _conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    // 获取任务管理器单例
    _taskManager = [QCloudSMHTaskManager sharedManager];
}

#pragma mark - 任务管理方法

/**
 * 暂停文件夹/文件下载任务
 * 暂停后可以通过 resume 继续下载
 */
- (void)pause {
    [self.taskManager pauseTaskById:self.requestId];
}

/**
 * 继续文件夹/文件下载任务
 * 恢复之前暂停的下载任务
 */
- (void)resume {
    [self.taskManager resumeTaskById:self.requestId];
}

/**
 * 取消文件夹/文件下载任务
 * 取消后会删除已下载的部分文件
 */
- (void)cancel {
    [self.taskManager cancelTaskById:self.requestId];
}

/**
 * 删除文件夹/文件下载任务
 * 删除任务记录和已下载的文件
 */
- (void)delete {
    [self.taskManager deleteTaskById:self.requestId];
}

/**
 * 获取请求ID
 * 用于唯一标识该下载请求，由库ID、空间ID、用户ID、路径和本地URL组合生成
 * @return 请求ID字符串
 */
- (NSString *)requestId {
    return [QCloudSMHTaskIDGenerator generateTaskIDWithLibraryId:self.libraryId
                                                         spaceId:self.spaceId
                                                          userId:self.userId
                                                 remotePath:self.path
                                                   localURL:self.localURL];
}

@end
