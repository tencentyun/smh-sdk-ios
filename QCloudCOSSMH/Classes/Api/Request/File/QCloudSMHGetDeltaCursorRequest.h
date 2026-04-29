//
//  QCloudSMHGetDeltaCursorRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHDeltaCursorInfo.h"
NS_ASSUME_NONNULL_BEGIN
/// 获取增量游标
/// @discussion 用于获取当前最新的增量游标（cursor），该 cursor 标记了当前变更日志的最新位置。
/// 调用方可保存此 cursor，后续作为增量查询变动日志接口的起始位置，从该位置开始拉取增量变更。
@interface QCloudSMHGetDeltaCursorRequest : QCloudSMHBizRequest

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHDeltaCursorInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
