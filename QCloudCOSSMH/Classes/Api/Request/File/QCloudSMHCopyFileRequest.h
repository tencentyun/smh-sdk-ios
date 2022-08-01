//
//  QCloudSMHCopyFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHRenameResult.h"
#import "QCloudSMHConflictStrategyEnumType.h"
NS_ASSUME_NONNULL_BEGIN

/**
 复制文件
 */
@interface QCloudSMHCopyFileRequest : QCloudSMHBizRequest

/**
 完整文件路径，例如 foo/bar/file_new.docx
 */
@property (nonatomic,strong)NSString *filePath;

/**
 文件名冲突时的处理方式，默认为 rename
 ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，r
 ename: 冲突时自动重命名文件overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，；
 */
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

/**
 定被重命名或移动的源目录路径或相簿名
 */
@property (nonatomic,strong)NSString *from;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
