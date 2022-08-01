//
//  QCloudSMHDynamicModel.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/27.
//

#import "QCloudSMHDynamicModel.h"

@implementation QCloudSMHBaseDynamicList
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHDynamicListContent.class,@"total":QCloudSMHDynamicListTotal.class,@"lastHit":QCloudSMHDynamicListContent.class};
}
@end

@implementation QCloudSMHSpaceDynamicList
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    NSMutableDictionary * mParams = [QCloudSMHBaseDynamicList modelContainerPropertyGenericClass].mutableCopy;
    [mParams setValue:QCloudSMHDynamicListContent.class forKey:@"contents"];
    return [mParams copy];
}
@end

@implementation QCloudSMHDynamicListTotal

@end

@implementation QCloudSMHDynamicListContent

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"dynamicId":@"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    NSMutableDictionary * params = [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass].mutableCopy;
    [params addEntriesFromDictionary:@{@"authorityList":QCloudSMHRoleInfo.class}];
    return params.copy;
}

   
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    dic = [super modelCustomWillTransformFromDictionary:dic];
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *logType = transfromDic[@"logType"];
    if (logType && [logType isKindOfClass:[NSString class]] && logType.length > 0) {
        NSInteger value = QCloudSMHDDynamicLogTypeFromString(logType);
        transfromDic[@"logType"] = @(value);
    }
    
    NSString *actionType = transfromDic[@"actionType"];
    if (actionType && [actionType isKindOfClass:[NSString class]] && actionType.length > 0) {
        NSInteger value = QCloudSMHDDynamicActionTypeFromString(actionType);
        transfromDic[@"actionType"] = @(value);
    }
    
    NSString *actionTypeDetail = transfromDic[@"actionTypeDetail"];
    if (actionTypeDetail && [actionTypeDetail isKindOfClass:[NSString class]] && actionTypeDetail.length > 0) {
        NSInteger value = QCloudSMHDynamicActionDetailTypeFromString(actionTypeDetail);
        transfromDic[@"actionTypeDetail"] = @(value);
    }
    
    NSString *objectType = transfromDic[@"objectType"];
    if (objectType && [objectType isKindOfClass:[NSString class]] && objectType.length > 0) {
        NSInteger value = QCloudSMHDDynamicObjectTypeFromString(objectType);
        transfromDic[@"objectType"] = @(value);
    }
    
    NSString *SMHFileTypeenumValue = transfromDic[@"fileType"];
    if (SMHFileTypeenumValue && [SMHFileTypeenumValue isKindOfClass:[NSString class]] && SMHFileTypeenumValue.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(SMHFileTypeenumValue);
        transfromDic[@"fileType"] = @(value);
    }
    
    return transfromDic;
}
@end


@implementation QCloudSMHWorkBenchDynamicList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents": QCloudSMHWorkBenchDynamicListContentItem.class};
}

@end

@implementation QCloudSMHWorkBenchDynamicListContentItem
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list": QCloudSMHWorkBenchDynamicListContentItemDetail.class};
}
@end

@implementation QCloudSMHWorkBenchDynamicListContentItemDetail
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"details": QCloudSMHDynamicListContent.class};
}
@end

