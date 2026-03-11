//
//  QCloudSMHURLProbe.h
//  QCloudCOSSMH
//
//  Created by tencent
//  QCloudTerminalLab --- service for developers
//  eamil: g_pdtc_storage_terminallab@tencent.com
//

#import <Foundation/Foundation.h>
#import "QCloudSMHURLProbeResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * URL 探测完成回调
 *
 * @param result 探测结果，失败时为 nil
 * @param error 错误信息，成功时为 nil
 */
typedef void (^QCloudSMHURLProbeCompletionHandler)(QCloudSMHURLProbeResult *_Nullable result, NSError *_Nullable error);

#pragma mark - QCloudSMHURLProbing 协议

/**
 * URL 探测协议
 *
 * 用于自定义 URL 探测逻辑。实现此协议可以：
 * - 自定义探测策略（如跳过 HEAD 直接使用 GET）
 * - 处理特殊的鉴权逻辑
 * - 支持非标准的响应头格式
 */
@protocol QCloudSMHURLProbing <NSObject>

@required

/**
 * 开始探测源 URL
 *
 * @param completion 完成回调，必须调用
 */
- (void)probeWithCompletion:(QCloudSMHURLProbeCompletionHandler)completion;

/**
 * 取消探测
 */
- (void)cancel;

@end

#pragma mark - QCloudSMHURLProbe 默认实现

/**
 * URL 探测工具类（默认实现）
 *
 * 用于探测源 URL 的元信息，包括：
 * - 文件大小（Content-Length）
 * - 是否支持断点下载（Accept-Ranges）
 * - 内容类型（Content-Type）
 *
 * 探测策略：
 * 1. 首先尝试 HEAD 请求获取元信息
 * 2. 如果 HEAD 失败，降级到 GET Range(0-0) 请求探测
 */
@interface QCloudSMHURLProbe : NSObject <QCloudSMHURLProbing>

/**
 * 探测超时时间（秒），默认 30 秒
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 * 源 URL
 */
@property (nonatomic, strong, readonly) NSURL *sourceURL;

/**
 * 自定义请求头
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *sourceHeaders;

/**
 * 创建探测工具实例
 *
 * @param sourceURL 源 URL
 * @param headers 自定义请求头（如 Authorization、Referer 等）
 * @return 探测工具实例
 */
- (instancetype)initWithSourceURL:(NSURL *)sourceURL
                          headers:(nullable NSDictionary<NSString *, NSString *> *)headers NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 * 开始探测
 *
 * @param completion 完成回调
 */
- (void)probeWithCompletion:(QCloudSMHURLProbeCompletionHandler)completion;

/**
 * 取消探测
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
