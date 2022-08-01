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

@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
