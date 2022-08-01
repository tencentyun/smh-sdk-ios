//
//  QCloudSMHHeadDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 检查目录或相簿状态
 */
@interface QCloudSMHHeadDirectoryRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
 */
@property (nonatomic,strong)NSString *dirPath;

@end

NS_ASSUME_NONNULL_END
