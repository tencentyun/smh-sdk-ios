//
//  QCloudSMHGetMediaFileInfoRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHMediaFileInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 查询媒体文件元信息
/// @discussion 用于查询媒体文件的元信息，包括视频高度、宽度、比特率、时长以及允许使用的转码模板列表。
@interface QCloudSMHGetMediaFileInfoRequest : QCloudSMHBizRequest
/// 媒体文件路径，必选参数。对于多级目录，使用斜杠(/) 分隔，例如 foo/bar/video.mp4
@property (nonatomic, strong) NSString *filePath;
- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHMediaFileInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
