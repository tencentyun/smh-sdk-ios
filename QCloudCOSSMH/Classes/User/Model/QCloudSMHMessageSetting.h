//
//  QCloudSMHMessageSetting.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/8/23.
//

#import <Foundation/Foundation.h>
@class QCloudSMHMessageSettingReceiveMessageConfig;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHMessageSetting : NSObject
@property (nonatomic,strong)QCloudSMHMessageSettingReceiveMessageConfig * receiveMessageConfig;
@end

@interface QCloudSMHMessageSettingReceiveMessageConfig : NSObject

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
