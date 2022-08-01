//
//  QCloudSMHBatchCopyRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHBatchCopyInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 批量复制
 */
@interface QCloudSMHBatchCopyRequest : QCloudSMHBizRequest

/// 批量任务信息
@property (nonatomic)NSArray <QCloudSMHBatchCopyInfo *>*batchInfos;

/// 分享链接验证提取码时返回的 accessToken；
@property (nonatomic,assign)NSString * shareAccessToken;

- (void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
