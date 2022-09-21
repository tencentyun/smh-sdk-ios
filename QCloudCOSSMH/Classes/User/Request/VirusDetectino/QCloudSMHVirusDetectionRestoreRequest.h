//
//  QCloudSMHVirusDetectionRestoreRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHVirusDetectionModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 可疑文件恢复接口（可批量）
@interface QCloudSMHVirusDetectionRestoreRequest : QCloudSMHUserBizRequest

/// restoreItems 恢复数据集合
/// spaceId 空间 ID
/// path 文件路径
@property(nonatomic,strong)NSArray <QCloudSMHVirusDetectionInput *> * restoreItems;

@end

NS_ASSUME_NONNULL_END
