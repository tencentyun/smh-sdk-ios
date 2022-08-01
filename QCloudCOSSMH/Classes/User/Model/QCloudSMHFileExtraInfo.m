//
//  QCloudSMHFileExtraInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/9.
//

#import "QCloudSMHFileExtraInfo.h"

@implementation QCloudSMHFileExtraInfo

@end

@implementation QCloudSMHFileExtraReqInfo

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!dic) {
        return dic;
    }

    NSString *spaceOrgId = dic[@"spaceOrgId"];
    if (spaceOrgId) {
        dic[@"spaceOrgId"] = @(spaceOrgId.integerValue);
    }

    return YES;
}

@end

