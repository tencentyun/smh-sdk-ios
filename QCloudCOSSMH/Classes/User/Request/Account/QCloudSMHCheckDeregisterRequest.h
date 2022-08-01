//
//  QCloudSMHCheckDeregisterRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDeregisterResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 检查用户是否满足注销条件
 超级管理员不可注销自身
 当个人空间清空（包括回收站）且所创建的群组都解散时才能注销用户
 */
@interface QCloudSMHCheckDeregisterRequest : QCloudSMHUserBizRequest

- (void)setFinishBlock:(void (^)(QCloudSMHCheckDeregisterResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
