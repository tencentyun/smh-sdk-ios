//
//  QCloudSMHURLProbeResult.m
//  QCloudCOSSMH
//
//  Created by mochadu
//

#import "QCloudSMHURLProbeResult.h"

@interface QCloudSMHURLProbeResult ()

@property (nonatomic, assign, readwrite) int64_t fileSize;
@property (nonatomic, assign, readwrite) BOOL hasContentLength;
@property (nonatomic, assign, readwrite) BOOL supportsRange;
@property (nonatomic, copy, readwrite, nullable) NSString *contentType;

@end

@implementation QCloudSMHURLProbeResult

- (instancetype)initWithFileSize:(int64_t)fileSize
                hasContentLength:(BOOL)hasContentLength
                   supportsRange:(BOOL)supportsRange
                     contentType:(nullable NSString *)contentType {
    self = [super init];
    if (self) {
        _fileSize = fileSize;
        _hasContentLength = hasContentLength;
        _supportsRange = supportsRange;
        _contentType = [contentType copy];
    }
    return self;
}

- (BOOL)canUseChunkedTransfer {
    return self.hasContentLength && self.supportsRange;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> fileSize=%lld, hasContentLength=%@, supportsRange=%@, contentType=%@, canUseChunkedTransfer=%@",
            NSStringFromClass([self class]),
            self,
            self.fileSize,
            self.hasContentLength ? @"YES" : @"NO",
            self.supportsRange ? @"YES" : @"NO",
            self.contentType ?: @"(nil)",
            self.canUseChunkedTransfer ? @"YES" : @"NO"];
}

@end
