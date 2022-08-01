//
//  QCloudSMHBatchResult.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchResult.h"
#import "QCloudSMHTaskResult.h"
@implementation QCloudSMHBatchResult


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass

{
    

    return @{@"result" : QCloudSMHTaskResult.class};

}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSNumber *status = transfromDic[@"status"];
    if (status != nil) {
        NSInteger value = QCloudSMHBatchTaskStatusTypeFromStatus(status.integerValue);
        transfromDic[@"status"] = @(value);
    }
    return transfromDic;
}
@end
