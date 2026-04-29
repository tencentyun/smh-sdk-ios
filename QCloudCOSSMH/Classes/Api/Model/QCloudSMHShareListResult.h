//
//  QCloudSMHShareListResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHShareInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 分享列表结果（对应 listShares 响应）
@interface QCloudSMHShareListResult : NSObject
/** 分享列表数组 */
@property (nonatomic, strong) NSArray<QCloudSMHShareInfo *> *contents;
/** 分页标记，用于获取下一页 */
@property (nonatomic, strong) NSString *marker;
/** 是否还有更多数据 */
@property (nonatomic, assign) BOOL hasMore;
@end
NS_ASSUME_NONNULL_END
