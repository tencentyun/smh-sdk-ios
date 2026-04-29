//
//  QCloudSMHModifyM3u8SegmentsRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// m3u8 分片重传与追加
@interface QCloudSMHModifyM3u8SegmentsRequest : QCloudSMHBizRequest
/// m3u8 上传准备接口响应体中的 confirmKey
@property (nonatomic, strong) NSString *confirmKey;
/// 单连接上传限速，范围 100KB/s-100MB/s，单位 Byte
@property (nonatomic, assign) NSInteger trafficLimit;
/// 分片文件名称列表（包含 path 和 uploadMethod）
@property (nonatomic, strong) NSArray<QCloudSMHM3u8SegmentInfo *> *segments;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHM3u8ModifyResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
