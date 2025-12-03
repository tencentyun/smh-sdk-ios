//
//  QCloudSMHTaskManagerConfig.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/11/04
//

#import "QCloudSMHTaskManagerConfig.h"

@interface QCloudSMHTaskManagerConfig ()


@end

@implementation QCloudSMHTaskManagerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        // 双缓存池配置
        _maxFolderCacheSize = 10;               // 文件夹缓存池：最多50个任务
        _maxFileCacheSize = 10;                 // 文件缓存池：最多10个任务
    }
    return self;
}

@end
