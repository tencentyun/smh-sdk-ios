//
//  QCloudSMHPutObjectRequest.h
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//
/*
    PUT 简单上传指使用 HTTP PUT 请求上传一个文件，请求体即为文件的内容；
    调用该接口将返回一系列用于 PUT 简单上传请求和确认上传完成的参数，上传的目标 URL 为 https://{Domain}``{Path}，其中 Domain 为响应体中的 domain 字段，Path 为响应体中的 path 字段，例如 https://examplebucket-1250000000.cos.ap-beijing.myqcloud.com/smhxxx/xxx.mp4；
    PUT 简单上传时还需要指定一系列额外的请求头部字段，这些字段的名和值包含在响应体中的 headers 字段中；
    当在浏览器使用 JS 上传文件时，需要提前在绑定的 COS 存储桶中设置跨域访问 CORS 设置；
    在完成实际上传后，上传的目标 URL 将返回 HTTP 200 OK；
    默认情况下同名文件将自动修改文件名，可在完成上传文件接口中获取最终的文件路径；
    不会自动创建所需的各级父目录，因此必须保证路径的各级目录存在；
 */
#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHInitUploadInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHPutObjectRequest : QCloudSMHBizRequest

/// 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file_new.docx ；
@property (nonatomic,strong)NSString * filePath;

/// 文件大小
@property (nonatomic,strong)NSString * fileSize;


/// SMH 定义的文件的 fullHash 值，用于秒传，可选参数，具体算法如下：
@property (nonatomic,strong)NSString * fullHash;

/// 文件前 1M 的 fullHash 值，用于秒传，可选参数；
/// 文件开头 1M 的 sha256 哈希值
@property (nonatomic,strong)NSString * beginningHash;

@property (nonatomic,strong)NSString * createionDate;

@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;
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
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
