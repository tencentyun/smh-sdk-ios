//
//  QCloudSMHSpaceUsageInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2025/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHSpaceUsageInfo : NSObject
/**
 *  租户空间 ID
 */
@property (nonatomic, strong) NSString* spaceId;

/**
 *  租户空间配额，如果为 null 则无配额。单位为字节（Byte）
 */
@property (nonatomic, strong) NSString* capacity;

/**
 *  租户空间配可用容量，如果为 null 则无配额。单位为字节（Byte）
 */
@property (nonatomic, strong) NSString* availableSpace;

/**
 *  租户空间已上传文件占用的存储额度。单位为字节（Byte）
 */
@property (nonatomic, strong) NSString* size;

@end

NS_ASSUME_NONNULL_END
