//
//  QCloudSMHCreateTranscodeTaskRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 视频转码
/// @discussion 将指定视频转码到模版指定的规格（帧率、码率、分辨率）。
/// 要求 space_admin 权限或 admin 权限。
@interface QCloudSMHCreateTranscodeTaskRequest : QCloudSMHBizRequest
/// 视频文件路径，必选参数
@property (nonatomic, strong) NSString *filePath;
/// 目标转码模板 ID，必选参数。
/// 可选值：h264_360p（流畅）/ h264_480p（低清）/ h264_720p（高清）/ h264_1080p（超清）/ h264_2K / h264_4K
@property (nonatomic, strong) NSString *transcodingTemplateId;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
