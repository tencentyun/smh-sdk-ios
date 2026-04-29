//
//  QCloudSMHLiveTranscodeMediaFileRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 发起实时转码任务并获取带授权信息的播放列表（302 跳转）
/// @discussion 可以直接在视频播放器中指定该 URL，该接口将自动 302 跳转到真实的 m3u8 播放列表 URL。
/// 此接口仅支持将其他格式的源文件转码为 HLS 格式目标文件进行播放，不支持以 HLS 格式作为源文件。
/// 此接口暂不支持播放符号链接文件和文件的历史版本。
@interface QCloudSMHLiveTranscodeMediaFileRequest : QCloudSMHBizRequest
/// 视频文件路径，必选参数
@property (nonatomic, strong) NSString *filePath;
/// 转码模板 ID，必选参数。注意：不允许输入比原视频分辨率更大的转码模板。
/// 可选值：h264_360p（流畅）/ h264_480p（低清）/ h264_720p（高清）/ h264_1080p（超清）/ h264_2K / h264_4K
@property (nonatomic, strong) NSString *transcodingTemplateId;
- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
