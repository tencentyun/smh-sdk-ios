//
//  QCloudSMHConfirmM3u8UploadRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// m3u8 上传完成（确认）
@interface QCloudSMHConfirmM3u8UploadRequest : QCloudSMHBizRequest
/// m3u8 上传准备接口响应体中的 confirmKey
@property (nonatomic, strong) NSString *confirmKey;
/// 播放列表文件的 crc64 校验值（可选，指定时进行一致性校验）
@property (nonatomic, strong, nullable) NSString *playlistCrc64;
/// 分片文件列表（包含 path 和 crc64）
@property (nonatomic, strong) NSArray<QCloudSMHM3u8ConfirmSegmentInfo *> *segments;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHM3u8ConfirmResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
