//
//  QCloudSMHTaskIDGenerator.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import "QCloudSMHTaskIDGenerator.h"
#import <CommonCrypto/CommonDigest.h>

@implementation QCloudSMHTaskIDGenerator

#pragma mark - 任务ID生成

+ (NSString *)generateTaskIDWithLibraryId:(NSString *)libraryId
                                        spaceId:(NSString *)spaceId
                                         userId:(NSString *)userId
                               remotePath:(NSString *)remotePath
                                 localURL:(NSURL *)localURL {
    
    // 规范化本地路径：提取相对于Documents目录的相对路径
    NSString *localPath = localURL.path;
    if (TARGET_IPHONE_SIMULATOR) {
        localPath = [self normalizeLocalPath:localURL];
    }
    
    // 构建唯一标识字符串
    NSString *uniqueString = [NSString stringWithFormat:@"Task:%@:%@:%@:%@:%@",
                             libraryId ?: @"",
                             spaceId ?: @"", 
                             userId ?: @"",
                             remotePath ?: @"",
                             localPath];
    
    return [self generateMD5Hash:uniqueString];
}

#pragma mark - 路径规范化

/**
 * 规范化本地路径：提取相对于Documents目录的相对路径
 * @param localURL 本地文件URL
 * @return 相对路径
 */
+ (NSString *)normalizeLocalPath:(NSURL *)localURL {
    if (!localURL) {
        return @"";
    }
    
    NSString *fullPath = localURL.path;
    if (!fullPath || fullPath.length == 0) {
        return @"";
    }
    
    // 获取Documents目录路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
    NSString *documentsPath = documentPaths.firstObject;
    
    // 确保Documents路径以斜杠结尾，便于比较
    if (![documentsPath hasSuffix:@"/"]) {
        documentsPath = [documentsPath stringByAppendingString:@"/"];
    }
    
    // 如果文件路径在Documents目录下，提取相对路径
    if ([fullPath hasPrefix:documentsPath]) {
        NSString *relativePath = [fullPath substringFromIndex:documentsPath.length];
        return relativePath.length > 0 ? relativePath : @"";
    }
    
    return localURL.path;
}

#pragma mark - 工具方法

+ (NSString *)generateMD5Hash:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    return [hash copy];
}

@end
