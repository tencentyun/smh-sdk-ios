//
//  QCloudSMHM3u8SegmentInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// m3u8 分片文件信息（用于 prepareM3u8Upload 和 modifyM3u8Segments 接口的 segments 参数）
@interface QCloudSMHM3u8SegmentInfo : NSObject

/// 分片文件路径，如 1.ts 或 abc/def/1.ts，不能包含特殊字符，必选参数
@property (nonatomic, strong) NSString *path;

/// 上传类型，可选参数。
/// 可选值：simple（简单上传，默认）/ multipart（分块上传）
@property (nonatomic, strong, nullable) NSString *uploadMethod;

@end

/// m3u8 上传续期分片文件信息（用于 renewM3u8Upload 接口的 segments 参数）
/// @note API 层面 segments 为纯字符串数组，此处封装为数据模型以保持各接口 segments 参数风格一致
@interface QCloudSMHM3u8RenewSegmentInfo : NSObject

/// 分片文件路径，如 1.ts 或 dir/1.ts，必选参数
@property (nonatomic, strong) NSString *path;

@end

/// m3u8 上传确认分片文件信息（用于 confirmM3u8Upload 接口的 segments 参数）
@interface QCloudSMHM3u8ConfirmSegmentInfo : NSObject

/// 分片文件路径，如 dir/1.ts，必选参数
@property (nonatomic, strong) NSString *path;

/// 分片文件的 crc64 校验值，可选参数（指定时进行一致性校验）
@property (nonatomic, strong, nullable) NSString *crc64;

@end

NS_ASSUME_NONNULL_END
