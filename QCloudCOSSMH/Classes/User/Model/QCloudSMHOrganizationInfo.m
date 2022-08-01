//
//  QCloudSMHOrganizationInfo.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHOrganizationInfo.h"

@implementation QCloudSMHOrganizationInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"organizationID" : @"id"
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"extensionData" : QCloudSMHOrgExtensionData.class};
}


@end

@implementation QCloudSMHOrgUser


- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *editionFlag = transfromDic[@"role"];
    if (editionFlag && [editionFlag isKindOfClass:[NSString class]] && editionFlag.length > 0) {
        NSInteger value = QCloudSMHOrgUserRoleTypeFromString(editionFlag);
        transfromDic[@"role"] = @(value);
    }

    return transfromDic;
}


@end
