//
//  QCloudSMHM3u8UploadInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// COS 预签名上传信息（用于 prepareM3u8Upload / renewM3u8Upload / modifyM3u8Segments 响应中的 playlist 和 segments 子项）
/// @discussion 包含实际上传文件到 COS 所需的域名、路径、请求头部和有效期等信息。
@interface QCloudSMHM3u8UploadInfo : NSObject

/// 实际上传文件时的域名
@property (nonatomic, strong, nullable) NSString *domain;

/// 实际上传时的 URL 路径
@property (nonatomic, strong, nullable) NSString *path;

/// 用于 COS 分块上传的 uploadId，简单上传不返回该字段
@property (nonatomic, strong, nullable) NSString *uploadId;

/// 实际上传时需指定的请求头部（key-value 形式）
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *headers;

/// 上传信息有效期（ISO 8601 格式），失效后需要调用 m3u8 上传续期接口进行续期
@property (nonatomic, strong, nullable) NSString *expiration;

@end

#pragma mark - prepareM3u8Upload 响应（201 未命中秒传）

/// m3u8 上传准备响应（201 未命中秒传）
/// @discussion 包含 confirmKey、预签名的 playlist 上传信息和 segments 上传信息。
@interface QCloudSMHM3u8PrepareResult : NSObject

/// 用于该 m3u8 请求分片上传及完成文件上传的确认参数
@property (nonatomic, strong, nullable) NSString *confirmKey;

/// 预签名 m3u8 播放列表上传信息（用于客户端上传至 COS）
@property (nonatomic, strong, nullable) QCloudSMHM3u8UploadInfo *playlist;

/// 预签名分片上传信息（用于客户端上传至 COS），key 为分片文件路径，value 为上传信息
@property (nonatomic, strong, nullable) NSDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *segments;

@end

#pragma mark - prepareM3u8Upload 响应（200 命中秒传）

/// m3u8 上传准备响应（200 命中秒传）
/// @discussion 命中秒传时直接返回最终文件信息，无需再上传。
@interface QCloudSMHM3u8QuickUploadResult : NSObject

/// 最终的文件路径，数组中的最后一个元素代表最终的文件名，其他元素代表每一级目录名；
/// 如果为 nil 则表示该文件所在的目录或其某个父级目录已被删除，该文件已经无法访问
@property (nonatomic, strong, nullable) NSArray<NSString *> *path;

/// 最终文件名
@property (nonatomic, strong, nullable) NSString *name;

/// 文件类型
@property (nonatomic, strong, nullable) NSString *type;

@end

#pragma mark - confirmM3u8Upload 响应

/// m3u8 上传确认响应中的 playlist 信息
@interface QCloudSMHM3u8ConfirmPlaylistInfo : NSObject

/// 转封装前的文件路径，数组中的最后一个元素代表最终的文件名，其他元素代表每一级目录名；
/// 如果为 nil 则表示该文件所在的目录或其某个父级目录已被删除，该文件已经无法访问
@property (nonatomic, strong, nullable) NSArray<NSString *> *path;

@end

/// m3u8 上传确认响应
/// @discussion 确认上传完成后返回 playlist 文件信息。
@interface QCloudSMHM3u8ConfirmResult : NSObject

/// 播放列表文件信息
@property (nonatomic, strong, nullable) QCloudSMHM3u8ConfirmPlaylistInfo *playlist;

@end

#pragma mark - renewM3u8Upload 响应

/// m3u8 上传续期响应
/// @discussion 续期成功后返回刷新后的预签名上传信息。
@interface QCloudSMHM3u8RenewResult : NSObject

/// 预签名 m3u8 播放列表上传信息（用于客户端上传至 COS）
@property (nonatomic, strong, nullable) QCloudSMHM3u8UploadInfo *playlist;

/// 预签名分片上传信息（用于客户端上传至 COS），key 为分片文件路径，value 为上传信息
@property (nonatomic, strong, nullable) NSDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *segments;

@end

#pragma mark - modifyM3u8Segments 响应

/// m3u8 分片重传与追加响应
/// @discussion 返回新的预签名分片上传信息。
@interface QCloudSMHM3u8ModifyResult : NSObject

/// 预签名分片上传信息（用于客户端上传至 COS），key 为分片文件路径，value 为上传信息
@property (nonatomic, strong, nullable) NSDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *segments;

@end

NS_ASSUME_NONNULL_END
