//
//  QCloudCOSSMHConfig.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudCOSSMHConfig : NSObject


/// 禁用sdk 启动灯塔，
/// @param disable 是否禁用 disable YES :禁用，NO：不禁用；默认不禁用
+(void)disableSMHStartBeacon:(BOOL)disable;


/// 是否禁用启动灯塔；
+(BOOL)isDisableSMHStartBeacon;


/// 设置是否可以开始上报灯塔，app端在同意隐私协议后调用。
+(void)setCanSMHUploadBeacon:(BOOL)can;


/// 是否可以开始上报灯塔
+(BOOL)canSMHUploadBeacon;

@end

NS_ASSUME_NONNULL_END
