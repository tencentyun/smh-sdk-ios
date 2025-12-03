//
//  QCloudSMHTaskDatabaseConstants.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/19
//

#import "QCloudSMHTaskDatabaseConstants.h"

#pragma mark - 数据库配置

NSString * const kQCloudSMHDatabaseFileName = @"qcloud_smh_tasks.db";
NSString * const kQCloudSMHDatabaseQueueLabel = @"com.qcloud.smh.task.database";
NSString * const kQCloudSMHDatabaseTableName = @"tasks";

#pragma mark - SQL语句

NSString * const kQCloudSMHCreateTableSQL = @"CREATE TABLE IF NOT EXISTS tasks ("
    @"task_id TEXT PRIMARY KEY, "
    @"task_type INTEGER NOT NULL, "
    @"task_state INTEGER NOT NULL, "
    @"bytes_processed INTEGER DEFAULT 0, "
    @"total_bytes INTEGER DEFAULT 0, "
    @"files_processed INTEGER DEFAULT 0, "
    @"total_files INTEGER DEFAULT 0, "
    @"library_id TEXT NOT NULL, "
    @"space_id TEXT NOT NULL, "
    @"user_id TEXT NOT NULL, "
    @"remote_path TEXT NOT NULL, "
    @"parent_remote_path TEXT, "
    @"local_path TEXT NOT NULL, "
    @"file_name TEXT, "
    @"conflict_strategy INTEGER DEFAULT 0, "
    @"enable_resume_download INTEGER DEFAULT 1, "
    @"enable_crc64_verification INTEGER DEFAULT 1, "
    @"enable_start INTEGER DEFAULT 1, "
    @"enable_resume INTEGER DEFAULT 0, "
    @"scan_completed INTEGER DEFAULT 0, "
    @"next_marker TEXT, "
    @"error_code INTEGER DEFAULT 0, "
    @"error_message TEXT, "
    @"created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
    @"updated_at DATETIME DEFAULT CURRENT_TIMESTAMP"
    @")";

NSString * const kQCloudSMHInsertOrReplaceTaskSQL = @"INSERT OR REPLACE INTO tasks ("
    @"task_id, task_type, task_state, bytes_processed, total_bytes, files_processed, total_files, "
    @"library_id, space_id, user_id, remote_path, parent_remote_path, local_path, file_name, "
    @"conflict_strategy, enable_resume_download, enable_crc64_verification, enable_start, enable_resume, scan_completed, next_marker, error_code, error_message, created_at, updated_at"
    @") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

NSString * const kQCloudSMHUpdateTaskBaseSQL = @"UPDATE tasks SET task_state = ?, bytes_processed = ?, total_bytes = ?, "
    @"files_processed = ?, total_files = ?, enable_start = ?, error_code = ?, error_message = ?";

NSString * const kQCloudSMHSelectTaskSQL = @"SELECT * FROM tasks WHERE task_id = ?";

NSString * const kQCloudSMHDeleteTaskSQL = @"DELETE FROM tasks WHERE task_id = ?";

NSString * const kQCloudSMHDeleteDescendantTasksSQL = @"DELETE FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND local_path = ? AND (remote_path LIKE ? OR parent_remote_path LIKE ?)";

#pragma mark - 数据库列名

NSString * const kQCloudSMHColumnTaskId = @"task_id";
NSString * const kQCloudSMHColumnTaskType = @"task_type";
NSString * const kQCloudSMHColumnTaskState = @"task_state";
NSString * const kQCloudSMHColumnBytesProcessed = @"bytes_processed";
NSString * const kQCloudSMHColumnTotalBytes = @"total_bytes";
NSString * const kQCloudSMHColumnFilesProcessed = @"files_processed";
NSString * const kQCloudSMHColumnTotalFiles = @"total_files";
NSString * const kQCloudSMHColumnLibraryId = @"library_id";
NSString * const kQCloudSMHColumnSpaceId = @"space_id";
NSString * const kQCloudSMHColumnUserId = @"user_id";
NSString * const kQCloudSMHColumnRemotePath = @"remote_path";
NSString * const kQCloudSMHColumnParentRemotePath = @"parent_remote_path";
NSString * const kQCloudSMHColumnLocalPath = @"local_path";
NSString * const kQCloudSMHColumnFileName = @"file_name";
NSString * const kQCloudSMHColumnConflictStrategy = @"conflict_strategy";
NSString * const kQCloudSMHColumnEnableResumeDownload = @"enable_resume_download";
NSString * const kQCloudSMHColumnEnableCRC64Verification = @"enable_crc64_verification";
NSString * const kQCloudSMHColumnEnableStart = @"enable_start";
NSString * const kQCloudSMHColumnEnableResume = @"enable_resume";
NSString * const kQCloudSMHColumnScanCompleted = @"scan_completed";
NSString * const kQCloudSMHColumnNextMarker = @"next_marker";
NSString * const kQCloudSMHColumnErrorCode = @"error_code";
NSString * const kQCloudSMHColumnErrorMessage = @"error_message";
NSString * const kQCloudSMHColumnCreatedAt = @"created_at";
NSString * const kQCloudSMHColumnUpdatedAt = @"updated_at";
