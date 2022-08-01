//
//  NSData+SHA256.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (SHA256)
- (NSString *)qcloudSha256;

- (uint8_t *)qcloudSha256Bytes;

+ (NSString *)qcloudSha256BytesTostring:(uint8_t *)bytes;

@end

NS_ASSUME_NONNULL_END
