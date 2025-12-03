//
//  QCloudSMHTaskDatabaseManager.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/3
//

#import "QCloudSMHTaskDatabaseManager.h"
#import <sqlite3.h>
#import "QCloudSMHFolderTask.h"
#import "QCloudSMHFileTask.h"
#import "QCloudSMHTaskIDGenerator.h"
#import "QCloudSMHTaskDatabaseConstants.h"

@interface QCloudSMHTaskDatabaseManager () {
    sqlite3 *_database;
    NSString *_databasePath;
    dispatch_queue_t _databaseQueue;
}

@end

@implementation QCloudSMHTaskDatabaseManager

#pragma mark - 单例模式

+ (instancetype)sharedManager {
    static QCloudSMHTaskDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(
            DISPATCH_QUEUE_SERIAL,
            QOS_CLASS_USER_INITIATED,
            0
        );
        _databaseQueue = dispatch_queue_create([kQCloudSMHDatabaseQueueLabel UTF8String], attr);
        [self initializeDatabase];
    }
    return self;
}

#pragma mark - 数据库初始化

- (BOOL)initializeDatabase {
    __block BOOL success = NO;
    
    dispatch_sync(_databaseQueue, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *supportDirectory = [paths firstObject];
        if (!supportDirectory) {
            QCloudLogError(@"Failed to get application support directory");
            return;
        }
        
        // 创建 SDK 专用目录
        NSString *sdkDataDir = [supportDirectory stringByAppendingPathComponent:@"QCloudSMH"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:sdkDataDir]) {
            NSError *error = nil;
            if (![fileManager createDirectoryAtPath:sdkDataDir
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:&error]) {
                QCloudLogError(@"Failed to create SDK data directory: %@", error.localizedDescription);
                return;
            }
        }
        
        self->_databasePath = [sdkDataDir stringByAppendingPathComponent:kQCloudSMHDatabaseFileName];
        
        if (sqlite3_open([self->_databasePath UTF8String], &self->_database) == SQLITE_OK) {
            [self createOrUpdateTableStructure];
            success = YES;
        } else {
            QCloudLogError(@"Failed to open database at path: %@", self->_databasePath);
        }
    });
    
    return success;
}

