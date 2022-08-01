//
//  QCloudSMHPutObjectLinkRequest.h
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHPutObjectLinkInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 创建符号链接
 */
@interface QCloudSMHPutObjectLinkRequest : QCloudSMHBizRequest


/// 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file_new.docx ；
@property (nonatomic,strong)NSString * filePath;

/// 文件名冲突时的处理方式，默认为 rename
/// ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，
/// rename: 冲突时自动重命名文件
/// overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，；
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

/// 符号链接指向的源文件绝对路径；
@property (nonatomic,strong)NSString * linkTo;


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHPutObjectLinkInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
