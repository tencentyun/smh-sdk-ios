//
//  QCloudSMHTaskDatabaseConstants.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/19
//

#ifndef QCloudSMHTaskDatabaseConstants_h
#define QCloudSMHTaskDatabaseConstants_h

#pragma mark - 数据库配置

/// 数据库文件名
extern NSString * const kQCloudSMHDatabaseFileName;

/// 数据库队列标识
extern NSString * const kQCloudSMHDatabaseQueueLabel;

/// 数据库表名
extern NSString * const kQCloudSMHDatabaseTableName;

#pragma mark - SQL语句

/// 创建任务表SQL
extern NSString * const kQCloudSMHCreateTableSQL;

/// 插入或替换任务SQL
extern NSString * const kQCloudSMHInsertOrReplaceTaskSQL;

/// 更新任务基础字段SQL
extern NSString * const kQCloudSMHUpdateTaskBaseSQL;

/// 查询任务SQL
extern NSString * const kQCloudSMHSelectTaskSQL;

/// 删除任务SQL
extern NSString * const kQCloudSMHDeleteTaskSQL;

/// 删除所有后代任务SQL
extern NSString * const kQCloudSMHDeleteDescendantTasksSQL;

#pragma mark - 数据库列名

/// 任务ID列
extern NSString * const kQCloudSMHColumnTaskId;

/// 任务类型列
extern NSString * const kQCloudSMHColumnTaskType;

/// 任务状态列
extern NSString * const kQCloudSMHColumnTaskState;

/// 已处理字节数列
extern NSString * const kQCloudSMHColumnBytesProcessed;

/// 总字节数列
extern NSString * const kQCloudSMHColumnTotalBytes;

/// 已处理文件数列
extern NSString * const kQCloudSMHColumnFilesProcessed;

/// 总文件数列
extern NSString * const kQCloudSMHColumnTotalFiles;

/// 库ID列
extern NSString * const kQCloudSMHColumnLibraryId;

/// 空间ID列
extern NSString * const kQCloudSMHColumnSpaceId;

/// 用户ID列
extern NSString * const kQCloudSMHColumnUserId;

/// 远程路径列
extern NSString * const kQCloudSMHColumnRemotePath;

/// 父远程路径列
extern NSString * const kQCloudSMHColumnParentRemotePath;

/// 本地路径列
extern NSString * const kQCloudSMHColumnLocalPath;

/// 文件名列
extern NSString * const kQCloudSMHColumnFileName;

/// 冲突策略列
extern NSString * const kQCloudSMHColumnConflictStrategy;

/// 启用断点续传列
extern NSString * const kQCloudSMHColumnEnableResumeDownload;

/// 启用CRC64校验列
extern NSString * const kQCloudSMHColumnEnableCRC64Verification;

/// 启用任务自动启动列
extern NSString * const kQCloudSMHColumnEnableStart;

/// 启用任务恢复列
extern NSString * const kQCloudSMHColumnEnableResume;

/// 扫描完成列
extern NSString * const kQCloudSMHColumnScanCompleted;

/// 下一个标记列
extern NSString * const kQCloudSMHColumnNextMarker;

/// 错误码列
extern NSString * const kQCloudSMHColumnErrorCode;

/// 错误消息列
extern NSString * const kQCloudSMHColumnErrorMessage;

/// 创建时间列
extern NSString * const kQCloudSMHColumnCreatedAt;

/// 更新时间列
extern NSString * const kQCloudSMHColumnUpdatedAt;

#endif /* QCloudSMHTaskDatabaseConstants_h */
