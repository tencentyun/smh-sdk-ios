//
//  QCloudSMHExternalURLDownloadRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2025/01/27.
//

#import <QCloudCore/QCloudCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 第三方 URL 下载请求
 *
 * 继承 QCloudHTTPRequest，复用 QCloudHTTPSessionManager 的网络执行能力。
 * 通过重写 buildURLRequest: 直接使用外部 URL，跳过 SDK 内部的 URL 构建和签名逻辑。
 *
 * @note 此类为 SDK 内部使用，用于流式同步上传场景，不对外暴露。
 */
@interface QCloudSMHExternalURLDownloadRequest : QCloudHTTPRequest

/// 第三方源 URL（必填）
@property (nonatomic, strong, nonnull) NSURL *sourceURL;

/// 自定义请求头（可选，用于认证等）
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *customHeaders;

/// Range 请求头（可选，用于分块下载，格式如 "bytes=0-1023"）
@property (nonatomic, strong, nullable) NSString *rangeHeader;

@end

NS_ASSUME_NONNULL_END
