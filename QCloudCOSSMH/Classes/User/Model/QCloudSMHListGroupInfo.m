//
//  QCloudSMHListGroupInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import "QCloudSMHListGroupInfo.h"

@implementation QCloudSMHListGroupInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHListGroupItem.class};
}

@end


@implementation QCloudSMHListGroupItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"groupId" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"directoryList" : QCloudSMHListGroupFileItem.class,@"authorityList":QCloudSMHRoleInfo.class,@"users":QCloudSMHListGroupMember.class};
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
    
    
    NSString *editionFlag = transfromDic[@"orgEditionFlag"];
    if (editionFlag && [editionFlag isKindOfClass:[NSString class]] && editionFlag.length > 0) {
        NSInteger value = QCloudSMHOrganizationTypeFromString(editionFlag);
        transfromDic[@"orgEditionFlag"] = @(value);
    }
    
    return transfromDic;
}

@end


@implementation QCloudSMHListGroupFileItem

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *COSAccountTypeenumValue = transfromDic[@"type"];
    if (COSAccountTypeenumValue && [COSAccountTypeenumValue isKindOfClass:[NSString class]] && COSAccountTypeenumValue.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(COSAccountTypeenumValue);
        transfromDic[@"type"] = @(value);
    }
    NSString *SMHFileTypeenumValue = transfromDic[@"fileType"];
    if (SMHFileTypeenumValue && [SMHFileTypeenumValue isKindOfClass:[NSString class]] && SMHFileTypeenumValue.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(SMHFileTypeenumValue);
        transfromDic[@"fileType"] = @(value);
    }
    
    
    return transfromDic;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"authorityList" : QCloudSMHRoleInfo.class};
}

@end

