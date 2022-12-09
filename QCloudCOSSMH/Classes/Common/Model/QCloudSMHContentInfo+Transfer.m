//
//  QCloudSMHContentInfo+Transfer.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/11/7.
//

#import "QCloudSMHContentInfo+Transfer.h"
#import <objc/runtime.h>
@implementation QCloudSMHContentInfo (Transfer)

- (BOOL)isQuickUpload{
    NSNumber * temp = objc_getAssociatedObject(self,@"isQuickUpload");
    return temp.boolValue;
}

- (void)setIsQuickUpload:(BOOL)isQuickUpload{
    objc_setAssociatedObject(self , @"isQuickUpload", @(isQuickUpload), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
