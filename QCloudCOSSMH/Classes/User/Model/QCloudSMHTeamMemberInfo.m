//
//  QCloudSMHTeamMemberInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/19.
//

#import "QCloudSMHTeamMemberInfo.h"
#import "QCloudSMHTeamInfo.h"
#import "QCloudSMHTeamInfo.h"
@implementation QCloudSMHTeamContentInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHTeamMemberInfo.class};
}

@end

@implementation QCloudSMHTeamMemberInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"userId" : @"id",
    };
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"teams" : QCloudSMHTeamInfo.class};
}

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
