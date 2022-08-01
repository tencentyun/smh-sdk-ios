//
//  QCloudSMHDeleteHistoryVersionRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 删除历史版本文件
 */
@interface QCloudSMHDeleteHistoryVersionRequest : QCloudSMHBizRequest

/**
 历史版本 ID
 */
@property (nonatomic)NSArray <NSString *>*historyIds;
@end

NS_ASSUME_NONNULL_END
