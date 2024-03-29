//
//  QCloudSMHRecentlyFileListInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import "QCloudSMHRecentlyFileListInfo.h"


@implementation QCloudSMHRecentlyFileListInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHRecentlyFileInfo.class};
}

@end

@implementation QCloudSMHRecentlyFileInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    NSMutableDictionary * params = [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass].mutableCopy;
    [params addEntriesFromDictionary:@{@"authorityList":QCloudSMHRoleInfo.class}];
    [params addEntriesFromDictionary:@{@"authorityButtonList":QCloudSMHButtonAuthority.class}];
    return params.copy;
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

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths" : @"path"};
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
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHFileTypeValue intValue]);
        if (value) {
            dic[@"fileType"] = value;
        }
    }
    
    return YES;
}

@end


    

