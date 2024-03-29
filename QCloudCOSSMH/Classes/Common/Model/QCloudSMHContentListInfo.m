//
//  CBContentListInfo.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import "QCloudSMHContentListInfo.h"
#import "QCloudSMHContentInfo.h"
@implementation QCloudSMHContentListInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths" : @"path"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    

    return @{@"contents" : QCloudSMHContentInfo.class,@"authorityList" : QCloudSMHRoleInfo.class,@"authorityButtonList":QCloudSMHButtonAuthority.class};

    
}

@end
