//
//  QCloudSMHSpaceListResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHSpaceListItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 列出租户空间结果
@interface QCloudSMHSpaceListResult : NSObject
/** 空间列表 */
@property (nonatomic, strong) NSArray<QCloudSMHSpaceListItem *> *list;
/** 用于顺序列出分页的标识，如果没有更多则不存在该字段 */
@property (nonatomic, strong) NSString *marker;
@end

NS_ASSUME_NONNULL_END
