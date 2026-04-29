//
//  QCloudSMHGetDirectoryStatsRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHDirectoryStatsInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查询目录统计数据
 用于查询目录的统计数据，包括子目录数量、文件数量、包含的文件总大小。
 可以查询普通目录的统计结果、回收站目录的统计结果、某个目录的历史版本的统计结果。
 文件写操作和查询目录统计结果之间存在秒级时延，以最新查询结果为准。
 */
@interface QCloudSMHGetDirectoryStatsRequest : QCloudSMHBizRequest

/// 文件路径，对于多级目录，使用斜杠(/)分隔，例如 foo/bar
@property (nonatomic, strong) NSString *filePath;

/// 统计类型：normal 表示普通目录统计量，recycle 表示回收站目录统计量，history 表示目录的历史版本统计量，必选参数
@property (nonatomic, strong) NSString *statsType;

/// 回收站项目 ID，查询回收站的统计量时，为必选参数（根目录除外），可选参数
@property (nonatomic, strong) NSString *recycledId;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHDirectoryStatsInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
