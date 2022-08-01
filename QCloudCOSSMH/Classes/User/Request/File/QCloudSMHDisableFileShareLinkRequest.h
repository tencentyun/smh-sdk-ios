//
//  QCloudSMHDisableFileShareLinkRequest.h
//  Pods
//
//  Created by garenwang on 2022/6/13.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudFileShareInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 禁用分享链接
 权限要求：超级管理员或系统管理员可以禁用任意分享链接；普通用户仅可禁用自己创建的分享链接；
 */
@interface QCloudSMHDisableFileShareLinkRequest : QCloudSMHUserBizRequest

/// 需要禁用的分享id
@property (nonatomic,strong)NSString * shareId;

@end

NS_ASSUME_NONNULL_END
