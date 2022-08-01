//
//  QCloudSMHBatchDeleteRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHBatchDeleteInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于批量删除
 要求权限：admin、space_admin 或 delete_directory/delete_directory_permanent/delete_file/delete_file_permanent，如需同时删除目录和文件，可同时指定 delete_directory/delete_directory_permanent 与 delete_file/delete_file_permanent 权限；
 */
@interface QCloudSMHBatchDeleteRequest : QCloudSMHBizRequest

/// 批量任务信息
@property (nonatomic)NSArray <QCloudSMHBatchDeleteInfo *>*batchInfos;
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHBatchResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
