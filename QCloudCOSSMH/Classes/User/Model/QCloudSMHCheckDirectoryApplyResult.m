//
//  QCloudSMHCheckDirectoryApplyResult.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import "QCloudSMHCheckDirectoryApplyResult.h"

@implementation QCloudSMHCheckDirectoryApplyResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"directoryList" : QCloudSMHCheckDirectoryApplyItem.class};
}

@end

@implementation QCloudSMHCheckDirectoryApplyItem
- (void)setOldRoleIds:(NSArray<NSString *> *)oldRoleIds{
    NSMutableArray * tempRoldIds = [NSMutableArray new];
    for(id roldId in oldRoleIds){
        [tempRoldIds addObject:[NSString stringWithFormat:@"%@",roldId]];
    }
    _oldRoleIds = [tempRoldIds copy];
}
@end


@implementation QCloudSMHAppleDirectoryResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"successItems" : QCloudSMHAppleDirectoryResultItem.class,@"failedItems" : QCloudSMHAppleDirectoryResultItem.class};
}
@end

@implementation QCloudSMHAppleDirectoryResultItem

@end

@implementation QCloudSMHListAppleDirectoryResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHListAppleDirectoryResultItem.class};
}
@end

@implementation QCloudSMHListAppleDirectoryResultItem
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"canAuditUsers" : QCloudSMHListAppleDirectoryResultCanAuditUsers.class,@"directoryList":QCloudSMHListAppleDirectoryResultdirectoryList.class};
}
@end

@implementation QCloudSMHListAppleDirectoryResultCanAuditUsers
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}
@end


@implementation QCloudSMHListAppleDirectoryResultdirectoryList
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *SMHContentInfoTypeValue = dic[@"type"];
    if (SMHContentInfoTypeValue) {
        NSString *value = QCloudSMHContentInfoTypeTransferToString([SMHContentInfoTypeValue intValue]);
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
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(COSAccountTypeenumValue);
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

