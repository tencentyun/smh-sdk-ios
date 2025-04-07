//
//
//  QCloudSMHPutDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于创建目录或相簿
 */
@interface QCloudSMHPutDirectoryRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
 */
@property (nonatomic,strong)NSString *dirPath;

@property (nonatomic,assign)BOOL withInode;

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
