//
//  QCloudSMHDeleteObjectRequest.h
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于取消上传任务
 
 要求权限：
 非 acl 鉴权：admin、space_admin、upload_file、upload_file_force、begin_upload 或 begin_upload_force（注意：虽然本接口为删除接口，但因为删除的是上传任务信息，故仍需上传文件的相关权限）
 acl 鉴权：canUpload（当前文件夹可上传）
 非 acl 鉴权是指当前用户对所有文件的操作权限，详情可参考生成访问令牌接口； acl 鉴权是通过共享授权接口给指定用户，以文件夹为单位授予的权限，详情可参考角色授权模块；
 如果上传任务为分块上传任务，那么该请求将同时放弃 COS 中的分块上传任务；
 */
@interface QCloudSMHAbortMultipfartUploadRequest : QCloudSMHBizRequest

/// 确认参数，必选参数，指定为开始上传文件时响应体中的 confirmKey 字段的值；
@property (nonatomic,strong)NSString * confirmKey;


@end

NS_ASSUME_NONNULL_END
