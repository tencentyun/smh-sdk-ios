//
//  QCloudSMHConvertFileRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 文档转码，当前仅支持 doc/docx 转 pdf
 */
@interface QCloudSMHConvertFileRequest : QCloudSMHBizRequest

/// 目标文件路径（转码后的 PDF 文件路径，必须以 .pdf 结尾）
@property (nonatomic, strong) NSString *filePath;

/// 源文件路径（.doc/.docx 文件），必选参数
@property (nonatomic, strong) NSString *convertFrom;

/**
 文件名冲突时的处理方式，默认为 rename
 ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码
 rename: 冲突时自动重命名文件
 overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件
 */
@property (nonatomic, assign) QCloudSMHConflictStrategyEnum conflictStrategy;

- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
