//
//  QCloudHistorVersionInfo.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHHistoryVersionInfo.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHContentInfo.h"
@implementation QCloudSMHHistoryVersionInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"versionID" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"contents" : QCloudSMHContentInfo.class,@"authorityList" : QCloudSMHRoleInfo.class,@"authorityButtonList":QCloudSMHButtonAuthority.class};
}
@end
