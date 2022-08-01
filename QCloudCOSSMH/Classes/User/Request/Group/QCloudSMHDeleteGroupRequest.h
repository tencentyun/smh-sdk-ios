//
//  QCloudSMHDeleteGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 删除群组(群主)
 */
@interface QCloudSMHDeleteGroupRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

@end

NS_ASSUME_NONNULL_END
