//
//  QCloudSMHRenewM3u8UploadRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// m3u8 上传续期
@interface QCloudSMHRenewM3u8UploadRequest : QCloudSMHBizRequest
/// m3u8 上传准备接口响应体中的 confirmKey
@property (nonatomic, strong) NSString *confirmKey;
/// 单连接上传限速，范围 100KB/s-100MB/s，单位 Byte
@property (nonatomic, assign) NSInteger trafficLimit;
/// 播放列表(media playlist)，固定为 m3u8
@property (nonatomic, strong) NSString *playlistType;
/// 分片文件名称列表
/// @note API 层面 segments 为纯字符串数组（分片文件路径），此处使用 QCloudSMHM3u8RenewSegmentInfo 数据模型封装，
///       以保持各 m3u8 接口 segments 参数风格一致，序列化时自动提取 path 字段组成字符串数组。
@property (nonatomic, strong) NSArray<QCloudSMHM3u8RenewSegmentInfo *> *segments;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHM3u8RenewResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
