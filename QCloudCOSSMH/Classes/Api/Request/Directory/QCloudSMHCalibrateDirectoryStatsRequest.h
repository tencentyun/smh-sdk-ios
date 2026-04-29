//
//  QCloudSMHCalibrateDirectoryStatsRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCalibrateDirectoryStatsResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 修正目录统计数据
 用于修正目录统计数据。
 目录统计可能因为网络抖动等不确定因素，与实际值存在差异，可以调用此接口对统计值进行修正。
 修正期间，尽量减少对该目录及其子目录的写操作，否则修正结果存在偏差。
 此接口有频控限制，请勿频繁调用。
 要求权限：admin、space_admin。
 */
@interface QCloudSMHCalibrateDirectoryStatsRequest : QCloudSMHBizRequest

/// 文件路径，对于多级目录，使用斜杠(/)分隔，例如 foo/bar
@property (nonatomic, strong) NSString *filePath;

/// 统计类型：normal 表示普通目录统计量，recycle 表示回收站目录统计量，history 表示目录的历史版本统计量，必选参数
@property (nonatomic, strong) NSString *statsType;

/// 回收站项目 ID，修正回收站的统计量时，为必选参数（根目录除外），可选参数
@property (nonatomic, strong) NSString *recycledId;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHCalibrateDirectoryStatsResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
