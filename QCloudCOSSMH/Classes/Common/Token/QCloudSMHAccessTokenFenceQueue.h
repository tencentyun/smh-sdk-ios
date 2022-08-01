//
//  QCloudSMHFenceQueue.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/20.
//

#import <Foundation/Foundation.h>
@class QCloudSMHAccessTokenFenceQueue;
@class QCloudSMHBizRequest;
@class QCloudSMHSpaceInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void (^QCloudAccessTokenFenceQueueContinue)(QCloudSMHSpaceInfo *spaceInfo, NSError *error);
@protocol QCloudAccessTokenFenceQueueDelegate <NSObject>

/**
 刷新accessToken;
 @param queue 获取accessToken的调用方
 @param continueBlock 用来通知获取结果的block
 */
- (void)fenceQueue:(QCloudSMHAccessTokenFenceQueue *)queue request:(QCloudSMHBizRequest *)request requestCreatorWithContinue:(QCloudAccessTokenFenceQueueContinue)continueBlock;

@end

@interface QCloudSMHAccessTokenFenceQueue : NSObject
/**
 获取新的accessToken的超时时间。如果您在超时时间内没有返回任何结果数据，则将会将认为获取任务失败。失败后，将会通知所有需要签名的调用方：失败。
 @default  120s
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 执行委托
 */
@property (nonatomic, weak) id<QCloudAccessTokenFenceQueueDelegate> delegate;

/**
 执行一个需要accessToken的方法，如果密钥存在则直接传给Block。如果不存在，则会触发栅栏机制。该请求被缓存在队列中，同时触发请求accessToken（如果可以）。直到请求到密钥或者请求密钥失败。

 @param action 一个需要accessToken的方法
 */
- (void)performRequest:(QCloudSMHBizRequest *)request withAction:(void (^ _Nullable)( QCloudSMHSpaceInfo *spaceInfo, NSError *error))action;

/**
 清理所有缓存的accesstoken
 */
-(void)cleanAllAccesstoken;
@end

NS_ASSUME_NONNULL_END
