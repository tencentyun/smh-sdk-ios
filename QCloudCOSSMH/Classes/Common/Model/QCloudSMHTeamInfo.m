//
//  QCloudSMHTeamInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/19.
//

#import "QCloudSMHTeamInfo.h"

@implementation QCloudSMHTeamInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"teamId" : @"id",@"paths":@"path"};

}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"children" : QCloudSMHTeamInfo.class,@"pathNodes":QCloudSMHTeamInfoPathNode.class};
}

- (BOOL)isEqual:(QCloudSMHTeamInfo *)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self.teamId isEqualToString:object.teamId] && [self.orgId isEqualToString:object.orgId];
}

@end



@implementation QCloudSMHTeamInfoPathNode
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"teamId" : @"id"};

}
@end

@implementation QCloudSMHSearchTeamInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHTeamInfo.class};
}
@end

@implementation QCloudSMHSearchTeamResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHTeamInfo.class};
}
@end



