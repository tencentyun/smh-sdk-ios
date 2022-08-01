//
//  QCloudTagModel.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/7.
//

#import "QCloudTagModel.h"
#import "QCloudSMHContentInfo.h"

@implementation QCloudTagModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"tagId" : @"id"};

}
@end

@implementation QCloudFileTagItemModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"tagId" : @"id"};

}
@end

@implementation QCloudFileQueryTagModel
@end

@implementation QCloudQueryTagFilesInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"contents" : QCloudSMHContentInfo.class};
}
@end

