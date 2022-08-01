//
//  QCloudSMHBaseContentInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/15.
//

#import "QCloudSMHBaseContentInfo.h"
#import "QCloudSpaceTagEnum.h"
@implementation QCloudSMHContentGroupInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"groupId" : @"id"};
}

@end

@implementation QCloudSMHBaseContentInfo

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *spaceTag = dic[@"spaceTag"];
    if (spaceTag) {
        NSString *value = QCloudSMHQCloudSpaceTagTransferToString([spaceTag intValue]);
        if (value) {
            dic[@"spaceTag"] = value;
        }
    }
    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *spaceTag = transfromDic[@"spaceTag"];
    if (spaceTag != nil) {
        NSInteger value = QCloudSMHQCloudSpaceTagFromString(spaceTag);
        transfromDic[@"spaceTag"] = @(value);
    }
    
    return transfromDic.copy;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    return @{@"team":QCloudSMHTeamInfo.class,
             @"user":QCloudSMHUserInfo.class,
             @"group":QCloudSMHContentGroupInfo.class};

}
@end

