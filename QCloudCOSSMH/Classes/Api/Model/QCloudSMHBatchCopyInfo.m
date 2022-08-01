//
//  QCloudSMHBatchInfo.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchCopyInfo.h"

@implementation QCloudSMHBatchCopyInfo

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"from" : @"copyFrom",@"fromLibraryId":@"copyFromLibraryId",@"fromSpaceId":@"copyFromSpaceId"};
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    }
    return self;
}
@end
