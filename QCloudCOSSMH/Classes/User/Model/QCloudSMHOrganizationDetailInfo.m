//
//  QCloudSMHOrganizationDetailInfo.m
//  Pods
//
//  Created by garenwang on 2021/12/7.
//

#import "QCloudSMHOrganizationDetailInfo.h"
#import "NSObject+Equal.h"

@implementation QCloudSMHOrganizationDetailInfo


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"extensionData":QCloudSMHOrgExtensionData.class,@"domains":QCloudSMHOrgExtDomains.class};
}
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

@implementation QCloudSMHOrgExtensionData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"defaultTeamOptions" : QCloudSMHOrgExtDefaultTeamOptions.class,
             @"defaultUserOptions":QCloudSMHOrgExtDefaultUserOptions.class,
             @"watermarkOptions":QCloudSMHOrgExtWatermarkOptions.class,
             @"editionConfig":QCloudSMHOrgEditionConfig.class
    };
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
    
    NSString *channelFlag = transfromDic[@"channelFlag"];
    if (channelFlag && [channelFlag isKindOfClass:[NSString class]] && channelFlag.length > 0) {
        NSInteger value = QCloudSMHChannelFlagFromString(channelFlag);
        transfromDic[@"channelFlag"] = @(value);
    }
    id enableDocPreviewValue = transfromDic[@"enableDocPreview"];
    if (!enableDocPreviewValue) {
        transfromDic[@"enableDocPreview"] = @(YES);
    }
    id enableDocEditValue = transfromDic[@"enableDocEdit"];
    if (!enableDocEditValue) {
        transfromDic[@"enableDocEdit"] = @(YES);
    }

    return transfromDic;
}

-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}

@end


@implementation QCloudSMHOrgExtDefaultTeamOptions
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

@implementation QCloudSMHOrgExtDefaultUserOptions
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

@implementation QCloudSMHOrgExtWatermarkOptions
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

@implementation QCloudSMHOrgExtDomains
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

@implementation QCloudSMHOrgEditionConfig
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
-(BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

