//
//  QCloudSMHOrganizationShareList.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import "QCloudSMHOrganizationShareList.h"
@implementation QCloudSMHOrganizationShareList
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHOrganizationShareListItem.class};
}
@end

@implementation QCloudSMHOrganizationShareListItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"shareId" : @"id"};
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *SMHContentInfoTypeValue = dic[@"type"];
    if (SMHContentInfoTypeValue) {
        NSString *value = QCloudSMHShareFileTypeTransferToString([SMHContentInfoTypeValue intValue]);
        if (value) {
            dic[@"type"] = value;
        }
    }
    
    NSString *fileType = dic[@"fileType"];
    if (fileType) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([fileType intValue]);
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
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *COSAccountTypeenumValue = transfromDic[@"type"];
    if (COSAccountTypeenumValue && [COSAccountTypeenumValue isKindOfClass:[NSString class]] && COSAccountTypeenumValue.length > 0) {
        NSInteger value = QCloudSMHShareFileTypeFromString(COSAccountTypeenumValue);
        transfromDic[@"type"] = @(value);
    }
    
    
    NSString *fileType = transfromDic[@"fileType"];
    if (fileType && [fileType isKindOfClass:[NSString class]] && fileType.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(fileType);
        transfromDic[@"fileType"] = @(value);
    }
    
    return transfromDic;
}

@end
