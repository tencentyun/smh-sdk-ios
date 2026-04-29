//
//  QCloudSMHDirectoryStatsInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 目录统计数据（对应 getDirectoryStats 响应）
@interface QCloudSMHDirectoryStatsInfo : NSObject
/** 创建人 ID */
@property (nonatomic, strong) NSString *userId;
/** 查询类型（normal / recycle / history） */
@property (nonatomic, strong) NSString *statsType;
/** 目录下所有文件总大小（字节） */
@property (nonatomic, assign) NSInteger storage;
/** 目录下所有文件数量 */
@property (nonatomic, assign) NSInteger fileCount;
/** 目录下所有子目录数量 */
@property (nonatomic, assign) NSInteger dirCount;
@end
NS_ASSUME_NONNULL_END
