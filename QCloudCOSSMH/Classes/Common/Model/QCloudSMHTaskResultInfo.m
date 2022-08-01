//
//  QCloudSMHBatchResultInfo.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHTaskResultInfo.h"

@implementation QCloudSMHTaskResultInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths" : @"path"};
}


@end
