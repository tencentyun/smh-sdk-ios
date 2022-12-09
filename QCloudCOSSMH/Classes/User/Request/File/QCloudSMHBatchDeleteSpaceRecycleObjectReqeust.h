//
//  QCloudSMHBatchDeleteSpaceRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCrossSpaceRecycleItem.h"
#import "QCloudSMHBatchResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 永久删除指定回收站项目（批量） 可跨空间
 */
@interface QCloudSMHBatchDeleteSpaceRecycleObjectReqeust : QCloudSMHUserBizRequest

/// 回收站数据集合
@property (nonatomic,copy)NSArray <QCloudSMHBatchInputRecycleInfo *> * recycledItems;

/// 删除所有具有管理权限的群组下的文件（管理员或群组操作者）
@property(nonatomic,assign)BOOL withAllGroups;

/// 删除所有具有管理权限的团队空间下的文件
@property(nonatomic,assign)BOOL withAllTeams;
@end

NS_ASSUME_NONNULL_END
