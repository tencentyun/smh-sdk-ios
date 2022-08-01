//
//  QCloudSMHDeleteFileShareRequest.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudFileShareInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 删除分享链接
 权限要求：超级管理员或系统管理员可以删除任意分享链接；普通用户仅可删除自己创建的分享链接；
 */
@interface QCloudSMHDeleteFileShareRequest : QCloudSMHUserBizRequest

/// 字符串数组，每个元素对应要删除的分享 ID；
@property (nonatomic,strong)NSArray <NSString *> * shareIds;
@end

NS_ASSUME_NONNULL_END
