//
//  QCloudSMHDeleteDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHDeleteResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 删除目录或相簿
 */
@interface QCloudSMHDeleteDirectoryRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar
 */
@property (nonatomic,strong)NSString *dirPath;

/**
 当媒体库开启回收站时，则该参数指定将文件移入回收站还是永久删除文件，1: 永久删除，0: 移入回收站，默认为 0；
 */
@property (nonatomic,assign)NSInteger permanent;
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
