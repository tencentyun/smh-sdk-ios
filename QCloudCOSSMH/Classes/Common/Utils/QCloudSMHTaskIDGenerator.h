//
//  QCloudSMHTaskIDGenerator.h
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/10/31
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 任务ID生成器
 * 
 * 用于生成基于spaceId、libraryId、userId、path和本地保存路径的唯一任务标识符
 */
@interface QCloudSMHTaskIDGenerator : NSObject

#pragma mark - 任务ID生成

/**
 * 生成文件夹任务的唯一ID
 * @param libraryId 库ID
 * @param spaceId 空间ID
 * @param userId 用户ID
 * @param remotePath 远程文件夹路径
 * @param localURL 本地保存URL
 * @return 唯一任务ID
 */
+ (NSString *)generateTaskIDWithLibraryId:(NSString *)libraryId
                                        spaceId:(NSString *)spaceId
                                         userId:(NSString *)userId
                               remotePath:(NSString *)remotePath
                                 localURL:(NSURL *)localURL;

#pragma mark - 工具方法

/**
 * 生成MD5哈希值
 * @param string 输入字符串
 * @return MD5哈希值
 */
+ (NSString *)generateMD5Hash:(NSString *)string;


/**
 * 标准化本地路径
 */
+ (NSString *)normalizeLocalPath:(NSURL *)localURL;

@end

NS_ASSUME_NONNULL_END
