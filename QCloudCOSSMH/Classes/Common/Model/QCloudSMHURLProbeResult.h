//
//  QCloudSMHURLProbeResult.h
//  QCloudCOSSMH
//
//  Created by tencent
//  QCloudTerminalLab --- service for developers
//  eamil: g_pdtc_storage_terminallab@tencent.com
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * URL 探测结果模型
 * 包含从源 URL 获取的元信息
 */
@interface QCloudSMHURLProbeResult : NSObject

/**
 * 远程文件大小（字节）
 * -1 表示未知大小
 */
@property (nonatomic, assign, readonly) int64_t fileSize;

/**
 * 是否有 Content-Length 头
 */
@property (nonatomic, assign, readonly) BOOL hasContentLength;

/**
 * 是否支持 Range 请求
 */
@property (nonatomic, assign, readonly) BOOL supportsRange;

/**
 * 内容类型
 */
@property (nonatomic, copy, readonly, nullable) NSString *contentType;

/**
 * 是否可以使用分块传输模式
 * 条件：支持 Content-Length 且支持 Range
 */
@property (nonatomic, assign, readonly) BOOL canUseChunkedTransfer;

/**
 * 内部使用：初始化探测结果
 */
- (instancetype)initWithFileSize:(int64_t)fileSize
                hasContentLength:(BOOL)hasContentLength
                   supportsRange:(BOOL)supportsRange
                     contentType:(nullable NSString *)contentType;

@end

NS_ASSUME_NONNULL_END
