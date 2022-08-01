//
//  QCloudSMHGetUploadStateRequest.h
//  QCloudSMHGetUploadStateRequest
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHUploadStateInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 获取文件上传任务状态
 */
@interface QCloudSMHGetUploadStateRequest : QCloudSMHBizRequest

/// 确认参数，必选参数，指定为开始上传文件时响应体中的 confirmKey 字段的值；
@property (nonatomic,strong)NSString * confirmKey;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHUploadStateInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
