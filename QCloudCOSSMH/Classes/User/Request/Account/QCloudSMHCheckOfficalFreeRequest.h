//
//  QCloudSMHCheckOfficalFreeRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询免费版注册活动状态
 */
@interface QCloudSMHCheckOfficalFreeRequest : QCloudSMHBaseRequest

/// 用户令牌
@property (nonatomic,strong)NSString *userToken;


@end

NS_ASSUME_NONNULL_END
