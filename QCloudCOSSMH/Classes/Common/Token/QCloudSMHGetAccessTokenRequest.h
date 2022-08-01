//
//  QCloudSMHGetAccessTokenRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHSpaceInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHGetAccessTokenRequest : QCloudSMHBaseRequest
@property (nonatomic,strong)NSString *organizationId;
@property (nonatomic,strong)NSString *userToken;
-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpaceInfo * _Nullable, NSError * _Nullable))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
