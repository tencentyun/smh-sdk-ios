//
//  QCloudSMHUserBizRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHUserBizRequest : QCloudSMHBaseRequest

/// 用户令牌
@property (nonatomic,strong)NSString *userToken;

/// 组织 ID
@property (nonatomic,strong)NSString *organizationId;

@property (nonatomic, assign) id <QCloudSMHAccessTokenProvider> accessTokenProvider;


@end

NS_ASSUME_NONNULL_END
