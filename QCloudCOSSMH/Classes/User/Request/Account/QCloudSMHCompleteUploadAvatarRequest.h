//
//  QCloudSMHCompleteUploadAvatarRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/31.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 确认上传头像
 */
@interface QCloudSMHCompleteUploadAvatarRequest : QCloudSMHBaseRequest

/// 头像文件 path，即获取头像简单上传文件参数中的响应字段 path
@property (nonatomic,strong)NSString *filePath;

@property (nonatomic,strong)NSString *userToken;

@end

NS_ASSUME_NONNULL_END
