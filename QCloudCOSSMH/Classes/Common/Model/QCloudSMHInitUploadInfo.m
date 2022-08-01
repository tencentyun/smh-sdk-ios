//
//  QCloudSMHInitUploadInfo.m
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHInitUploadInfo.h"

@implementation QCloudSMHInitUploadInfo

-(BOOL)shouldRefreshWithOffest:(NSInteger)offset{
    int timeInstence = [self.expiration timeIntervalSince1970] - offset - [NSDate.date timeIntervalSince1970];
    // 提前5分钟刷新缓存
    if (timeInstence > 5 * 60) {
        return NO;
    }
    return YES;
}

@end
