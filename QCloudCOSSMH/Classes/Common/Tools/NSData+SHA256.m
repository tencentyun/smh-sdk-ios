//
//  NSData+SHA256.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/25.
//

#import "NSData+SHA256.h"
#import <CommonCrypto/CommonDigest.h>
#import  <CommonCrypto/CommonHMAC.h>
#import <stdio.h>
#include <string.h>

@implementation NSData (SHA256)
- (NSString *)qcloudSha256
{
    return [NSData qcloudSha256BytesTostring:[self qcloudSha256Bytes]];
}

- (uint8_t *)qcloudSha256Bytes
{
    
    return [NSData qcloudSha256BytesTostringWithBytes:(uint8_t *)self.bytes withLength:self.length];
    
}

+ (NSString *)qcloudSha256BytesTostring:(uint8_t *)bytes
{
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", bytes[i]];
    }
    
    return output;
}

+ (uint8_t *)qcloudSha256BytesTostringWithBytes:(uint8_t *)bytes withLength:(NSUInteger)length
{
    static uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(bytes,(CC_LONG) length, digest);
    
    return digest;
}

@end








