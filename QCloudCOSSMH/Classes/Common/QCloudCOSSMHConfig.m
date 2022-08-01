//
//  QCloudCOSSMHConfig.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/7.
//

#import "QCloudCOSSMHConfig.h"
static BOOL disableStartBeacon;

static BOOL canUploadBeacon;

@implementation QCloudCOSSMHConfig

+(void)disableSMHStartBeacon:(BOOL)disable{
    disableStartBeacon = disable;
}

+(BOOL)isDisableSMHStartBeacon{
    return disableStartBeacon;
}

+(void)setCanSMHUploadBeacon:(BOOL)can{
    canUploadBeacon = can;
}

+(BOOL)canSMHUploadBeacon{
    return canUploadBeacon;
}

@end
