//
//  QCloudSMHBatchGetFileInfoRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHContentInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 批量获取文件详情（同一空间）
 */
@interface QCloudSMHBatchGetFileInfoRequest : QCloudSMHUserBizRequest


/// 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar
@property (nonatomic,copy)NSArray *dirPaths;

/// SpaceId: 空间 ID
@property (nonatomic,strong)NSString *spaceId;

-(void)setFinishBlock:(void (^ _Nullable)( NSArray <QCloudSMHContentInfo *> * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
