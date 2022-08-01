//
//  QCloudSMHFavoriteResult.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/13.
//

#import "QCloudSMHFavoriteResult.h"
#import "QCloudSMHFavoriteInfo.h"

@implementation QCloudSMHFavoriteResult

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    

    return @{@"contents" : QCloudSMHFavoriteInfo.class};

    
}
@end


@implementation QCloudSMHFavoriteGroupInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"favoriteGroupid" : @"id"};
}

@end

@implementation QCloudSMHFavoriteGroupList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"contents" : QCloudSMHFavoriteInfo.class};
}

@end

@implementation QCloudSMHCreateFavoriteGroupResult
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"favoriteGroupid" : @"id"};
}

@end

