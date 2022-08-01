//
//  QCloudSMHSearchListInfo.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHSearchListInfo.h"
#import "QCloudSMHContentInfo.h"
@implementation QCloudSMHSearchListInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"contents" : QCloudSMHContentInfo.class};
}
@end

@implementation QCloudSMHSearchTag

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{ @"tagId" : @"id" , @"tagValue" : @"value" };
}
@end
