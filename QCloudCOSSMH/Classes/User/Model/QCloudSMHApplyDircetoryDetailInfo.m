//
//  QCloudSMHApplyDircetoryDetailInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import "QCloudSMHApplyDircetoryDetailInfo.h"

@implementation QCloudSMHApplyDircetoryDetailInfo


- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *spaceTag = dic[@"spaceTag"];
    if (spaceTag) {
        NSString *value = QCloudSMHQCloudSpaceTagTransferToString([spaceTag intValue]);
        if (value) {
            dic[@"spaceTag"] = value;
        }
    }
    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *spaceTag = transfromDic[@"spaceTag"];
    if (spaceTag != nil) {
        NSInteger value = QCloudSMHQCloudSpaceTagFromString(spaceTag);
        transfromDic[@"spaceTag"] = @(value);
    }
    
    return transfromDic.copy;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"applyId" : @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"canAuditUsers" : QCloudSMHListAppleDirectoryResultCanAuditUsers.class,
             @"createByBelongLatestTeam":QCloudSMHApplyDircetoryDetailCreateByBelongLatestTeam.class,
             @"directoryList":QCloudSMHApplyDircetoryDetailDirectoryList.class,
             @"extensionData":QCloudSMHApplyDircetoryDetailextensionData.class,
             @"roleInfo":QCloudSMHApplyDircetoryDetailRoleInfo.class,
             @"team":QCloudSMHTeamInfo.class,
          @"user":QCloudSMHUserInfo.class,
          @"group":QCloudSMHContentGroupInfo.class,
    };
}

- (void)setDirectoryPath:(NSArray<NSString *> *)directoryPath{
    NSMutableArray * tempDirectoryPath = [NSMutableArray new];
    for(id path in directoryPath){
        [tempDirectoryPath addObject:[NSString stringWithFormat:@"%@",path]];
    }
    _directoryPath = [tempDirectoryPath copy];
}

@end

@implementation QCloudSMHApplyDircetoryDetailCreateByBelongLatestTeam

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"teamId" : @"id"};
}

@end

@implementation QCloudSMHApplyDircetoryDetailextensionData
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{@"directoryList":QCloudSMHApplyDircetoryExtDetailDirectoryList.class};
}
@end

@implementation QCloudSMHApplyDircetoryExtDetailDirectoryList
- (void)setOldRoleIds:(NSArray<NSString *> *)oldRoleIds{
    NSMutableArray * tempRoldIds = [NSMutableArray new];
    for(id roldId in oldRoleIds){
        [tempRoldIds addObject:[NSString stringWithFormat:@"%@",roldId]];
    }
    _oldRoleIds = [tempRoldIds copy];
}

@end

@implementation QCloudSMHApplyDircetoryDetailRoleInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"teamId" : @"id"};
}
@end

@implementation QCloudSMHApplyDircetoryDetailDirectoryList

- (void)setOldRoleIds:(NSArray<NSString *> *)oldRoleIds{
    NSMutableArray * tempRoldIds = [NSMutableArray new];
    for(id roldId in oldRoleIds){
        [tempRoldIds addObject:[NSString stringWithFormat:@"%@",roldId]];
    }
    _oldRoleIds = [tempRoldIds copy];
}

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
@end

