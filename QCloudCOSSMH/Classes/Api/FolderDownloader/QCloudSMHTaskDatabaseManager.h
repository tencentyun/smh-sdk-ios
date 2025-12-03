//
//  QCloudSMHTaskDatabaseManager.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/3
//

#import <Foundation/Foundation.h>
#import "QCloudSMHBaseTask.h"
#import "QCloudSMHTaskRecord.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 数据库管理类

/**
 * 任务数据库管理器
 * 负责管理SQLite数据库中的下载任务记录
 * 提供任务的增删改查、批量操作、查询等功能
 */
@interface QCloudSMHTaskDatabaseManager : NSObject

#pragma mark - 单例模式

/**
 * 获取数据库管理器单例
 * @return 数据库管理器实例
 */
+ (instancetype)sharedManager;

#pragma mark - 数据库初始化

/**
 * 初始化数据库
 * 创建数据库文件、建表、初始化数据库连接
 * @return YES 表示初始化成功，NO 表示失败
 */
- (BOOL)initializeDatabase;


#pragma mark - 任务CRUD操作

/**
 * 保存任务到数据库
 * 将新创建的任务记录插入数据库
 *
 * @param task 要保存的任务对象
 * @return YES 表示保存成功，NO 表示失败
 */
- (BOOL)saveTask:(QCloudSMHBaseTask *)task;

/**
 * 更新任务状态和进度
 * 更新数据库中已存在的任务记录
 *
 * @param task 要更新的任务对象
 * @return YES 表示更新成功，NO 表示失败
 */
- (BOOL)updateTask:(QCloudSMHBaseTask *)task;

/**
 * 根据任务ID获取任务记录
 * 从数据库查询指定ID的任务记录
 *
 * @param taskId 任务ID
 * @return 任务记录对象，如果不存在则返回nil
 */
- (QCloudSMHTaskRecord *)getTaskById:(NSString *)taskId;

/**
 * 判断数据库中是否存在指定ID的任务记录
 * 轻量级查询，仅检查记录是否存在，不返回完整数据
 *
 * @param taskId 任务ID
 * @return YES 表示存在，NO 表示不存在
 */
- (BOOL)isTaskExistsById:(NSString *)taskId;

/**
 * 删除任务记录
 * 从数据库删除指定ID的任务记录
 *
 * @param taskId 任务ID
 * @return YES 表示删除成功，NO 表示失败
 */
- (BOOL)deleteTaskById:(NSString *)taskId;

/**
 * 删除所有任务记录
 * 清空数据库中的所有任务记录，用于测试环境重置
 * 注意：此方法会删除所有数据，请谨慎使用
 *
 * @return YES 表示删除成功，NO 表示失败
 */
- (BOOL)deleteAllTasks;

/**
 * 删除所有后代任务记录
 * 根据当前任务的 remotePath 删除所有子孙记录
 * 支持多层级递归删除，使用 LIKE 模式匹配所有后代路径
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remotePath 当前任务的远程路径，用于匹配所有子孙任务
 * @param localPath 本地路径
 * @return YES 表示删除成功，NO 表示失败
 */
- (BOOL)deleteDescendantTasksWithLibraryId:(NSString *)libraryId
                                   spaceId:(NSString *)spaceId
                                    userId:(NSString *)userId
                              remotePath:(NSString *)remotePath
                               localPath:(NSString *)localPath;

/**
 * 获取符合条件的任务ID列表
 * 支持按库、空间、用户、路径和状态进行复合查询
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param parentRemotePath 父目录路径，用于查询该目录下的所有任务
 * @param localPath 本地路径
 * @param includeStates 包含的状态数组，为nil时表示包含所有状态
 * @return 符合条件的任务ID数组，按创建时间升序排列
 */
- (NSArray<NSString *> *)getTaskIdsWithLibraryId:(NSString *)libraryId
                                           spaceId:(NSString *)spaceId
                                            userId:(NSString *)userId
                               parentRemotePath:(NSString *)parentRemotePath
                                      localPath:(NSString *)localPath
                                  includeStates:(nullable NSArray<NSNumber *> *)includeStates;

