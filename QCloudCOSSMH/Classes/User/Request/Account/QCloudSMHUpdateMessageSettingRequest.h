//
//  QCloudSMHUpdateMessageSettingRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUserBizRequest.h"


NS_ASSUME_NONNULL_BEGIN
/**
 修改用户接收消息配置
 */
@interface QCloudSMHUpdateMessageSettingRequest : QCloudSMHUserBizRequest


///  是否开启权限或设置消息
@property (nonatomic,assign)BOOL authorityAndSettingMsg;

///  是否开启外链消息
@property (nonatomic,assign)BOOL shareMsg;

///  是否开启电子签消息
@property (nonatomic,assign)BOOL esignMsg;

///  是否开启用户管理消息
@property (nonatomic,assign)BOOL userManageMsg;

///  是否开启扩容或续期消息
@property (nonatomic,assign)BOOL quotaAndRenewMsg;

@end

NS_ASSUME_NONNULL_END
