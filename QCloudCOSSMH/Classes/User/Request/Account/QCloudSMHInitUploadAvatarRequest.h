//
//  QCloudSMHInitUploadAvatarRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/31.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHInitUploadInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 获取头像简单上传文件参数。
 
 PUT 简单上传指使用 HTTP PUT 请求上传一个文件，调用 COS 接口时，请求体即为文件的内容；
 调用该接口将返回一系列用于 PUT 简单上传请求和确认上传完成的参数，上传的目标 URL 为 https://{Domain}``{Path}，其中 Domain 为响应体中的 domain 字段，Path 为响应体中的 path 字段，例如 https://examplebucket-1250000000.cos.ap-beijing.myqcloud.com/smhxxx/xxx.mp4；
 PUT 简单上传时还需要指定一系列额外的请求头部字段，这些字段的名和值包含在响应体中的 headers 字段中；
 在完成实际上传后，上传的目标 URL 将返回 HTTP 200 OK；
 */
@interface QCloudSMHInitUploadAvatarRequest : QCloudSMHBaseRequest

/// 请求上传的文件后缀，仅支持 png/jpg/jpeg
@property (nonatomic,strong)NSString *fileExt;

@property (nonatomic,strong)NSString *userToken;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
