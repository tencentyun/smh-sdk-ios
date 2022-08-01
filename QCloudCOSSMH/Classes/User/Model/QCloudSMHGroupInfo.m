//
//  QCloudSMHGroupInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import "QCloudSMHGroupInfo.h"

@implementation QCloudSMHGroupInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"groupId" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"owner" : QCloudSMHGroupOwnerInfo.class,@"extensionData":QCloudSMHGroupExtensionDataInfo.class ,@"roleList":QCloudSMHGroupRoleListItem.class};
}

@end

@implementation QCloudSMHGroupOwnerInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}

@end

@implementation QCloudSMHGroupRoleListItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"roleId" : @"id"};
}
@end


@implementation QCloudSMHGroupExtensionDataInfo


@end
