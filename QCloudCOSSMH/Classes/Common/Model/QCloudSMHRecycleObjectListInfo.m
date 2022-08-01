//
//  QCloudSMHRecycleObjectListInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHRecycleObjectListInfo.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHTeamInfo.h"
#import "NSObject+Equal.h"

@implementation QCloudSMHRecycleObjectItemInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths" : @"originalPath",@"detailPaths" : @"path"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass];
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    [super modelCustomTransformToDictionary:dic];
    NSString *SMHContentInfoTypeValue = dic[@"type"];
    if (SMHContentInfoTypeValue) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHContentInfoTypeValue intValue]);
        if (value) {
            dic[@"type"] = value;
        }
    }
    
    NSString *SMHFileTypeValue = dic[@"fileType"];
    if (SMHFileTypeValue) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHContentInfoTypeValue intValue]);
        if (value) {
            dic[@"fileType"] = value;
        }
    }
    return YES;
}


- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    dic = [super modelCustomWillTransformFromDictionary:dic];
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

- (BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}

@end
@implementation QCloudSMHRecycleObjectListInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"contents" : QCloudSMHRecycleObjectItemInfo.class,@"authorityList":QCloudSMHRoleInfo.class};
}
- (BOOL)isEqual:(id)object{
    return [self smh_isEqual:object];
}
@end

