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

/**
 文件内容的 Cas 标识，可选参数。当 conflict_resolution_strategy 为 overwrite 并且 ContentCas 不为空时，
 只有当文件存在、并且 cas 匹配，复制文件的操作才会继续进行，否则会返回 409 状态码，错误码为 ContentCasConflict；
 */
@property (nonatomic, strong, nullable) NSString *contentCas;

/**
 是否返回文件内容的 Cas 标识，0 或 1，可选，默认不返回；
 */
@property (nonatomic, assign) BOOL withContentCas;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
