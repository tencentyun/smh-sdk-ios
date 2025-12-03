//
//  QCloudSMHFileTask.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>
#import "QCloudSMHBaseTask.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudCOSSMHDownloadObjectRequest.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 文件任务

/**
 * 文件任务
 */
@interface QCloudSMHFileTask : QCloudSMHBaseTask

#pragma mark - 下载配置属性

/**
 * 下载请求对象
 * 用于执行实际的文件下载操作，包含下载URL、进度回调等
 */
@property (nonatomic, strong, nullable, readonly) QCloudCOSSMHDownloadObjectRequest *downloadRequest;

/**
 * 文件名
 * 下载后保存的文件名，可能因冲突策略而改变
 */
@property (nonatomic, copy) NSString *fileName;


#pragma mark - 初始化

/**
 * 初始化文件下载任务
 * 创建一个新的文件任务对象，用于管理单个文件的下载
 *
 * @param libraryId 库ID，标识文件所属的库
 * @param spaceId 空间ID，标识文件所属的空间
 * @param userId 用户ID，标识操作用户
 * @param remotePath 远程文件路径，如 "/folder/file.txt"
 * @param localURL 本地保存文件夹URL，文件将保存到此目录
 * @param fileSize 文件大小（字节），用于进度计算
 * @param fileName 文件名，下载后保存的文件名
 * @param enableResumeDownload 是否启用断点续传，YES时支持暂停后继续
 * @param enableCRC64Verification 是否启用CRC64校验，YES时验证下载文件完整性
 * @param conflictStrategy 文件冲突处理策略（覆盖、重命名、询问）
 * @return 初始化后的文件任务对象
 */
- (instancetype)initWithLibraryId:(NSString *)libraryId
                          spaceId:(NSString *)spaceId
                           userId:(NSString *)userId
                  remotePath:(NSString *)remotePath
                    localFileURL:(NSURL *)localURL
                       fileSize:(int64_t)fileSize
                         fileName:(NSString *)fileName
             enableResumeDownload:(BOOL)enableResumeDownload
          enableCRC64Verification:(BOOL)enableCRC64Verification
                conflictStrategy:(QCloudSMHConflictStrategyEnum)conflictStrategy;

@end

NS_ASSUME_NONNULL_END
