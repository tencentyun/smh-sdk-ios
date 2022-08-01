//
//  QCloudSMHDeleteGroupMemberRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 删除群组成员
 */
@interface QCloudSMHDeleteGroupMemberRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

/// 群组用户列表，可选项； QCloudSMHCreateGroupItem 只需传 userId orgId。
@property (nonatomic,strong)NSArray <QCloudSMHCreateGroupItem *> * users;
@end

NS_ASSUME_NONNULL_END
