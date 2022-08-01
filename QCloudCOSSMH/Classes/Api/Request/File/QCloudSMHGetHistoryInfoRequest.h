//
//  QCloudSMHGetHistoryInfoRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHHistoryStateInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于查询历史版本配置信息
 */
@interface QCloudSMHGetHistoryInfoRequest : QCloudSMHBizRequest

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHHistoryStateInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
