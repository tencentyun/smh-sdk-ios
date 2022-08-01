//
//  QCloudSMHGroupModel.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import "QCloudSMHGroupModel.h"

@implementation QCloudSMHCreateGroupItem
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!dic) {
        return dic;
    }

    NSString *userId = dic[@"userId"];
    if (userId) {
        dic[@"userId"] = @(userId.integerValue);
    }

    NSString *orgId = dic[@"orgId"];
    if (orgId) {
        dic[@"orgId"] = @(orgId.integerValue);
    }
    
    NSString *authRoleId = dic[@"authRoleId"];
    if (authRoleId) {
        dic[@"authRoleId"] = @(authRoleId.integerValue);
    }
    
    NSString *role = QCloudSMHGroupRoleTransferToString([dic[@"role"] integerValue]);
    if (role.length>0) {
        dic[@"role"] = role;
    }
    
    return YES;
}
@end

@implementation QCloudSMHCreateGroupResult

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"groupId" : @"id"};
}

@end

@implementation QCloudSMHCreateGroupCountResult

@end

