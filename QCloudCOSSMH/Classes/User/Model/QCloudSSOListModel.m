//
//  QCloudSSOListModel.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/1/10.
//

#import "QCloudSSOListModel.h"

@implementation QCloudSSOListItem

@end

@implementation QCloudSSOListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"defaultType" : @"default"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list" : QCloudSSOListItem.class};
}

@end
