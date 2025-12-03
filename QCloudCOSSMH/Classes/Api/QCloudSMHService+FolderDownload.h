//
//  QCloudSMHService+FolderDownload.h
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/13.
//

#import "QCloudSMHService.h"
#import "QCloudSMHTaskManagerConfig.h"
#import "QCloudSMHDownloadRequest.h"
#import "QCloudSMHDownloadDetail.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHTaskError.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 文件夹下载进度回调块
 * 用于监听文件夹/文件下载的实时进度，包括字节数和文件数统计
 *
 * @param path 文件/文件夹远程路径
 * @param type 任务类型（文件或文件夹）
 * @param bytesProcessed 已处理字节数
 * @param totalBytes 总字节数
 * @param completedFiles 已完成文件数
 * @param totalFiles 总文件数
 */
typedef void (^QCloudSMHFolderProgressCallback)(NSString *path, QCloudSMHTaskType type, int64_t bytesProcessed, int64_t totalBytes, int completedFiles, int totalFiles);

/**
 * 文件夹下载状态变化回调块
 * 用于监听文件夹/文件下载任务的状态变化，包括扫描、下载、暂停、完成等状态
 *
 * @param path 文件/文件夹远程路径
 * @param type 任务类型（文件或文件夹）
 * @param state 任务状态（扫描中、下载中、已暂停、已完成、已失败等）
 * @param error 错误信息（任务失败时包含错误详情，成功时为nil）
 */
typedef void (^QCloudSMHFolderStateChangedCallback)(NSString *path, QCloudSMHTaskType type, QCloudSMHTaskState state, NSError *error);



@interface QCloudSMHService (FolderDownload)

/**
 * 初始化文件夹/文件下载模块
 * 必须在使用文件夹下载功能前调用，用于订阅任务管理器的事件
 */
- (void)setupDownload;

/**
 * 解除初始化
 * 取消订阅任务管理器的事件
 */
- (void)teardownDownload;

/**
 * 更新文件夹下载配置
 * 用于动态调整下载任务的并发数、超时时间等配置参数
 *
 * @param config 配置对象，包含并发数、超时等参数
 */
- (void)updateDownloadFolerConfig:(QCloudSMHTaskManagerConfig *)config;

/**
 * 启动文件夹/文件下载任务
 * 创建下载任务、保存到数据库、加入缓存并启动下载
 *
 * @param request 下载请求对象，包含库ID、空间ID、远程路径、本地保存路径等信息
 */
- (void)downloadFolder:(QCloudSMHDownloadRequest *)request;

/**
 * 查询单个文件夹/文件的下载记录
 * 根据请求信息从数据库查询对应的下载任务详情
 *
 * @param request 下载请求对象，用于定位特定的下载任务
 * @return 下载记录对象，包含任务状态、进度、错误信息等
 */
- (QCloudSMHDownloadDetail *)getFolderDownloadDetail:(QCloudSMHDownloadRequest *)request;

/**
 * 分页查询文件夹目录下的所有下载记录
 * 支持多条件筛选、排序和分组，用于展示下载列表
 *
 * @param request 下载请求对象，指定查询的文件夹路径
 * @param page 页码（从0开始），为nil时查询第一页
 * @param pageSize 每页大小，为nil时使用默认值
 * @param orderType 排序字段（如更新时间、创建时间等）
 * @param orderDirection 排序方向（升序或降序）
 * @param group 分组类型（按文件类型、状态等分组）
 * @param directoryFilter 筛选方式（仅文件、仅文件夹、全部）
 * @param states 状态过滤数组（为nil查询所有状态，如@[@(QCloudSMHTaskStateCompleted)]）
 * @return 下载记录对象数组，包含符合条件的所有任务
 */
- (NSArray<QCloudSMHDownloadDetail *> *)getFolderDownloadDetails:(QCloudSMHDownloadRequest *)request
                                                        page:(nullable NSNumber *)page
                                                    pageSize:(nullable NSNumber *)pageSize
                                                   orderType:(QCloudSMHSortField)orderType
                                              orderDirection:(QCloudSMHSortOrder)orderDirection
                                                    grouping:(QCloudSMHGroup)group
                                              directoryFilter:(QCloudSMHDirectoryFilter)directoryFilter
                                                      states:(nullable NSArray<NSNumber *> *)states;


/**
 * 监听文件夹/文件下载的进度和状态变化
 *
 * @param request 下载请求对象，用于标识要监听的任务
 * @param error 错误信息，如果监听失败，将返回错误信息
 * @param progress 进度回调块，在下载进度更新时调用
 * @param stateChanged 状态变化回调块，在任务状态改变时调用
 */
- (BOOL)observerFolderDownloadForRequest:(QCloudSMHDownloadRequest *)request
                                   error:(NSError * _Nullable * _Nullable)error
                             progress:(QCloudSMHFolderProgressCallback)progress
                            stateChanged:(QCloudSMHFolderStateChangedCallback)stateChanged;


/**
 * 移除指定下载任务的监听回调
 * 停止接收该任务的进度和状态更新通知
 *
 * @param request 下载请求对象，用于标识要移除监听的任务
 */
- (void)removeObserverFolderDownloadForRequest:(QCloudSMHDownloadRequest *)request;


@end

NS_ASSUME_NONNULL_END
