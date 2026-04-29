//
//  QCloudSMHDeltaCursorInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 增量游标信息
@interface QCloudSMHDeltaCursorInfo : NSObject
/** 游标值，用于后续查询增量变动 */
@property (nonatomic, strong) NSString *cursor;
@end
NS_ASSUME_NONNULL_END
