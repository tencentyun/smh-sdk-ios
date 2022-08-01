//
//  QCloudSMHLogoutRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 登出
 */
@interface QCloudSMHLogoutRequest : QCloudSMHBaseRequest

@property (nonatomic,strong)NSString * userToken;

@end

NS_ASSUME_NONNULL_END
