//
//  QCloudSMHShareUserInfo.m
//  Pods
//
//  Created by garenwang on 2021/11/25.
//

#import "QCloudSMHShareUserInfo.h"

@implementation QCloudSMHShareUserInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"shareId" : @"id"};

}

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
