//
//  QCloudSMHUploadStateInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/18.
//

#import "QCloudSMHUploadStateInfo.h"
#import "QCloudSMHInitUploadInfo.h"

@implementation QCloudSMHUploadStateInfo
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    
    return @{@"path" : NSArray.class,
             @"parts":QCloudSMHUploadStatePartsInfo.class,
             @"uploadPartInfo":QCloudSMHInitUploadInfo.class};

}
@end

@implementation QCloudSMHUploadStatePartsInfo


@end


