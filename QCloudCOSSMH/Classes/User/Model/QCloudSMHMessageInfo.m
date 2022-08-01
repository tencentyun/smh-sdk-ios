//
//  QCloudSMHMessageInfo.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHMessageInfo.h"

@implementation QCloudSMHMessageInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"messageID" : @"id",
    };
}
@end