- (void)createOrUpdateTableStructure {
    char *errorMsg = NULL;
    if (sqlite3_exec(_database, [kQCloudSMHCreateTableSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        QCloudLogError(@"Failed to create table: %s", errorMsg);
        sqlite3_free(errorMsg);
    }
}

#pragma mark - 任务CRUD操作

- (BOOL)saveTask:(QCloudSMHBaseTask *)task {
    if (!task || !task.taskId) {
        return NO;
    }
    
    __block BOOL success = NO;
    dispatch_sync(_databaseQueue, ^{
        success = [self saveTaskWithoutTransaction:task];
    });
    return success;
}

- (BOOL)updateTask:(QCloudSMHBaseTask *)task {
    if (!task || !task.taskId) {
        return NO;
    }
    
    __block BOOL success = NO;
    dispatch_sync(_databaseQueue, ^{
        success = [self updateTaskWithoutTransaction:task];
    });
    return success;
}

- (BOOL)saveTaskWithoutTransaction:(QCloudSMHBaseTask *)task {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [kQCloudSMHInsertOrReplaceTaskSQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        return NO;
    }
    
    BOOL success = [self bindTaskParameters:statement task:task];
    if (success) {
        success = (sqlite3_step(statement) == SQLITE_DONE);
    }
    sqlite3_finalize(statement);
    return success;
}

- (BOOL)updateTaskWithoutTransaction:(QCloudSMHBaseTask *)task {
    NSMutableString *sql = [NSMutableString stringWithString:kQCloudSMHUpdateTaskBaseSQL];
    
    BOOL isFolderTask = [task isKindOfClass:[QCloudSMHFolderTask class]];
    BOOL isFileTask = [task isKindOfClass:[QCloudSMHFileTask class]];
    
    if (isFolderTask) {
        [sql appendString:@", enable_resume = ?, scan_completed = ?, next_marker = ?"];
    }
    if (isFileTask) {
        [sql appendString:@", file_name = ?"];
    }
    [sql appendString:@" WHERE task_id = ?"];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        return NO;
    }
    
    int paramIndex = 1;
    
    // 绑定基础字段
    sqlite3_bind_int(statement, paramIndex++, (int)task.state);
    sqlite3_bind_int64(statement, paramIndex++, task.bytesProcessed);
    sqlite3_bind_int64(statement, paramIndex++, task.totalBytes);
    sqlite3_bind_int(statement, paramIndex++, task.filesProcessed);
    sqlite3_bind_int(statement, paramIndex++, task.totalFiles);
    sqlite3_bind_int(statement, paramIndex++, task.enableStart ? 1 : 0);
    
    // 绑定错误信息
    [self bindErrorParameters:statement paramIndex:&paramIndex task:task];
    
    // 绑定特定字段
    if (isFolderTask) {
        QCloudSMHFolderTask *folderTask = (QCloudSMHFolderTask *)task;
        sqlite3_bind_int(statement, paramIndex++, folderTask.enableResume ? 1 : 0);
        sqlite3_bind_int(statement, paramIndex++, folderTask.scanCompleted ? 1 : 0);
        
        if (folderTask.nextMarker && folderTask.nextMarker.length > 0) {
            sqlite3_bind_text(statement, paramIndex++, [folderTask.nextMarker UTF8String], -1, SQLITE_TRANSIENT);
        } else {
            sqlite3_bind_null(statement, paramIndex++);
        }
    }
    
    if (isFileTask) {
        QCloudSMHFileTask *fileTask = (QCloudSMHFileTask *)task;
        if (fileTask.fileName && fileTask.fileName.length > 0) {
            sqlite3_bind_text(statement, paramIndex++, [fileTask.fileName UTF8String], -1, SQLITE_TRANSIENT);
        } else {
            sqlite3_bind_null(statement, paramIndex++);
        }
    }
    
    sqlite3_bind_text(statement, paramIndex, [task.taskId UTF8String], -1, SQLITE_TRANSIENT);
    
    BOOL success = (sqlite3_step(statement) == SQLITE_DONE);
    sqlite3_finalize(statement);
    return success;
}

- (QCloudSMHTaskRecord *)getTaskById:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return nil;
    }
    
    __block QCloudSMHTaskRecord *record = nil;
    dispatch_sync(_databaseQueue, ^{
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [kQCloudSMHSelectTaskSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [taskId UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                record = [self taskRecordFromStatement:statement];
            }
            sqlite3_finalize(statement);
        }
    });
    return record;
}

- (BOOL)isTaskExistsById:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return NO;
    }
    
    __block BOOL exists = NO;
    dispatch_sync(_databaseQueue, ^{
        // 使用轻量级查询，仅检查是否存在
        NSString *countSQL = @"SELECT COUNT(*) FROM tasks WHERE task_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [countSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [taskId UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                int count = sqlite3_column_int(statement, 0);
                exists = (count > 0);
            }
            sqlite3_finalize(statement);
        }
    });
    return exists;
}

- (BOOL)deleteTaskById:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return NO;
    }
    
    __block BOOL success = NO;
    dispatch_sync(_databaseQueue, ^{
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [kQCloudSMHDeleteTaskSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [taskId UTF8String], -1, SQLITE_TRANSIENT);
            success = (sqlite3_step(statement) == SQLITE_DONE);
            sqlite3_finalize(statement);
        }
    });
    return success;
}

- (BOOL)deleteAllTasks {
    __block BOOL success = NO;
    dispatch_sync(_databaseQueue, ^{
        const char *sql = "DELETE FROM tasks";
        char *errorMessage = NULL;
        int result = sqlite3_exec(self->_database, sql, NULL, NULL, &errorMessage);
        if (result == SQLITE_OK) {
            success = YES;
            NSLog(@"✅ 已清理所有任务记录");
        } else {
            NSLog(@"❌ 清理任务记录失败: %s", errorMessage);
            if (errorMessage) {
                sqlite3_free(errorMessage);
            }
        }
    });
    return success;
}

