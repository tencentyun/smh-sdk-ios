//
//  QCloudFileAutthorityInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/27.
//

#import "QCloudFileAutthorityInfo.h"
#import "QCloudSMHTeamMemberInfo.h"
#import "QCloudSMHTeamInfo.h"
@implementation QCloudFileAutthorityInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"user" : QCloudSMHTeamMemberInfo.class,@"team":QCloudSMHTeamInfo.class};
}
@end

