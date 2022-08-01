//
//  QCloudSMHCrossSpaceCopyDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHRenameResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 复制文件
 */
@interface QCloudSMHCrossSpaceCopyDirectoryRequest : QCloudSMHBizRequest
/**
 目标目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar_new；
 */
@property (nonatomic,strong)NSString *dirPath;

/**
 ConflictResolutionStrategy: 最后一级目录冲突时的处理方式，
    ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，
    rename: 冲突时自动重命名最后一级目录，
    默认为 ask；
 */
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 被复制的源目录或相簿路径；
 */
@property (nonatomic,strong)NSString *from;

/**
 被复制的源空间 SpaceId；
 */
@property (nonatomic,strong)NSString *fromSpaceId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHCopyResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
