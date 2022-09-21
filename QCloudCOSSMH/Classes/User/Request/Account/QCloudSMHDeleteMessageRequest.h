//
//  QCloudSMHDeleteMessageRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于删除指定消息
 */
@interface QCloudSMHDeleteMessageRequest : QCloudSMHUserBizRequest
/**
 消息 ID；
 */
@property (nonatomic,copy)NSString *messageId;



@end

NS_ASSUME_NONNULL_END
