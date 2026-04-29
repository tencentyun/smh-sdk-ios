//
//  QCloudSMHPrepareM3u8UploadRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// m3u8 上传准备
/// @discussion 用于准备 m3u8 播放列表及其分片文件的上传。
/// 要求 space_admin 权限或 admin 权限。
///
/// @note 该接口存在两种不同的响应数据模型，根据 HTTP 状态码区分：
/// - **HTTP 201（未命中秒传）**：返回 `QCloudSMHM3u8PrepareResult`，包含 confirmKey、playlist 上传信息和 segments 上传信息，
///   客户端需要使用这些预签名信息将文件上传到 COS，然后调用确认接口完成上传。
/// - **HTTP 200（命中秒传）**：返回 `QCloudSMHM3u8QuickUploadResult`，包含最终文件的 path、name、type，
///   表示服务端已有相同文件，无需再上传，直接完成。
///
/// 由于 finishBlock 使用 NSDictionary 接收结果，调用方需根据 HTTP 状态码或字典中的字段来判断实际类型：
/// - 若字典包含 `confirmKey` 字段，则为 201 未命中秒传场景，可使用 `QCloudSMHM3u8PrepareResult` 解析；
/// - 若字典包含 `path`/`name`/`type` 字段，则为 200 命中秒传场景，可使用 `QCloudSMHM3u8QuickUploadResult` 解析。
@interface QCloudSMHPrepareM3u8UploadRequest : QCloudSMHBizRequest
/// 文件路径，必选参数
@property (nonatomic, strong) NSString *filePath;
/// 文件名冲突时的处理方式，可选参数。
/// 可选值：ask（默认，冲突时返回 409）/ rename（冲突时自动重命名）/ overwrite（覆盖已有文件）
@property (nonatomic, strong) NSString *conflictResolutionStrategy;
/// 单连接上传限速，范围 100KB/s-100MB/s，单位 Byte，可选参数
@property (nonatomic, assign) NSInteger trafficLimit;
/// 用于秒传的抽样哈希，可选参数，与 segmentsCount 捆绑传入
@property (nonatomic, strong) NSString *sampleHash;
/// 分片数量，字符串类型，可选参数，与 sampleHash 捆绑传入
@property (nonatomic, strong) NSString *segmentsCount;
/// 是否包含播放列表(media playlist)，为 YES 时发送空对象，可选参数
@property (nonatomic, assign) BOOL includePlaylist;
/// 分片文件名称列表（包含可选的密钥），限定长度为 100（传密钥时限定长度为 101），
/// 很长时需要分批调用 m3u8 分片重传与追加接口进行追加。
/// 每个元素包含 path（分片文件路径）和 uploadMethod（上传类型：simple / multipart）
@property (nonatomic, strong) NSArray<QCloudSMHM3u8SegmentInfo *> *segments;
/// 完成回调
/// @discussion 该接口存在两种不同的响应数据模型（通过 NSDictionary 返回）：
///
/// **场景一：HTTP 201 未命中秒传** — 字典可转为 `QCloudSMHM3u8PrepareResult`
/// ```
/// {
///   "confirmKey": "aaaaaaa",
///   "playlist": { "domain": "...", "path": "...", "headers": {...}, "expiration": "..." },
///   "segments": { "dir/1.ts": { "domain": "...", "path": "...", ... }, ... }
/// }
/// ```
///
/// **场景二：HTTP 200 命中秒传** — 字典可转为 `QCloudSMHM3u8QuickUploadResult`
/// ```
/// {
///   "path": ["foo", "bar", "a.m3u8.mp4"],
///   "name": "a.m3u8.mp4",
///   "type": "file"
/// }
/// ```
- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
