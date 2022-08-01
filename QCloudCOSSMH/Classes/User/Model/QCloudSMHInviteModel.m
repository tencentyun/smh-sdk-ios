//
//  QCloudSMHInviteModel.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import "QCloudSMHInviteModel.h"

@implementation QCloudSMHInviteGroupCodeInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"inviteId" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"organization" : QCloudSMHInviteOrgInfoModel.class,@"invitor":QCloudSMHInvitorInfoModel.class,@"group":QCloudSMHContentGroupInfo.class};
}
@end


@implementation QCloudSMHInviteOrgCodeInfoModel
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *editionFlag = transfromDic[@"editionFlag"];
    if (editionFlag && [editionFlag isKindOfClass:[NSString class]] && editionFlag.length > 0) {
        NSInteger value = QCloudSMHOrganizationTypeFromString(editionFlag);
        transfromDic[@"editionFlag"] = @(value);
    }

    return transfromDic;
}
@end

@implementation QCloudSMHCodeResult

@end

@implementation QCloudSMHInviteOrgInfoModel

@end

@implementation QCloudSMHInvitorInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}
@end

@implementation QCloudSMHJoinResult

@end



