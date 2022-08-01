//
//  QCloudSMHOrganizationsInfo.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHOrganizationsInfo.h"

@implementation QCloudSMHOrganizationsInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{

    return @{@"organizations" : QCloudSMHOrganizationInfo.class};

}
@end
