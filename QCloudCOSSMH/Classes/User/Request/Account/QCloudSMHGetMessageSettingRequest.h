//
//  QCloudSMHGetMessageSettingRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHMessageSetting.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取用户接收消息配置
 */
@interface QCloudSMHGetMessageSettingRequest : QCloudSMHUserBizRequest

- (void)setFinishBlock:(void (^)(QCloudSMHMessageSetting * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
