//
//  QCloudSMHSaveShareFileResult.m
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import "QCloudSMHSaveShareFileResult.h"

@implementation QCloudSMHSaveShareFileItemResult

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"sourcePath" : @"copyFrom"};
}

@end

@implementation QCloudSMHSaveShareFileResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"result" : [QCloudSMHSaveShareFileItemResult class],
    };
}

@end
