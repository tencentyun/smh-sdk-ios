//
//  QCloudSMHUserDetailInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserDetailInfo.h"

@implementation QCloudSMHUserDetailInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"teams" : QCloudSMHUserDetailInfoTeamItem.class,
             @"wechatUser":QCloudSMHUserDetailWechatUser.class ,
             @"thirdPartyAuthList":QCloudSMHUserThirdPartyAuthListInfo.class};
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

@implementation QCloudSMHUserDetailInfoTeamItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"teamId" : @"id"};
}
@end

@implementation QCloudSMHUserDetailWechatUser

@end

@implementation QCloudSMHUserThirdPartyAuthListInfo

@end
