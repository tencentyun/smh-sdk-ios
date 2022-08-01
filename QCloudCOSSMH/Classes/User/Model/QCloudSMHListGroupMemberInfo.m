//
//  QCloudSMHListGroupMemberInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import "QCloudSMHListGroupMemberInfo.h"

@implementation QCloudSMHListGroupMemberInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHListGroupMember.class};
}
@end

@implementation QCloudSMHListGroupMember

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *groupRole = transfromDic[@"groupRole"];
    if (groupRole && [groupRole isKindOfClass:[NSString class]] && groupRole.length > 0) {
        NSInteger value = QCloudSMHGroupRoleFromString(groupRole);
        transfromDic[@"groupRole"] = @(value);
    }
    return transfromDic;
}

@end
