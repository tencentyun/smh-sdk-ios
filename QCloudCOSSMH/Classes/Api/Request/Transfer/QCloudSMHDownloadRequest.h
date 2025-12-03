//
//  QCloudSMHDownloadRequest.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHBaseTask.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * 文件夹/文件下载请求对象
 * 用于配置和管理文件夹或文件的下载任务
 */
@interface QCloudSMHDownloadRequest : NSObject

#pragma mark - 下载配置参数

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

/**
 * 远程文件/文件夹路径
 * 如 "/folder/subfolder" 或 "/folder/file.txt"
 */
@property (nonatomic, copy) NSString *path;

/**
 * 本地保存文件夹URL
 * 下载的文件将保存到此目录
 */
@property (nonatomic, strong) NSURL *localURL;

/**
 * 下载类型
 * 标识是文件下载还是文件夹下载
 */
@property (nonatomic, assign) QCloudSMHTaskType type;

/**
 * 文件冲突解决策略
 * 默认值：QCloudSMHConflictStrategyEnumOverWrite（覆盖）
 * 其他选项：重命名、询问
 */
@property (nonatomic, assign) QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 * 是否启用断点续传
 * 默认值：YES
 * 启用时支持暂停后继续下载
 */
@property (nonatomic, assign) BOOL enableResumeDownload;

/**
 * 是否启用CRC64校验
 * 默认值：YES
 * 启用时验证下载文件的完整性
 */
@property (nonatomic, assign) BOOL enableCRC64Verification;



#pragma mark - 初始化方法

/**
 * 初始化文件夹/文件下载请求
 * 创建一个新的下载请求对象
 *
 * @param libraryId 库ID，标识文件所属的库
 * @param spaceId 空间ID，标识文件所属的空间
 * @param userId 用户ID，标识操作用户
 * @param path 远程文件/文件夹路径，如 "/folder/file.txt"
 * @param type 下载类型，QCloudSMHTaskTypeFile 或 QCloudSMHTaskTypeFolder
 * @param localURL 本地保存文件夹URL，下载的文件将保存到此目录
 *
 * @return 初始化后的下载请求对象
 */
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                             path:(NSString *)path
                             type:(QCloudSMHTaskType)type
                         localURL:(NSURL *)localURL;


#pragma mark - 任务管理方法

/**
 * 暂停文件夹/文件下载任务
 * 暂停后可以通过 resume 继续下载
 */
- (void)pause;

/**
 * 继续文件夹/文件下载任务
 * 恢复之前暂停的下载任务
 */
- (void)resume;

/**
 * 取消文件夹/文件下载任务
 * 取消后会删除已下载的部分文件
 */
- (void)cancel;

/**
 * 删除文件夹/文件下载任务
 * 删除任务记录和已下载的文件
 */
- (void)delete;

/**
 * 获取请求ID
 * 用于唯一标识该下载请求，由库ID、空间ID、用户ID、路径和本地URL组合生成
 * @return 请求ID字符串
 */
- (NSString *)requestId;

@end

NS_ASSUME_NONNULL_END