- (BOOL)deleteDescendantTasksWithLibraryId:(NSString *)libraryId
                                   spaceId:(NSString *)spaceId
                                    userId:(NSString *)userId
                              remotePath:(NSString *)remotePath
                               localPath:(NSString *)localPath {
    if (!libraryId || !spaceId || !userId || !remotePath || !localPath) {
        return NO;
    }
    
    __block BOOL success = NO;
    dispatch_sync(_databaseQueue, ^{
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [kQCloudSMHDeleteDescendantTasksSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            // 构建 LIKE 模式匹配字符串，用于查找所有子孙任务
            // 例如：remotePath = "/folder" 时，匹配 "/folder/%" 及其所有后代
            NSString *likePattern = [NSString stringWithFormat:@"%@/%%", remotePath];
            sqlite3_bind_text(statement, paramIndex++, [likePattern UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [likePattern UTF8String], -1, SQLITE_TRANSIENT);
            
            success = (sqlite3_step(statement) == SQLITE_DONE);
            sqlite3_finalize(statement);
        }
    });
    return success;
}

#pragma mark - 查询操作

- (NSArray<NSString *> *)getTaskIdsWithLibraryId:(NSString *)libraryId
                                           spaceId:(NSString *)spaceId
                                            userId:(NSString *)userId
                               parentRemotePath:(NSString *)parentRemotePath
                                      localPath:(NSString *)localPath
                                  includeStates:(nullable NSArray<NSNumber *> *)includeStates {
    if (!libraryId || !spaceId || !userId || !localPath) {
        return @[];
    }
    
    __block NSMutableArray *taskIds = [NSMutableArray array];
    dispatch_sync(_databaseQueue, ^{
        NSMutableString *sql = [NSMutableString stringWithString:
            @"SELECT task_id FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ?"];
        
        if (parentRemotePath && parentRemotePath.length > 0) {
            [sql appendString:@" AND parent_remote_path = ?"];
        } else {
            [sql appendString:@" AND (parent_remote_path IS NULL OR parent_remote_path = '')"];
        }
        
        [sql appendString:@" AND local_path = ?"];
        
        if (includeStates && includeStates.count > 0) {
            [sql appendString:@" AND task_state IN ("];
            for (NSUInteger i = 0; i < includeStates.count; i++) {
                if (i > 0) [sql appendString:@", "];
                [sql appendString:@"?"];
            }
            [sql appendString:@")"];
        }
        
        [sql appendString:@" ORDER BY created_at ASC"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            
            if (parentRemotePath && parentRemotePath.length > 0) {
                sqlite3_bind_text(statement, paramIndex++, [parentRemotePath UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            if (includeStates && includeStates.count > 0) {
                for (NSNumber *state in includeStates) {
                    sqlite3_bind_int(statement, paramIndex++, (int)[state integerValue]);
                }
            }
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                const char *taskId = (const char *)sqlite3_column_text(statement, 0);
                if (taskId) {
                    [taskIds addObject:[NSString stringWithUTF8String:taskId]];
                }
            }
            sqlite3_finalize(statement);
        }
    });
    return [taskIds copy];
}

- (NSArray<QCloudSMHTaskRecord *> *)queryTaskRecordsWithLibraryId:(NSString *)libraryId
                                                            spaceId:(NSString *)spaceId
                                                             userId:(NSString *)userId
                                                    parentRemotePath:(NSString *)parentRemotePath
                                                        localPath:(NSString *)localPath
                                                               page:(nullable NSNumber *)page
                                                           pageSize:(nullable NSNumber *)pageSize
                                                          orderType:(QCloudSMHSortField)orderType
                                                     orderDirection:(QCloudSMHSortOrder)orderDirection
                                                           group:(QCloudSMHGroup)group
                                                     directoryFilter:(QCloudSMHDirectoryFilter)directoryFilter
                                                              states:(nullable NSArray<NSNumber *> *)states {
    if (!libraryId || !spaceId || !userId || !localPath) {
        return @[];
    }
    
    __block NSMutableArray<QCloudSMHTaskRecord *> *records = [NSMutableArray array];
    dispatch_sync(_databaseQueue, ^{
        NSMutableString *sql = [NSMutableString stringWithString:
            @"SELECT * FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND parent_remote_path = ? AND local_path = ?"];
        
        if (directoryFilter == QCloudSMHDirectoryOnlyDir) {
            [sql appendString:@" AND task_type = 0"];
        } else if (directoryFilter == QCloudSMHDirectoryOnlyFile) {
            [sql appendString:@" AND task_type = 1"];
        }
        
        if (states && states.count > 0) {
            [sql appendString:@" AND task_state IN ("];
            for (NSUInteger i = 0; i < states.count; i++) {
                if (i > 0) [sql appendString:@", "];
                [sql appendString:@"?"];
            }
            [sql appendString:@")"];
        }
        
        NSString *sortField = (orderType == QCloudSMHSortFieldCreatedAt) ? @"created_at" : @"updated_at";
        NSString *sortOrder = (orderDirection == QCloudSMHSortOrderAscending) ? @"ASC" : @"DESC";
        
        if (group == QCloudSMHGroupByType) {
            [sql appendFormat:@" ORDER BY task_type ASC, %@ %@", sortField, sortOrder];
        } else {
            [sql appendFormat:@" ORDER BY %@ %@", sortField, sortOrder];
        }
        
        if (page && pageSize) {
            NSUInteger offset = [page unsignedIntegerValue] * [pageSize unsignedIntegerValue];
            [sql appendFormat:@" LIMIT %lu OFFSET %lu", (unsigned long)[pageSize unsignedIntegerValue], (unsigned long)offset];
        }
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [parentRemotePath UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            if (states && states.count > 0) {
                for (NSNumber *state in states) {
                    sqlite3_bind_int(statement, paramIndex++, (int)[state integerValue]);
                }
            }
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                QCloudSMHTaskRecord *record = [self taskRecordFromStatement:statement];
                if (record) {
                    [records addObject:record];
                }
            }
            sqlite3_finalize(statement);
        }
    });
    return [records copy];
}

- (nullable QCloudSMHTaskRecord *)queryTaskRecordWithLibraryId:(NSString *)libraryId
                                                       spaceId:(NSString *)spaceId
                                                        userId:(NSString *)userId
                                                   remotePath:(NSString *)remotePath
                                                    localPath:(NSString *)localPath {
    if (!libraryId || !spaceId || !userId || !remotePath || !localPath) {
        return nil;
    }
    
    __block QCloudSMHTaskRecord *record = nil;
    dispatch_sync(_databaseQueue, ^{
        NSString *sql = @"SELECT * FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND remote_path = ? AND local_path = ?";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [userId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [remotePath UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, 5, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                record = [self taskRecordFromStatement:statement];
            }
            sqlite3_finalize(statement);
        }
    });
    return record;
}

- (NSArray<QCloudSMHTaskRecord *> *)queryDescendantTasksWithLibraryId:(NSString *)libraryId
                                                              spaceId:(NSString *)spaceId
                                                               userId:(NSString *)userId
                                                         remotePath:(NSString *)remotePath
                                                          localPath:(NSString *)localPath
                                                             page:(nullable NSNumber *)page
                                                         pageSize:(nullable NSNumber *)pageSize
                                                        orderType:(QCloudSMHSortField)orderType
                                                   orderDirection:(QCloudSMHSortOrder)orderDirection
                                                         group:(QCloudSMHGroup)group
                                                   directoryFilter:(QCloudSMHDirectoryFilter)directoryFilter
                                                            states:(nullable NSArray<NSNumber *> *)states {
    if (!libraryId || !spaceId || !userId || !remotePath || !localPath) {
        return @[];
    }
    
    __block NSMutableArray<QCloudSMHTaskRecord *> *records = [NSMutableArray array];
    dispatch_sync(_databaseQueue, ^{
        // 构建SQL查询，查询所有后代任务（子任务、子子任务等）
        // 使用LIKE实现模糊匹配来支持递归查询
        NSMutableString *sql = [NSMutableString stringWithString:
            @"SELECT * FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND local_path = ?"];
        
        // 使用LIKE匹配remote_path或parent_remote_path，找出所有后代任务
        // 例如：remotePath = "/folder"，则匹配 "/folder/%" 及其子路径
        [sql appendString:@" AND (remote_path LIKE ? OR parent_remote_path LIKE ?)"];
        
        // 任务类型筛选（与queryTaskRecordsWithLibraryId方法保持一致）
        if (directoryFilter == QCloudSMHDirectoryOnlyDir) {
            [sql appendString:@" AND task_type = 0"];
        } else if (directoryFilter == QCloudSMHDirectoryOnlyFile) {
            [sql appendString:@" AND task_type = 1"];
        }
        
        // 任务状态筛选
        if (states && states.count > 0) {
            [sql appendString:@" AND task_state IN ("];
            for (NSUInteger i = 0; i < states.count; i++) {
                if (i > 0) [sql appendString:@", "];
                [sql appendString:@"?"];
            }
            [sql appendString:@")"];
        }
        
        // 排序逻辑（与queryTaskRecordsWithLibraryId方法保持一致）
        NSString *sortField = (orderType == QCloudSMHSortFieldCreatedAt) ? @"created_at" : @"updated_at";
        NSString *sortOrder = (orderDirection == QCloudSMHSortOrderAscending) ? @"ASC" : @"DESC";
        
        if (group == QCloudSMHGroupByType) {
            [sql appendFormat:@" ORDER BY task_type ASC, %@ %@", sortField, sortOrder];
        } else {
            [sql appendFormat:@" ORDER BY %@ %@", sortField, sortOrder];
        }
        
        // 分页处理
        if (page && pageSize) {
            NSUInteger offset = [page unsignedIntegerValue] * [pageSize unsignedIntegerValue];
            [sql appendFormat:@" LIMIT %lu OFFSET %lu", (unsigned long)[pageSize unsignedIntegerValue], (unsigned long)offset];
        }
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            // LIKE模式匹配子任务
            // 例如：remotePath = "/folder"，则匹配 "/folder/%" 及其所有子路径
            NSString *descendantPattern = [remotePath stringByAppendingString:@"/%"];
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            
            // 绑定状态参数
            if (states && states.count > 0) {
                for (NSNumber *state in states) {
                    sqlite3_bind_int(statement, paramIndex++, (int)[state integerValue]);
                }
            }
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                QCloudSMHTaskRecord *record = [self taskRecordFromStatement:statement];
                if (record) {
                    [records addObject:record];
                }
            }
            sqlite3_finalize(statement);
        }
    });
    
    return [records copy];
}

