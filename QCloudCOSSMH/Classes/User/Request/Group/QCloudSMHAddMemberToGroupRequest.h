//
//  QCloudSMHAddMemberToGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 添加群组成员
 */
@interface QCloudSMHAddMemberToGroupRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

/// 群组用户列表，可选项；
@property (nonatomic,strong)NSArray <QCloudSMHCreateGroupItem *> * users;

@end

NS_ASSUME_NONNULL_END
