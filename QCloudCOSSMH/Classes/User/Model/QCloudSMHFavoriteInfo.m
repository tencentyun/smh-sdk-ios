//
//  QCloudSMHFavoriteInfo.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/13.
//

#import "QCloudSMHFavoriteInfo.h"

@implementation QCloudSMHFavoriteInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths":@"path",@"favoriteId":@"id"};
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    NSMutableDictionary * params = [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass].mutableCopy;
    [params addEntriesFromDictionary:@{@"group":QCloudSMHContentGroupInfo.class}];
    [params addEntriesFromDictionary:@{@"authorityList" : QCloudSMHRoleInfo.class}];
    [params addEntriesFromDictionary:@{@"authorityButtonList":QCloudSMHButtonAuthority.class}];
    return params;

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
@end
