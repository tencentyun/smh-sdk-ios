//
//  QCloudSMHMesssageListResult.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHMesssageListResult.h"

@implementation QCloudSMHMesssageListResult
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contents" : QCloudSMHMessageInfo.class};
}
@end
