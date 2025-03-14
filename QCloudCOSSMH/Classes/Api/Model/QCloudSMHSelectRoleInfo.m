//
//  QCloudSMHSelectRoleInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/27.
//

#import "QCloudSMHSelectRoleInfo.h"

@implementation QCloudSMHSelectRoleInfo
-(id)initWithType:(QCloudSMHRoleType)type targetId:(NSString *)targetId roleId:(NSInteger)roleId name:(NSString *)name{
    if (self = [super init]) {
        _type = type;
        _targetId = targetId;
        _roleId = roleId;
        _name = name;
    }
    return self;
}
@end
