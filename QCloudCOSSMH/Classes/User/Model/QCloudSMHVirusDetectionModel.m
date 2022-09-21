//
//  QCloudSMHVirusDetectionModel.m
//  Pods-QCloudSMHDemo
//
//  Created by garenwang on 2022/8/25.
//

#import "QCloudSMHVirusDetectionModel.h"

@implementation QCloudSMHVirusDetectionInput

@end

@implementation QCloudSMHListVirusDetectionInput


@end

@implementation QCloudVirusDetectionFileList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"contents" : QCloudSMHContentInfo.class};
}

@end