#pragma mark - 批量操作

- (BOOL)batchSaveTasks:(NSArray<QCloudSMHBaseTask *> *)tasks {
    if (tasks.count == 0) {
        return YES;
    }
    
    __block BOOL success = YES;
    dispatch_sync(_databaseQueue, ^{
        char *errorMsg = NULL;
        if (sqlite3_exec(self->_database, "BEGIN TRANSACTION", NULL, NULL, &errorMsg) != SQLITE_OK) {
            QCloudLogError(@"Failed to begin transaction: %s", errorMsg);
            sqlite3_free(errorMsg);
            return;
        }
        
        for (QCloudSMHBaseTask *task in tasks) {
            if (![self saveTaskWithoutTransaction:task]) {
                success = NO;
                break;
            }
        }
        
        if (success) {
            if (sqlite3_exec(self->_database, "COMMIT", NULL, NULL, &errorMsg) != SQLITE_OK) {
                QCloudLogError(@"Failed to commit transaction: %s", errorMsg);
                sqlite3_free(errorMsg);
                success = NO;
            }
        } else {
            sqlite3_exec(self->_database, "ROLLBACK", NULL, NULL, NULL);
        }
    });
    return success;
}

- (BOOL)batchUpdateTasks:(NSArray<QCloudSMHBaseTask *> *)tasks {
    if (tasks.count == 0) {
        return YES;
    }
    
    __block BOOL success = YES;
    dispatch_sync(_databaseQueue, ^{
        char *errorMsg = NULL;
        if (sqlite3_exec(self->_database, "BEGIN TRANSACTION", NULL, NULL, &errorMsg) != SQLITE_OK) {
            QCloudLogError(@"Failed to begin transaction: %s", errorMsg);
            sqlite3_free(errorMsg);
            return;
        }
        
        for (QCloudSMHBaseTask *task in tasks) {
            if (![self updateTaskWithoutTransaction:task]) {
                success = NO;
                break;
            }
        }
        
        if (success) {
            if (sqlite3_exec(self->_database, "COMMIT", NULL, NULL, &errorMsg) != SQLITE_OK) {
                QCloudLogError(@"Failed to commit transaction: %s", errorMsg);
                sqlite3_free(errorMsg);
                success = NO;
            }
        } else {
            sqlite3_exec(self->_database, "ROLLBACK", NULL, NULL, NULL);
        }
    });
    return success;
}

