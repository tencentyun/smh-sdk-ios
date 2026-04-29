//
//  QCloudSMHShareFileListResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHShareFileItem.h"
NS_ASSUME_NONNULL_BEGIN

/// 分享文件列表结果（对应 listShareFiles 响应）
@interface QCloudSMHShareFileListResult : NSObject
/** 文件/目录列表数组 */
@property (nonatomic, strong) NSArray<QCloudSMHShareFileItem *> *contents;
/** 分页标记，用于获取下一页，无更多数据时为空字符串 */
@property (nonatomic, strong) NSString *marker;
/** 是否还有更多数据 */
@property (nonatomic, assign) BOOL hasMore;
@end
NS_ASSUME_NONNULL_END
