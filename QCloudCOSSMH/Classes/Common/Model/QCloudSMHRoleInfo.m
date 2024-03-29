//
//  QCloudSMHRoleInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/25.
//

#import "QCloudSMHRoleInfo.h"
#import "NSObject+Equal.h"
@implementation QCloudSMHRoleInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"roleId" : @"id"};
}

- (BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}

@end

@implementation QCloudSMHButtonAuthority

@end
