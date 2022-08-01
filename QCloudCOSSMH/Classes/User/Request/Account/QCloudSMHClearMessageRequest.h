//
//  QCloudSMHClearMessageRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/13.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHMessageTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 删除所有消息
 */
@interface QCloudSMHClearMessageRequest : QCloudSMHUserBizRequest

///  消息类型，0 所有（默认），1 系统消息，2 告警消息，可选；
@property (nonatomic,assign)QCloudSMHMessageType messageType;
@end

NS_ASSUME_NONNULL_END