/**
 * 分页查询任务记录列表
 * 支持多条件筛选、排序、分组，用于展示下载列表
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param parentRemotePath 父目录路径，用于查询该目录下的所有任务
 * @param localPath 本地路径
 * @param page 页码（从0开始），为nil时表示获取全部
 * @param pageSize 每页大小，为nil时表示获取全部
 * @param orderType 排序字段（如更新时间、创建时间等）
 * @param orderDirection 排序方向（升序或降序）
 * @param group 分组类型（平铺或按文件夹/文件分组）
 * @param directoryFilter 筛选方式（仅文件、仅文件夹、全部）
 * @param states 状态过滤数组，为nil时表示返回所有状态
 * @return 符合条件的任务记录数组
 */
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
                                                              states:(nullable NSArray<NSNumber *> *)states;

/**
 * 查询当前目录的子任务、子子任务（包含递归的所有后代任务）
 * 根据库、空间、用户、远程路径和本地路径查询该目录下的所有子任务和子子任务
 * 支持递归查询所有后代节点，查询条件与queryTaskRecordsWithLibraryId:...方法保持一致
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remotePath 当前目录的远程路径
 * @param localPath 本地路径
 * @param page 页码（从0开始），为nil时表示获取全部
 * @param pageSize 每页大小，为nil时表示获取全部
 * @param orderType 排序字段（如更新时间、创建时间等）
 * @param orderDirection 排序方向（升序或降序）
 * @param group 分组类型（平铺或按文件夹/文件分组）
 * @param directoryFilter 筛选方式（仅文件、仅文件夹、全部）
 * @param states 状态过滤数组，为nil时表示返回所有状态
 * @return 当前目录下所有子任务和子子任务的记录数组
 */
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
                                                            states:(nullable NSArray<NSNumber *> *)states;

/**
 * 查询单个任务记录
 * 根据库、空间、用户、远程路径和本地路径查询特定的任务
 *
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remotePath 远程文件/文件夹路径
 * @param localPath 本地路径
 * @return 符合条件的任务记录，如果不存在则返回nil
 */
- (nullable QCloudSMHTaskRecord *)queryTaskRecordWithLibraryId:(NSString *)libraryId
                                                       spaceId:(NSString *)spaceId
                                                        userId:(NSString *)userId
                                                   remotePath:(NSString *)remotePath
                                                    localPath:(NSString *)localPath;


#pragma mark - 批量操作

/**
 * 批量保存任务
 * 一次性将多个任务记录插入数据库，提高效率
 *
 * @param tasks 要保存的任务对象数组
 * @return YES 表示保存成功，NO 表示失败
 */
- (BOOL)batchSaveTasks:(NSArray<QCloudSMHBaseTask *> *)tasks;

/**
 * 批量更新任务
 * 一次性更新多个任务记录，提高效率
 *
 * @param tasks 要更新的任务对象数组
 * @return YES 表示更新成功，NO 表示失败
 */
- (BOOL)batchUpdateTasks:(NSArray<QCloudSMHBaseTask *> *)tasks;


#pragma mark - 聚合查询

/**
 * 统计指定文件夹下所有后代任务的聚合数据
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param rootRemotePath 根文件夹路径（查询其下所有后代）
 * @param localPath 本地路径
 * @return 包含 totalBytes, bytesProcessed, totalFiles, filesProcessed 的字典
 */
- (NSDictionary *)aggregateDescendantTaskStatsWithLibraryId:(NSString *)libraryId
                                                    spaceId:(NSString *)spaceId
                                                     userId:(NSString *)userId
                                             rootRemotePath:(NSString *)rootRemotePath
                                                  localPath:(NSString *)localPath;

/**
 * 统计指定文件夹下各状态的任务数量
 * @return 字典 key为状态(NSNumber)，value为数量(NSNumber)
 */
- (NSDictionary<NSNumber *, NSNumber *> *)countDescendantTaskStatesWithLibraryId:(NSString *)libraryId
                                                                         spaceId:(NSString *)spaceId
                                                                          userId:(NSString *)userId
                                                                  rootRemotePath:(NSString *)rootRemotePath
                                                                       localPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
