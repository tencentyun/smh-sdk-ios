//
//  QCloudSMHDownloadDetail.h
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/20.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"

@class QCloudSMHTaskRecord;
NS_ASSUME_NONNULL_BEGIN

/**
 * 文件夹/文件下载详情对象
 * 用于展示下载任务的详细信息，包括进度、状态、路径等
 * 由数据库记录转换而来，提供只读属性
 */
@interface QCloudSMHDownloadDetail : NSObject

/**
 * 远程文件/文件夹路径
 * 如 "/folder/file.txt" 或 "/folder/subfolder"
 */
@property (nonatomic, copy, readonly) NSString *remotePath;

/**
 * 本地保存的完整路径
 * 包含本地根目录、远程路径和文件名
 */
@property (nonatomic, copy, readonly) NSString *localPath;

/**
 * 已下载的字节数
 * 用于计算下载进度百分比
 */
@property (nonatomic, assign, readonly) NSInteger bytesProcessed;

/**
 * 总字节数
 * 文件/文件夹的总大小
 */
@property (nonatomic, assign, readonly) NSInteger totalBytes;

/**
 * 已完成的文件数
 * 用于计算文件下载进度
 */
@property (nonatomic, assign, readonly) NSInteger filesProcessed;

/**
 * 总文件数
 * 文件夹中的总文件数（包括子文件夹中的文件）
 */
@property (nonatomic, assign, readonly) NSInteger totalFiles;

/**
 * 是否为文件
 * YES 表示单个文件下载，NO 表示文件夹下载
 */
@property (nonatomic, assign, readonly) BOOL isFile;

/**
 * 库ID
 * 标识文件所属的库
 */
@property (nonatomic, copy, readonly) NSString *libraryId;

/**
 * 空间ID
 * 标识文件所属的空间
 */
@property (nonatomic, copy, readonly) NSString *spaceId;

/**
 * 用户ID
 * 标识操作用户
 */
@property (nonatomic, copy, readonly) NSString *userId;

/**
 * 下载状态
 */
@property (nonatomic, assign, readonly) QCloudSMHTaskState state;

/**
 * 下载时间
 */
@property (nonatomic, copy, readonly) NSString *createTime;

/**
 * 下载更新时间
 */
@property (nonatomic, copy, readonly) NSString *updateTime;

/**
 * 错误信息
 */
@property (nonatomic, copy, readonly) NSError *error;

/**
 * 根据数据库任务记录初始化下载详情
 * 将数据库记录转换为可展示的下载详情对象
 *
 * @param record 数据库任务记录对象
 * @return 初始化后的下载详情对象，如果记录为nil则返回nil
 */
- (instancetype)initWithTaskRecord:(QCloudSMHTaskRecord *)record;

@end


NS_ASSUME_NONNULL_END
