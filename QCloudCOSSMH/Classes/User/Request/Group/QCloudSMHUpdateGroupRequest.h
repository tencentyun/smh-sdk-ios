//
//  QCloudSMHUpdateGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 更新群组信息
 */
@interface QCloudSMHUpdateGroupRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

/// 新的群组名称
@property (nonatomic, copy) NSString * groupName;
@end

NS_ASSUME_NONNULL_END
