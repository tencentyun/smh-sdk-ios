//
//  QCloudSMHPutHisotryVersionRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/17.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 设置历史版本配置信息
 */
@interface QCloudSMHPutHisotryVersionRequest : QCloudSMHBizRequest

/// 布尔型，是否打开历史版本；
@property (nonatomic)BOOL enableFileHistory;

/// 数字，历史版本最大数量；
@property (nonatomic)NSInteger fileHistoryCount;

/// 数字，历史版本过期时间；
@property (nonatomic)NSInteger fileHistoryExpireDay;

/// 布尔型，是否清除历史版本，在关闭历史版本时传入，可选参数；
@property (nonatomic)BOOL isClearFileHistory;
@end

NS_ASSUME_NONNULL_END
