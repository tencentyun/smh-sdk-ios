//
//  QCloudSMHRenameDirecotryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHRenameResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 重命名文件或文件夹
 */
@interface QCloudSMHRenameDirectoryRequest : QCloudSMHBizRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar
 */
@property (nonatomic,strong)NSString *dirPath;

/**
 定被重命名或移动的源目录路径或相簿名
 */
@property (nonatomic,strong)NSString *from;

/**
 最后一级目录冲突时的处理方式，
 ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，
 rename: 冲突时自动重命名最后一级目录，默认为 ask；；
 */
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 是否移动文件夹权限，true 移动，false 不移动；
 */
@property (nonatomic,assign)BOOL moveAuthority;
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END

