//
//  QCloudSMHDownloadTranscodedVideoRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/// 视频下载（获取转码后的视频下载链接）
/// @discussion 下载视频转码接口转码后的文件，扩展下载文件接口。
/// 若 m3u8 转封装未完成，则返回 FileConverting；若转码未完成，则返回原始视频的下载链接。
/// 接口通过 302 重定向返回可直接用于下载的文件 URL。
@interface QCloudSMHDownloadTranscodedVideoRequest : QCloudSMHBizRequest
/// 视频文件路径，必选参数
@property (nonatomic, strong) NSString *filePath;
/// 转码模板 ID，必选参数。
/// 可选值：h264_360p（流畅）/ h264_480p（低清）/ h264_720p（高清）/ h264_1080p（超清）/ h264_2K / h264_4K
@property (nonatomic, strong) NSString *transcodingTemplateId;
- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
