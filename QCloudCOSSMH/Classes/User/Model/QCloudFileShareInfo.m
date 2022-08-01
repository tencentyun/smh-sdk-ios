//
//  QCloudFileShareInfo.m
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudFileShareInfo.h"

@implementation QCloudFileShareInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    NSMutableDictionary * mdic = [QCloudSMHBaseContentInfo modelContainerPropertyGenericClass].mutableCopy;
    [mdic addEntriesFromDictionary:@{@"directoryInfoList" : QCloudFileShareItem.class,@"authorityList":QCloudSMHRoleInfo.class}];
    return mdic.copy;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"shareId":@"id",@"shareLink":@"url"};
}

@end

@implementation QCloudFileListContent

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudFileShareInfo.class};
}

@end


@implementation QCloudFileShareItem

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic{
    if ([dic objectForKey:@"spaceOrgId"]) {
        [dic setObject:@"spaceOrgId" forKey:@([[dic valueForKey:@"spaceOrgId"] integerValue])];
    }
    
    return YES;
}


@end

@implementation QCloudSMHFileShareResult
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"shareId":@"id",@"shareLink":@"url"};
}
@end

