//
//  QCloudSMHShareDetail.m
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import "QCloudSMHShareDetail.h"

@implementation QCloudSMHShareDetailFileInfo
@end

@implementation QCloudSMHShareDetail

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"identifier": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"fileInfo": [QCloudSMHShareDetailFileInfo class],
    };
}

@end
