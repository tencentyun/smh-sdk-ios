//
//  QCloudSMHSpaceInfo.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHSpaceInfo.h"
#import <objc/runtime.h>

@implementation QCloudSMHSpaceInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{

    return @{@"path" : NSArray.class};

}
@end

@implementation QCloudSMHSpaceInfo (BeginDate)

- (NSDate *)beginDate{
    return objc_getAssociatedObject(self, @"beginDate");
}

- (void)setBeginDate:(NSDate *)beginDate{
    objc_setAssociatedObject(self, @"beginDate", beginDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
