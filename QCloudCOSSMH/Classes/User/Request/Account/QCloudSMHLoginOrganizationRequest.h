//
//  QCloudSMHLoginOrganizationRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSpacesSizeInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 登录进指定组织
 通常无需调用该接口，直接列出指定组织的空间列表即可实现登录进指定组织，当然也可以显式调用该接口判断当前用户是否被允许登录进指定组织
 */
@interface QCloudSMHLoginOrganizationRequest : QCloudSMHUserBizRequest

@end

NS_ASSUME_NONNULL_END
