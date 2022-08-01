//
//  QCloudSMHMarkMessageHasReadRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHMessageTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN

/**
 批量标记已读
 */
@interface QCloudSMHMarkMessageHasReadRequest : QCloudSMHUserBizRequest

/// 批量已读 消息 id 集合
@property (nonatomic,strong)NSArray <NSString *>*messageIds;

/// 是否全部标记为已读 当allread为YES时，messageIds无效
@property (nonatomic,assign)BOOL allRead;

/// 消息类型，0 所有（默认），1 系统消息，2 告警消息，可选；
@property (nonatomic,assign)QCloudSMHMessageType messageType;
@end

NS_ASSUME_NONNULL_END
