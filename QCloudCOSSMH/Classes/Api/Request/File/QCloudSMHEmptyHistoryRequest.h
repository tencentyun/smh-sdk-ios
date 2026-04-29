//
//  QCloudSMHEmptyHistoryRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHEmptyHistoryResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 清空历史版本
 用于清空整个 library 的历史版本，请求此接口时，需要先关闭历史版本。
 注意：此接口会清空整个 library 全部文件的历史版本，相应的空间会释放，不可找回数据，请谨慎操作！
 此接口有频控限制，每分钟最多调用 1 次，请勿频繁调用。
 权限要求：admin 权限。
 该接口不需要 SpaceId 参数。
 */
@interface QCloudSMHEmptyHistoryRequest : QCloudSMHBizRequest

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHEmptyHistoryResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
