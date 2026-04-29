//
//  QCloudSMHMediaFileInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 媒体文件元信息（对应 getMediaFileInfo 响应）
@interface QCloudSMHMediaFileInfo : NSObject
/** 视频高，单位 px */
@property (nonatomic, strong) NSString *height;
/** 视频宽，单位 px */
@property (nonatomic, strong) NSString *width;
/** 比特率，单位为 kbps */
@property (nonatomic, strong) NSString *bitrate;
/** 时长，单位为秒 */
@property (nonatomic, strong) NSString *duration;
/** 当前视频允许使用的转码模板列表 */
@property (nonatomic, strong) NSArray<NSString *> *allowedTranscodingTemplates;
@end
NS_ASSUME_NONNULL_END