#pragma mark - 聚合查询

- (NSDictionary *)aggregateDescendantTaskStatsWithLibraryId:(NSString *)libraryId
                                                    spaceId:(NSString *)spaceId
                                                     userId:(NSString *)userId
                                             rootRemotePath:(NSString *)rootRemotePath
                                                  localPath:(NSString *)localPath {
    if (!libraryId || !spaceId || !userId || !rootRemotePath || !localPath) {
        return @{};
    }
    
    __block NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    dispatch_sync(_databaseQueue, ^{        // 排除文件夹类型的任务(task_type=0)，只统计文件(task_type=1)
        NSString *sql = @"SELECT SUM(total_bytes), SUM(bytes_processed), COUNT(*), SUM(CASE WHEN task_state = 5 THEN 1 ELSE 0 END) FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND local_path = ? AND (remote_path LIKE ? OR parent_remote_path LIKE ?) AND task_type = 1";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *descendantPattern = [rootRemotePath stringByAppendingString:@"/%"];
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                int64_t totalBytes = sqlite3_column_int64(statement, 0);
                int64_t bytesProcessed = sqlite3_column_int64(statement, 1);
                int totalFiles = sqlite3_column_int(statement, 2);
                int filesProcessed = sqlite3_column_int(statement, 3); // 状态为 Completed(5) 的数量
                
                stats[@"totalBytes"] = @(totalBytes);
                stats[@"bytesProcessed"] = @(bytesProcessed);
                stats[@"totalFiles"] = @(totalFiles);
                stats[@"filesProcessed"] = @(filesProcessed);
            }
            sqlite3_finalize(statement);
        }
    });
    return stats;
}

