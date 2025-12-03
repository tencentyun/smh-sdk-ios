//
//  QCloudSMHTaskManagerConfig.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/04
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 任务管理器配置类
 * 用于管理任务管理器的缓存池配置
 *
 */
@interface QCloudSMHTaskManagerConfig : NSObject

#pragma mark - 缓存池配置

/**
 * 文件夹缓存池最大容量（默认：50）
 * 文件夹任务执行时间长，不需要太多并发
 */
@property (nonatomic, assign) NSInteger maxFolderCacheSize;

/**
 * 文件缓存池最大容量（默认：10）
 * 文件任务执行快，可以支持高并发
 */
@property (nonatomic, assign) NSInteger maxFileCacheSize;

@end

NS_ASSUME_NONNULL_END
