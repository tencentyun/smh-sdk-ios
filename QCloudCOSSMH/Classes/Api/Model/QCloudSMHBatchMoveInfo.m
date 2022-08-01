//
//  QCloudSMHBatchMoveInfo.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchMoveInfo.h"

@implementation QCloudSMHBatchMoveInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    }
    return self;
}
@end
