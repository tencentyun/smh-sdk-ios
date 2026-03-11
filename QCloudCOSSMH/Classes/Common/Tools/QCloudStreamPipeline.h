//
//  QCloudStreamPipeline.h
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2026/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 流管道状态
 */
typedef NS_ENUM(NSInteger, QCloudStreamPipelineState) {
    QCloudStreamPipelineStateIdle,      // 空闲
    QCloudStreamPipelineStateRunning,   // 运行中
    QCloudStreamPipelineStateClosed,    // 已关闭
    QCloudStreamPipelineStateError      // 错误
};

/**
 * 流管道
 *
 * 用于连接下载流和上传流，实现数据的流式传输。
 * 核心机制：使用 NSStream 的绑定流对，写入 outputStream 的数据可立即从 inputStream 读取。
 *
 * 背压机制：
 * - 当 outputStream 缓冲区满时，writeData: 方法会阻塞
 * - 当 inputStream 被消费后，缓冲区释放，writeData: 继续
 * - 这样自然实现了上传慢时暂停下载的背压效果
 */
@interface QCloudStreamPipeline : NSObject

/**
 * 管道缓冲区大小（字节）
 */
@property (nonatomic, assign, readonly) NSUInteger bufferSize;

/**
 * 管道状态
 */
@property (nonatomic, assign, readonly) QCloudStreamPipelineState state;

/**
 * 输入流（供上传任务读取）
 * 使用方式：将此流设置为 NSMutableURLRequest 的 HTTPBodyStream
 */
@property (nonatomic, strong, readonly) NSInputStream *inputStream;

/**
 * 是否有空间可写
 * 用于外部判断背压状态
 */
@property (nonatomic, assign, readonly) BOOL hasSpaceAvailable;

/**
 * 最后一次错误
 */
@property (nonatomic, strong, readonly, nullable) NSError *lastError;

/**
 * 创建管道
 *
 * @param bufferSize 缓冲区大小，建议 64KB - 256KB
 * @return 管道实例
 */
- (instancetype)initWithBufferSize:(NSUInteger)bufferSize NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 * 启动管道
 * 必须在写入数据前调用
 */
- (void)open;

/**
 * 写入数据到管道
 *
 * 此方法可能阻塞：当管道缓冲区满时，会等待直到有空间可用。
 * 这是背压机制的核心：上传慢会导致写入阻塞，从而暂停下载。
 *
 * @param data 要写入的数据
 * @param error 错误输出
 * @return 实际写入的字节数，-1 表示错误
 */
- (NSInteger)writeData:(NSData *)data error:(NSError *_Nullable *_Nullable)error;

/**
 * 关闭输出端
 *
 * 下载完成后调用此方法，表示所有数据已写入。
 * inputStream 会收到 EOF，上传任务随之完成。
 */
- (void)closeOutput;

/**
 * 完全关闭管道
 *
 * 强制关闭输入和输出流，通常用于取消操作。
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END
