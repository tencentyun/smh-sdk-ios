//
//  QCloudSMHRenameResult.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/19.
//

#import "QCloudSMHRenameResult.h"
@implementation QCloudSMHRenameResult
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"paths" : @"path"};
}
@end

@implementation QCloudSMHCopyResult


- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSDictionary * result = transfromDic[@"result"];
    if (result[@"path"] != nil) {
        transfromDic[@"path"] = result[@"path"];
        transfromDic[@"result"] = nil;
    }
    
    NSNumber *status = transfromDic[@"status"];
    if (status != nil) {
        NSInteger value = QCloudSMHBatchTaskStatusTypeFromStatus(status.integerValue);
        transfromDic[@"status"] = @(value);
    }
    
    return transfromDic;
}

@end

