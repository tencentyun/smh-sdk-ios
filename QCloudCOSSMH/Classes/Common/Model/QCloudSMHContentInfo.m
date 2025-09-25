//
//  CBContetInfo.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import "QCloudSMHContentInfo.h"
@implementation QCloudSMHContentInfo


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



+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    NSMutableDictionary * params = [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass].mutableCopy;
    [params addEntriesFromDictionary:@{@"authorityList" : QCloudSMHRoleInfo.class,@"highlight":QCloudSMHHighLightInfo.class,@"localSync":QCloudSMHLocalSync.class,@"tagList":QCloudFileTagItemModel.class,@"authorityButtonList":QCloudSMHButtonAuthority.class}];
    return params.copy;

}
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    dic = [super modelCustomWillTransformFromDictionary:dic];
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
    
    NSString *authType = transfromDic[@"authType"];
    if (authType) {
        transfromDic[@"authType"] = @(authType.integerValue + 1);
    }
    
    return transfromDic;
}
@end

@implementation QCloudSMHLocalSync

@end

@implementation QCloudSMHFileInputInfo
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic{
    return dic;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic{
    [dic setObject:[dic[@"isDirectory"] boolValue]?@"dir":@"file" forKey:@"type"];
    [dic removeObjectForKey:@"isDirectory"];
    return YES;
}

@end

@implementation QCloudSMHListFileInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"contents" : QCloudSMHContentInfo.class};

}

@end


