//
//  QCloudSMHUploadPartRequest.h
//  QCloudSMHUploadPartRequest
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHInitUploadInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHUploadPartRequest : QCloudSMHBizRequest

/// 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file_new.docx ；
@property (nonatomic,strong)NSString * filePath;


/// 文件大小
@property (nonatomic,strong)NSString * fileSize;


/// 文件名冲突时的处理方式，默认为 rename
/// ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，
/// rename: 冲突时自动重命名文件
/// overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，；
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

@property (nonatomic,strong)NSString * partNumberRange;


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
