//
//  QCloudStreamPipeline.m
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2026/1/27.
//

#import "QCloudStreamPipeline.h"
#import <QCloudCore/QCloudCore.h>
#import <stdatomic.h>

@interface QCloudStreamPipeline () <NSStreamDelegate>

@property (nonatomic, strong, readwrite) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSThread *streamThread;
@property (nonatomic, strong) NSCondition *condition;  // 统一使用一个条件变量
@property (nonatomic, assign) BOOL outputReady;
@property (nonatomic, strong, readwrite, nullable) NSError *lastError;

@end

@implementation QCloudStreamPipeline {
    atomic_int _atomicState;  // 原子状态，保证线程安全
}

#pragma mark - Initialization

- (instancetype)initWithBufferSize:(NSUInteger)bufferSize {
    self = [super init];
    if (self) {
        _bufferSize = bufferSize;
        atomic_store(&_atomicState, QCloudStreamPipelineStateIdle);
        _condition = [[NSCondition alloc] init];
        _outputReady = NO;
        
        // 创建绑定的流对
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreateBoundPair(NULL, &readStream, &writeStream, (CFIndex)bufferSize);
        
        _inputStream = (__bridge_transfer NSInputStream *)readStream;
        _outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    }
    return self;
}

- (void)dealloc {
    [self closeInternal];
}

#pragma mark - State Accessors (Thread-Safe)

- (QCloudStreamPipelineState)state {
    return (QCloudStreamPipelineState)atomic_load(&_atomicState);
}

- (void)setState:(QCloudStreamPipelineState)state {
    atomic_store(&_atomicState, state);
}

- (BOOL)isRunning {
    return self.state == QCloudStreamPipelineStateRunning;
}

#pragma mark - Public Methods

- (void)open {
    [self.condition lock];
    
    if (self.state != QCloudStreamPipelineStateIdle) {
        [self.condition unlock];
        return;
    }
    
    self.state = QCloudStreamPipelineStateRunning;
    
    // 使用 __weak 防止 NSThread 强引用导致的循环引用
    __weak typeof(self) weakSelf = self;
    self.streamThread = [[NSThread alloc] initWithBlock:^{
        [weakSelf streamThreadMain];
    }];
    self.streamThread.name = @"com.qcloud.smh.stream.pipeline";
    self.streamThread.qualityOfService = NSQualityOfServiceUserInitiated;
    [self.streamThread start];
    
    // 等待输出流就绪
    while (!self.outputReady && self.isRunning) {
        [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    [self.condition unlock];
}

- (NSInteger)writeData:(NSData *)data error:(NSError *__autoreleasing *)error {
    if (!data || data.length == 0) {
        return 0;
    }
    
    if (!self.isRunning) {
        if (error) {
            *error = [NSError errorWithDomain:kQCloudNetworkDomain
                                         code:QCloudNetworkErrorUnsupportOperationError
                                     userInfo:@{NSLocalizedDescriptionKey: @"管道未运行"}];
        }
        return -1;
    }
    
    const uint8_t *bytes = data.bytes;
    NSUInteger totalLength = data.length;
    NSUInteger written = 0;
    
    [self.condition lock];
    
    while (written < totalLength && self.isRunning) {
        NSOutputStream *stream = self.outputStream;
        
        // 等待输出流有空间
        while (stream && !stream.hasSpaceAvailable && self.isRunning) {
            [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
        }
        
        if (!self.isRunning || !stream) {
            break;
        }
        
        // 在锁内写入数据
        NSInteger result = [stream write:bytes + written maxLength:totalLength - written];
        
        if (result > 0) {
            written += result;
        } else if (result < 0) {
            self.lastError = stream.streamError;
            self.state = QCloudStreamPipelineStateError;
            [self.condition unlock];
            if (error) {
                *error = self.lastError;
            }
            return -1;
        }
        // result == 0 表示暂时无法写入，继续等待
    }
    
    [self.condition unlock];
    
    return (NSInteger)written;
}

- (BOOL)hasSpaceAvailable {
    [self.condition lock];
    BOOL available = self.outputStream.hasSpaceAvailable;
    [self.condition unlock];
    return available;
}

- (void)closeOutput {
    [self.condition lock];
    
    NSOutputStream *stream = self.outputStream;
    if (stream) {
        stream.delegate = nil;
        [stream close];
    }
    
    [self.condition unlock];
    
    QCloudLogInfo(@"StreamPipeline", @"输出端已关闭");
}

- (void)close {
    [self closeInternal];
    QCloudLogInfo(@"StreamPipeline", @"管道已完全关闭");
}

#pragma mark - Private Methods

- (void)closeInternal {
    [self.condition lock];
    
    if (self.state == QCloudStreamPipelineStateClosed) {
        [self.condition unlock];
        return;
    }
    
    // 设置关闭状态
    self.state = QCloudStreamPipelineStateClosed;
    
    // 清除 delegate 并关闭流
    NSOutputStream *outputStream = self.outputStream;
    NSInputStream *inputStream = self.inputStream;
    
    if (outputStream) {
        outputStream.delegate = nil;
        [outputStream close];
    }
    
    if (inputStream) {
        [inputStream close];
    }
    
    // 唤醒所有等待的线程
    [self.condition broadcast];
    
    [self.condition unlock];
}

- (void)streamThreadMain {
    @autoreleasepool {
        // 使用 __strong 确保在方法执行期间 self 有效
        // 如果 self 已被释放，weakSelf 会是 nil，直接返回
        __strong typeof(self) strongSelf = self;
        if (!strongSelf || !strongSelf.isRunning) {
            return;
        }
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [strongSelf.condition lock];
        NSOutputStream *outputStream = strongSelf.outputStream;
        [strongSelf.condition unlock];
        
        if (!outputStream) {
            return;
        }
        
        // 设置 delegate 并调度到 RunLoop
        outputStream.delegate = strongSelf;
        [outputStream scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
        [outputStream open];
        
        // 运行 RunLoop 直到状态改变
        while (strongSelf.isRunning) {
            @autoreleasepool {
                BOOL result = [runLoop runMode:NSDefaultRunLoopMode
                                    beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                if (!result) {
                    break;
                }
            }
        }
        
        // 清理：从 RunLoop 移除并清除 delegate
        outputStream.delegate = nil;
        [outputStream removeFromRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    // 快速检查状态
    if (self.state == QCloudStreamPipelineStateClosed) {
        return;
    }
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            [self.condition lock];
            self.outputReady = YES;
            [self.condition signal];
            [self.condition unlock];
            QCloudLogDebug(@"StreamPipeline", @"输出流已就绪");
            break;
            
        case NSStreamEventHasSpaceAvailable:
            [self.condition lock];
            [self.condition signal];
            [self.condition unlock];
            break;
            
        case NSStreamEventErrorOccurred:
            [self.condition lock];
            if (self.state != QCloudStreamPipelineStateClosed) {
                QCloudLogError(@"StreamPipeline", @"流错误 - %@", aStream.streamError);
                self.lastError = aStream.streamError;
                self.state = QCloudStreamPipelineStateError;
                [self.condition broadcast];
            }
            [self.condition unlock];
            break;
            
        case NSStreamEventEndEncountered:
            QCloudLogDebug(@"StreamPipeline", @"流结束");
            break;
            
        default:
            break;
    }
}

@end
