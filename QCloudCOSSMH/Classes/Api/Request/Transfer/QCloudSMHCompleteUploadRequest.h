//
//  QCloudSMHCompleteUploadRequest.h
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHConflictStrategyEnumType.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于完成上传文件
 
 非 acl 鉴权：admin、space_admin、upload_file、upload_file_force 或 confirm_upload
 acl 鉴权：canUpload（当前文件夹可上传）
 非 acl 鉴权是指当前用户对所有文件的操作权限，详情可参考生成访问令牌接口； acl 鉴权是通过共享授权接口给指定用户，以文件夹为单位授予的权限，详情可参考角色授权模块；
 在表单上传完成后，请务必及时调用该接口，否则文件将不能被正确存储；
 如果调用该接口时实际并未完成文件上传，将返回错误信息；
 */
@interface QCloudSMHCompleteUploadRequest : QCloudSMHBizRequest

/// 确认参数，必选参数，指定为开始上传文件时响应体中的 confirmKey 字段的值；
@property (nonatomic,strong)NSString * confirmKey;

@property (nonatomic,strong)NSString * crc64;

/// 文件名冲突时的处理方式，ask: 冲突时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，rename: 冲突时自动重命名文件，overwrite: 如果冲突目标为目录时返回 HTTP 409 Conflict 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，默认为开始文件上传时指定的 ConflictResolutionStrategy；
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
