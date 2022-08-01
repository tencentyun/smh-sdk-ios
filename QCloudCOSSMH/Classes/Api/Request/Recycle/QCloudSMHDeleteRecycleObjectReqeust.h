//
//  QCloudSMHDeleteRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 删除一个回收站文件
 */
@interface QCloudSMHDeleteRecycleObjectReqeust : QCloudSMHBizRequest

/// 回收站项目 ID，必选参数；
@property (nonatomic,strong)NSString * recycledItemId;

@end

NS_ASSUME_NONNULL_END
