//
//  QCloudSMHGetRecycleItemDetailRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHRecycleObjectListInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取回收站目录详情
 */
@interface QCloudSMHGetRecycleItemDetailRequest : QCloudSMHUserBizRequest

/// 空间 ID
@property (nonatomic,strong)NSString * spaceId;

/// 回收站 ID
@property (nonatomic,strong)NSString * recycleItemId;
@end

NS_ASSUME_NONNULL_END
