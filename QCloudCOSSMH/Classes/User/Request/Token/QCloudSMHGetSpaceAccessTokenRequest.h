//
//  QCloudSMHGetSpaceAccessTokenRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/21.
//

#import "QCloudSMHBaseRequest.h"
@class QCloudSMHSpaceInfo;
NS_ASSUME_NONNULL_BEGIN
/**
 获取指定空间accesstoken接口；
 */
@interface QCloudSMHGetSpaceAccessTokenRequest : QCloudSMHBaseRequest
@property (nonatomic,strong)NSString *organizationId;
@property (nonatomic,strong)NSString *userToken;
@property (nonatomic,strong)NSString *spaceId;

/// 仅访问外部群组时需要填写该字段
@property (nonatomic,strong)NSString *spaceOrgId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpaceInfo *object, NSError * _Nullable))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
