//
//  QCloudSMHFolderTask.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>
#import "QCloudSMHBaseTask.h"
#import "QCloudSMHTaskManager.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudSMHFileTask;

#pragma mark - 文件夹任务

/**
 * 文件夹任务
 *
 */
@interface QCloudSMHFolderTask : QCloudSMHBaseTask<QCloudSMHTaskEventSubscriber>


#pragma mark - 扫描状态属性

/**
 * 是否已完成文件夹扫描
 * 用于标记文件夹内容是否已全部扫描完成，扫描完成后才开始下载
 */
@property (nonatomic, assign) BOOL scanCompleted;

/**
 * 下次扫描的分页标记
 * 用于暂停后继续扫描，保存上次扫描的位置，支持断点续扫
 */
@property (nonatomic, copy, nullable) NSString *nextMarker;

/**
 * 是否启用任务恢复
 * YES 表示任务可以被恢复，NO 表示任务不可恢复
 */
@property (nonatomic, assign) BOOL enableResume;


#pragma mark - 初始化

/**
 * 初始化文件夹下载任务
 * 创建一个新的文件夹任务对象，用于管理整个文件夹的下载流程
 *
 * @param libraryId 库ID，标识文件所属的库
 * @param spaceId 空间ID，标识文件所属的空间
 * @param userId 用户ID，标识操作用户
 * @param remotePath 远程文件夹路径，如 "/folder/subfolder"
 * @param localURL 本地保存文件夹URL，下载的文件将保存到此目录
 * @param enableResumeDownload 是否启用断点续传，YES时支持暂停后继续
 * @param enableCRC64Verification 是否启用CRC64校验，YES时验证下载文件完整性
 * @param conflictStrategy 文件冲突处理策略（覆盖、重命名、询问）
 * @return 初始化后的文件夹任务对象
 */
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                 remotePath:(NSString *)remotePath
                   localURL:(NSURL *)localURL
             enableResumeDownload:(BOOL)enableResumeDownload
          enableCRC64Verification:(BOOL)enableCRC64Verification
                conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy;

#pragma mark - 订阅管理

/**
 * 订阅子任务事件通知
 * 注册为任务事件订阅者，以便接收所有子任务的进度和状态变化通知
 */
- (void)subscribeToSubTaskNotifications;

/**
 * 取消订阅子任务事件通知
 * 注销任务事件订阅，停止接收子任务的通知
 */
- (void)unsubscribeFromSubTaskNotifications;


#pragma mark - 进度管理
/**
 * 处理子任务进度更新
 */
- (void)handleSubTaskProgressUpdate;

/**
 * 处理子任务完成
 */
- (void)handleSubTaskCompletion;


/**
 * 聚合数据库状态
 */
- (void)restoreAggregatedStateFromDatabase;


@end

NS_ASSUME_NONNULL_END