- (NSDictionary<NSNumber *, NSNumber *> *)countDescendantTaskStatesWithLibraryId:(NSString *)libraryId
                                                                         spaceId:(NSString *)spaceId
                                                                          userId:(NSString *)userId
                                                                  rootRemotePath:(NSString *)rootRemotePath
                                                                       localPath:(NSString *)localPath {
    __block NSMutableDictionary *counts = [NSMutableDictionary dictionary];
    dispatch_sync(_databaseQueue, ^{
        NSString *sql = @"SELECT task_state, COUNT(*) FROM tasks WHERE library_id = ? AND space_id = ? AND user_id = ? AND local_path = ? AND (remote_path LIKE ? OR parent_remote_path LIKE ?) AND task_type = 1 GROUP BY task_state";
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self->_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int paramIndex = 1;
            sqlite3_bind_text(statement, paramIndex++, [libraryId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [userId UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *normalizedLocalPath = [self normalizeLocalPathForQuery:localPath];
            sqlite3_bind_text(statement, paramIndex++, [normalizedLocalPath UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString *descendantPattern = [rootRemotePath stringByAppendingString:@"/%"];
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, paramIndex++, [descendantPattern UTF8String], -1, SQLITE_TRANSIENT);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int state = sqlite3_column_int(statement, 0);
                int count = sqlite3_column_int(statement, 1);
                counts[@(state)] = @(count);
            }
            sqlite3_finalize(statement);
        }
    });
    return counts;
}

#pragma mark - 辅助方法

/**
 * 规范化本地路径（处理模拟器路径差异）
 */
- (NSString *)normalizeLocalPathForQuery:(NSString *)localPath {
    if (!localPath) {
        return nil;
    }
    if (TARGET_IPHONE_SIMULATOR) {
        return [QCloudSMHTaskIDGenerator normalizeLocalPath:[NSURL fileURLWithPath:localPath]];
    }
    return localPath;
}

- (BOOL)bindTaskParameters:(sqlite3_stmt *)statement task:(QCloudSMHBaseTask *)task {
    if (!statement || !task) {
        return NO;
    }
    
    int paramIndex = 1;
    
    // 基础字段
    sqlite3_bind_text(statement, paramIndex++, [task.taskId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, paramIndex++, (int)task.taskType);
    sqlite3_bind_int(statement, paramIndex++, (int)task.state);
    sqlite3_bind_int64(statement, paramIndex++, task.bytesProcessed);
    sqlite3_bind_int64(statement, paramIndex++, task.totalBytes);
    sqlite3_bind_int(statement, paramIndex++, task.filesProcessed);
    sqlite3_bind_int(statement, paramIndex++, task.totalFiles);
    
    // 通用属性
    sqlite3_bind_text(statement, paramIndex++, [task.libraryId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, paramIndex++, [task.spaceId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, paramIndex++, [task.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, paramIndex++, [task.remotePath UTF8String], -1, SQLITE_TRANSIENT);
    
    // 父路径
    NSString *parentRemotePath = [task.remotePath stringByDeletingLastPathComponent];
    if (parentRemotePath && parentRemotePath.length > 0) {
        sqlite3_bind_text(statement, paramIndex++, [parentRemotePath UTF8String], -1, SQLITE_TRANSIENT);
    } else {
        sqlite3_bind_null(statement, paramIndex++);
    }
    
    // 本地路径
    NSString *localPath = task.localURL.path;
    if (TARGET_IPHONE_SIMULATOR) {
        localPath = [QCloudSMHTaskIDGenerator normalizeLocalPath:task.localURL];
    }
    sqlite3_bind_text(statement, paramIndex++, [localPath UTF8String], -1, SQLITE_TRANSIENT);
    
    // 文件名
    NSString *fileName = nil;
    if ([task isKindOfClass:[QCloudSMHFileTask class]]) {
        fileName = ((QCloudSMHFileTask *)task).fileName;
    }
    if (fileName && fileName.length > 0) {
        sqlite3_bind_text(statement, paramIndex++, [fileName UTF8String], -1, SQLITE_TRANSIENT);
    } else {
        sqlite3_bind_null(statement, paramIndex++);
    }
    
    // 冲突策略和选项
    sqlite3_bind_int(statement, paramIndex++, (int)task.conflictStrategy);
    sqlite3_bind_int(statement, paramIndex++, task.enableResumeDownload ? 1 : 0);
    sqlite3_bind_int(statement, paramIndex++, task.enableCRC64Verification ? 1 : 0);
    sqlite3_bind_int(statement, paramIndex++, task.enableStart ? 1 : 0);
    
    // 启用恢复标志
    BOOL enableResume = NO;
    if ([task isKindOfClass:[QCloudSMHFolderTask class]]) {
        enableResume = ((QCloudSMHFolderTask *)task).enableResume;
    }
    sqlite3_bind_int(statement, paramIndex++, enableResume ? 1 : 0);
    
    // 文件夹特定字段
    BOOL scanCompleted = NO;
    NSString *nextMarker = nil;
    if ([task isKindOfClass:[QCloudSMHFolderTask class]]) {
        QCloudSMHFolderTask *folderTask = (QCloudSMHFolderTask *)task;
        scanCompleted = folderTask.scanCompleted;
        nextMarker = folderTask.nextMarker;
    }
    sqlite3_bind_int(statement, paramIndex++, scanCompleted ? 1 : 0);
    
    if (nextMarker && nextMarker.length > 0) {
        sqlite3_bind_text(statement, paramIndex++, [nextMarker UTF8String], -1, SQLITE_TRANSIENT);
    } else {
        sqlite3_bind_null(statement, paramIndex++);
    }
    
    // 错误信息
    [self bindErrorParameters:statement paramIndex:&paramIndex task:task];
    
    // 时间戳
    NSString *createdAtStr = [self dateStringFromTimeInterval:task.createdTime];
    if (createdAtStr && createdAtStr.length > 0) {
        sqlite3_bind_text(statement, paramIndex++, [createdAtStr UTF8String], -1, SQLITE_TRANSIENT);
    } else {
        sqlite3_bind_text(statement, paramIndex++, [[self dateStringFromDate:[NSDate date]] UTF8String], -1, SQLITE_TRANSIENT);
    }
    
    // updated_at 使用当前时间
    NSString *updatedAtStr = [self dateStringFromDate:[NSDate date]];
    sqlite3_bind_text(statement, paramIndex++, [updatedAtStr UTF8String], -1, SQLITE_TRANSIENT);
    
    return YES;
}

- (void)bindErrorParameters:(sqlite3_stmt *)statement paramIndex:(int *)paramIndex task:(QCloudSMHBaseTask *)task {
    NSInteger errorCode = 0;
    NSString *errorMessage = nil;
    if (task.error) {
        errorCode = task.error.code;
        errorMessage = task.error.localizedDescription;
    }
    sqlite3_bind_int(statement, (*paramIndex)++, (int)errorCode);
    
    if (errorMessage && errorMessage.length > 0) {
        sqlite3_bind_text(statement, (*paramIndex)++, [errorMessage UTF8String], -1, SQLITE_TRANSIENT);
    } else {
        sqlite3_bind_null(statement, (*paramIndex)++);
    }
}

- (QCloudSMHTaskRecord *)taskRecordFromStatement:(sqlite3_stmt *)statement {
    if (!statement) {
        return nil;
    }
    
    QCloudSMHTaskRecord *record = [[QCloudSMHTaskRecord alloc] init];
    
    // 基础字段
    const char *taskId = (const char *)sqlite3_column_text(statement, 0);
    record.taskId = taskId ? [NSString stringWithUTF8String:taskId] : nil;
    
    record.taskType = sqlite3_column_int(statement, 1);
    record.taskState = sqlite3_column_int(statement, 2);
    record.bytesProcessed = sqlite3_column_int64(statement, 3);
    record.totalBytes = sqlite3_column_int64(statement, 4);
    record.filesProcessed = sqlite3_column_int(statement, 5);
    record.totalFiles = sqlite3_column_int(statement, 6);
    
    // 通用属性
    const char *libraryId = (const char *)sqlite3_column_text(statement, 7);
    record.libraryId = libraryId ? [NSString stringWithUTF8String:libraryId] : nil;
    
    const char *spaceId = (const char *)sqlite3_column_text(statement, 8);
    record.spaceId = spaceId ? [NSString stringWithUTF8String:spaceId] : nil;
    
    const char *userId = (const char *)sqlite3_column_text(statement, 9);
    record.userId = userId ? [NSString stringWithUTF8String:userId] : nil;
    
    const char *remotePath = (const char *)sqlite3_column_text(statement, 10);
    record.remotePath = remotePath ? [NSString stringWithUTF8String:remotePath] : nil;
    
    const char *parentRemotePath = (const char *)sqlite3_column_text(statement, 11);
    record.parentRemotePath = parentRemotePath ? [NSString stringWithUTF8String:parentRemotePath] : nil;
    
    const char *localPath = (const char *)sqlite3_column_text(statement, 12);
    record.localPath = localPath ? [NSString stringWithUTF8String:localPath] : nil;
    if (TARGET_IPHONE_SIMULATOR && record.localPath) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = documentPaths.firstObject;
        if (documentsPath) {
            record.localPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:record.localPath];
        }
    }
    
    const char *fileName = (const char *)sqlite3_column_text(statement, 13);
    record.fileName = fileName ? [NSString stringWithUTF8String:fileName] : nil;
    
    record.conflictStrategy = sqlite3_column_int(statement, 14);
    record.enableResumeDownload = sqlite3_column_int(statement, 15) == 1;
    record.enableCRC64Verification = sqlite3_column_int(statement, 16) == 1;
    record.enableStart = sqlite3_column_int(statement, 17) == 1;
    record.enableResume = sqlite3_column_int(statement, 18) == 1;
    record.scanCompleted = sqlite3_column_int(statement, 19) == 1;
    
    const char *nextMarker = (const char *)sqlite3_column_text(statement, 20);
    record.nextMarker = nextMarker ? [NSString stringWithUTF8String:nextMarker] : nil;
    
    record.errorCode = sqlite3_column_int(statement, 21);
    
    const char *errorMessage = (const char *)sqlite3_column_text(statement, 22);
    record.errorMessage = errorMessage ? [NSString stringWithUTF8String:errorMessage] : nil;
    
    // 时间戳
    const char *createdAtStr = (const char *)sqlite3_column_text(statement, 23);
    if (createdAtStr) {
        record.createdAt = [self dateFromSQLiteString:[NSString stringWithUTF8String:createdAtStr]];
    }
    
    const char *updatedAtStr = (const char *)sqlite3_column_text(statement, 24);
    if (updatedAtStr) {
        record.updatedAt = [self dateFromSQLiteString:[NSString stringWithUTF8String:updatedAtStr]];
    }
    
    return record;
}

- (NSString *)dateStringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self dateStringFromDate:date];
}

- (NSString *)dateStringFromDate:(NSDate *)date {
    if (!date) {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    return [formatter stringFromDate:date];
}

- (NSDate *)dateFromSQLiteString:(NSString *)dateString {
    if (!dateString || dateString.length == 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    return [formatter dateFromString:dateString];
}

@end
