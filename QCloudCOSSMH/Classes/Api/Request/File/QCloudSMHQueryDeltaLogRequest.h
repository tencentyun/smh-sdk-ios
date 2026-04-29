//
//  QCloudSMHQueryDeltaLogRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHDeltaLogResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查询增量变动日志
 用于根据增量游标（cursor）拉取文件系统的增量变更日志列表，返回从 cursor 位置之后发生的所有文件/目录变动事件。
 返回的新 cursor 可用于下次请求，实现连续的增量同步。
 */
@interface QCloudSMHQueryDeltaLogRequest : QCloudSMHBizRequest

/// 增量游标，首次调用传获取增量游标接口返回的 cursor，后续传上次返回的 cursor，必选参数
@property (nonatomic, strong) NSString *cursor;

/// 用于分页时本次拉取的项目数限制，默认 100，最大 1000，可选参数
@property (nonatomic, assign) NSInteger limit;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHDeltaLogResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
