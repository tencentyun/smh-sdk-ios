//
//  QCloudSMHCrossSpaceRecycleItem.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/24.
//

#import "QCloudSMHCrossSpaceRecycleItem.h"

@implementation QCloudSMHCrossSpaceRecycleItem

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    
    NSString *SMHContentInfoTypeValue = dic[@"type"];
    if (SMHContentInfoTypeValue) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHContentInfoTypeValue intValue]);
        if (value) {
            dic[@"type"] = value;
        }
    }
    
    NSString *SMHFileTypeValue = dic[@"fileType"];
    if (SMHFileTypeValue) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHFileTypeValue intValue]);
        if (value) {
            dic[@"fileType"] = value;
        }
    }
    
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

    NSString *type = transfromDic[@"type"];
    if (type && [type isKindOfClass:[NSString class]] && type.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(type);
        transfromDic[@"type"] = @(value);
    }
    NSString *fileType = transfromDic[@"fileType"];
    if (fileType && [fileType isKindOfClass:[NSString class]] && fileType.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(fileType);
        transfromDic[@"fileType"] = @(value);
    }
    
    NSString *spaceTag = transfromDic[@"spaceTag"];
    if (spaceTag && [spaceTag isKindOfClass:[NSString class]] && spaceTag.length > 0) {
        NSInteger value = QCloudSMHQCloudSpaceTagFromString(spaceTag);
        transfromDic[@"spaceTag"] = @(value);
    }
    return transfromDic;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
        @"team":QCloudSMHTeamInfo.class,@"user":QCloudSMHUserInfo.class,@"group":QCloudSMHContentGroupInfo.class,@"authorityList":QCloudSMHRoleInfo.class,@"authorityButtonList":QCloudSMHButtonAuthority.class
    };
}
@end

@implementation QCloudSMHCrossSpaceRecycleInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHCrossSpaceRecycleItem.class};
}
@end

@implementation QCloudSMHBatchInputRecycleInfo

@end
