//
//  QCloudSMHDeleteInviteRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 删除邀请
 */
@interface QCloudSMHDeleteInviteRequest : QCloudSMHUserBizRequest

///  邀请码;
@property (nonatomic, copy) NSString * code;
@end

NS_ASSUME_NONNULL_END
