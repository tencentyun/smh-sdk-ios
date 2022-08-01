//
//  QCloudSMHExitGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 退出群组（非群主）
 
 权限要求：群主不能退出群组，但可以解散群组（参见解散群组接口）；
 */
@interface QCloudSMHExitGroupRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

@end

NS_ASSUME_NONNULL_END
