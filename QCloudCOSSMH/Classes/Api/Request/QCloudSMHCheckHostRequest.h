//
//  QCloudSMHDeleteAuthorizeRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBaseRequest.h"
@class QCloudSMHCheckHostResult;

NS_ASSUME_NONNULL_BEGIN

/**
 私有化域名测试接口
 */
@interface QCloudSMHCheckHostRequest : QCloudSMHBaseRequest

/**
 用户私有化host 例如：https://***.com 或者  http://***.com
 */
@property (nonatomic,strong)NSString * host;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHCheckHostResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end



@interface QCloudSMHCheckHostResult : NSObject

@property (nonatomic,strong)NSString * pid;
@property (nonatomic,strong)NSString * branch;
@property (nonatomic,strong)NSString * podName;
@property (nonatomic,strong)NSString * commit;
@property (nonatomic,strong)NSString * pipelineId;
@property (nonatomic,strong)NSString * isSaas;
@property (nonatomic,strong)NSString * qualifier;
@property (nonatomic,strong)NSString * commitDate;
@property (nonatomic,strong)NSString * buildNum;
@property (nonatomic,strong)NSString * requestId;
@property (nonatomic,strong)NSString * podNamespace;

@end

NS_ASSUME_NONNULL_END


