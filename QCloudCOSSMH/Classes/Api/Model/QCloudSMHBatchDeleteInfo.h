//
//  QCloudSMHBatchDeleteInfo.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHBatchDeleteInfo : NSObject

/// 被删除的目录、相簿或文件路径；
@property (nonatomic,strong)NSString *path;

/// 当开启回收站时，则该参数指定将文件移入回收站还是永久删除文件，true: 永久删除，false: 移入回收站，默认为 false
@property (nonatomic,assign)BOOL permanent;

@end

NS_ASSUME_NONNULL_END
