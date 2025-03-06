//
//  QCloudSMHSpaceHomeFileInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import "QCloudSMHSpaceHomeFileInfo.h"

@implementation QCloudSMHSpaceHomeFileInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"contents" : QCloudSMHContentInfo.class};
}
@end
