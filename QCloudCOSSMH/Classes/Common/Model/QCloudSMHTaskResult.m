//
//  QCloudSMHTaskResult.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHTaskResult.h"
#import "QCloudSMHTaskResultInfo.h"
#import "QCloudSMHBatchTaskStatusEnum.h"
@implementation QCloudSMHTaskResult

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"fromPaths" : @"copyFrom",
             @"toPaths":@"to",
             @"paths":@"path"
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    
    return @{@"path" : NSArray.class,
             @"to":NSArray.class,
             @"copyFrom":NSArray.class
    };

}


- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *COSAccountTypeenumValue = transfromDic[@"status"];
    if (COSAccountTypeenumValue && [COSAccountTypeenumValue isKindOfClass:[NSString class]] && COSAccountTypeenumValue.length > 0) {
        QCloudSMHBatchTaskStatus value = QCloudSMHBatchTaskStatusTypeFromStatus(COSAccountTypeenumValue.integerValue);
        transfromDic[@"status"] = @(value);
    }
    return transfromDic;
}
@end
