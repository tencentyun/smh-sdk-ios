//
//  QCloudSMHGeFileShareLinkDetailRequest.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudFileShareInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取分享链接详情
 */
@interface QCloudSMHGeFileShareLinkDetailRequest : QCloudSMHUserBizRequest

/// 分享id
@property (nonatomic,strong)NSString * shareId;

@end

NS_ASSUME_NONNULL_END
