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

/// 字符串，文件大小，用于秒传，可选参数；
@property (nonatomic,strong)NSString * fileSize;

/// SMH 定义的文件的 fullHash 值，用于秒传，可选参数，具体算法如下：
@property (nonatomic,strong)NSString * fullHash;

/// 文件前 1M 的 fullHash 值，用于秒传，可选参数；
/// 文件开头 1M 的 sha256 哈希值
@property (nonatomic,strong)NSString * beginningHash;

@property (nonatomic,strong)NSString * createionDate;

/**
 文件自定义的分类,string类型,最大长度16字节， 可选，用户可通过更新文件接口修改文件的分类，也可以根据文件后缀预定义文件的分类信息。
 */
@property (nonatomic,strong)NSString * category;

/**
 文件对应的本地创建时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong)NSString * localCreationTime;

/**
 文件对应的本地修改时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong)NSString * localModificationTime;

/**
 文件标签列表, 比如 ["动物", "大象", "亚洲象"]
 */
@property (nonatomic,strong)NSArray <NSString *> * labels;


/// 文件名冲突时的处理方式，默认为 rename
/// ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，
/// rename: 冲突时自动重命名文件
/// overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，；
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

@property (nonatomic,strong)NSString * partNumberRange;


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
