//
//  QCloudSMHRestoreRecycleObjectReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 恢复一个回收站文件
 */
@interface QCloudSMHRestoreRecycleObjectReqeust : QCloudSMHBizRequest

/// 回收站项目 ID，必选参数；
@property (nonatomic,strong)NSString * recycledItemId;

- (void)setFinishBlock:(void (^ _Nullable)(NSDictionary * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
