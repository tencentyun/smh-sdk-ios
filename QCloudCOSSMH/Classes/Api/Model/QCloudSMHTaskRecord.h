//
//  QCloudSMHTaskRecord.h
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/6.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHBaseTask.h"
#import "QCloudSMHCommonEnum.h"

#pragma mark - 排序类型枚举

NS_ASSUME_NONNULL_BEGIN

/**
 * 任务数据库记录对象
 * 用于在SQLite数据库中存储和管理下载任务的信息
 * 包含任务的基本信息、进度、状态、配置等
 */
@interface QCloudSMHTaskRecord : NSObject

#pragma mark - 任务标识

/**
 * 任务ID（数据库主键）
 * 由库ID、空间ID、用户ID、远程路径和本地URL组合生成
 */
@property (nonatomic, copy) NSString *taskId;

/**
 * 任务类型
 * QCloudSMHTaskTypeFile（文件）或 QCloudSMHTaskTypeFolder（文件夹）
 */
@property (nonatomic, assign) QCloudSMHTaskType taskType;

/**
 * 任务状态
 * 如扫描中、下载中、已暂停、已完成、已失败等
 */
@property (nonatomic, assign) QCloudSMHTaskState taskState;

#pragma mark - 进度信息

/**
 * 已处理字节数
 * 已下载的文件总大小（字节）
 */
@property (nonatomic, assign) int64_t bytesProcessed;

/**
 * 总字节数
 * 需要下载的文件总大小（字节）
 */
@property (nonatomic, assign) int64_t totalBytes;

/**
 * 已完成的文件数
 * 已成功下载的文件个数
 */
@property (nonatomic, assign) int32_t filesProcessed;

/**
 * 总文件数
 * 需要下载的文件总个数
 */
@property (nonatomic, assign) int32_t totalFiles;

#pragma mark - 库、空间、用户信息

/**
 * 库ID
 * 标识文件所属的库
 */
@property (nonatomic, copy) NSString *libraryId;

/**
 * 空间ID
 * 标识文件所属的空间
 */
@property (nonatomic, copy) NSString *spaceId;

/**
 * 用户ID
 * 标识操作用户
 */
@property (nonatomic, copy) NSString *userId;

#pragma mark - 路径信息

/**
 * 远程文件/文件夹路径
 * 如 "/folder/file.txt" 或 "/folder/subfolder"
 */
@property (nonatomic, copy) NSString *remotePath;

/**
 * 父远程路径
 * 用于查询同一文件夹下的所有下载任务
 */
@property (nonatomic, copy) NSString *parentRemotePath;

/**
 * 本地保存文件夹路径
 * 下载的文件将保存到此目录
 */
@property (nonatomic, copy) NSString *localPath;

/**
 * 文件名
 * 下载后保存的文件名，可能因冲突策略而改变
 */
@property (nonatomic, copy) NSString *fileName;

#pragma mark - 下载配置（仅文件任务）

/**
 * 文件冲突处理策略
 * 覆盖、重命名或询问
 */
@property (nonatomic, assign) QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 * 是否启用断点续传
 * YES 时支持暂停后继续下载
 */
@property (nonatomic, assign) BOOL enableResumeDownload;

/**
 * 是否启用CRC64校验
 * YES 时验证下载文件的完整性
 */
@property (nonatomic, assign) BOOL enableCRC64Verification;

/**
 * 是否启用任务自动启动
 * NO 表示任务创建后不自动启动（如自动加载的父任务）
 */
@property (nonatomic, assign) BOOL enableStart;

/**
 * 是否启用任务恢复
 * YES 表示任务可以被恢复，NO 表示任务不可恢复
 */
@property (nonatomic, assign) BOOL enableResume;

#pragma mark - 扫描信息（仅文件夹任务）

/**
 * 是否已完成文件夹扫描
 * YES 表示文件夹内容已全部扫描完成
 */
@property (nonatomic, assign) BOOL scanCompleted;

/**
 * 下次扫描的分页标记
 * 用于暂停后继续扫描，保存上次扫描的位置
 */
@property (nonatomic, copy, nullable) NSString *nextMarker;

#pragma mark - 错误信息

/**
 * 错误码
 * 任务失败时的错误代码
 */
@property (nonatomic, assign) NSInteger errorCode;

/**
 * 错误信息
 * 任务失败时的错误描述
 */
@property (nonatomic, copy, nullable) NSString *errorMessage;

#pragma mark - 时间戳

/**
 * 创建时间
 * 任务创建的时间戳
 */
@property (nonatomic, strong) NSDate *createdAt;

/**
 * 更新时间
 * 任务最后更新的时间戳
 */
@property (nonatomic, strong) NSDate *updatedAt;


@end

NS_ASSUME_NONNULL_END
