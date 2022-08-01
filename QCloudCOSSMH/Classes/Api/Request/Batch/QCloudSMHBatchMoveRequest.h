//
//  QCloudSMHBatchMoveRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHBatchMoveInfo.h"
#import "QCloudSMHBatchResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 批量重命名或移动
 要求权限：admin、space_admin 或 move_directory/move_file/move_file_force，如需同时重命名或移动目录和文件，可同时指定 move_directory 与 move_file/move_file_force 权限；
 */
@interface QCloudSMHBatchMoveRequest : QCloudSMHBizRequest

/// 批量任务信息
@property (nonatomic)NSArray <QCloudSMHBatchMoveInfo *> *batchInfos;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
