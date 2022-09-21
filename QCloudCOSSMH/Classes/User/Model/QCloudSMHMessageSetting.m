//
//  QCloudSMHMessageSetting.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/8/23.
//

#import "QCloudSMHMessageSetting.h"

@implementation QCloudSMHMessageSetting
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"receiveMessageConfig":QCloudSMHMessageSettingReceiveMessageConfig.class};
}
@end

@implementation QCloudSMHMessageSettingReceiveMessageConfig

@end

