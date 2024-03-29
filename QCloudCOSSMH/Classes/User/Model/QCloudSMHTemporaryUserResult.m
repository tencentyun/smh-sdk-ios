//
//  QCloudSMHTemporaryUserResult.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/10.
//

#import "QCloudSMHTemporaryUserResult.h"

@implementation QCloudSMHTemporaryUserResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"contents" : QCloudSMHTemporaryUserItem.class};
}
@end

@implementation QCloudSMHTemporaryUserItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"userId" : @"id"};
}

@end

