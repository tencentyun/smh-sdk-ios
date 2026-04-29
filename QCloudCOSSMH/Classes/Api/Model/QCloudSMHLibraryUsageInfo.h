//
//  QCloudSMHLibraryUsageInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 媒体库容量信息（对应 getLibraryUsage 响应）
@interface QCloudSMHLibraryUsageInfo : NSObject
/** 媒体库中所有文件占用的存储额度 */
@property (nonatomic, strong) NSString *totalFileSize;

@end



NS_ASSUME_NONNULL_END
