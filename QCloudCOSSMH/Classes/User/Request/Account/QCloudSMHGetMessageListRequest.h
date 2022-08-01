//
//  QCloudSMHGetMessageListRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHMessageTypeEnum.h"
#import "QCloudSMHMesssageListResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 我的消息列表
 */
@interface QCloudSMHGetMessageListRequest : QCloudSMHUserBizRequest
@property (nonatomic,assign)QCloudSMHMessageType messageType;

/**
 阅读状态，0 全部（默认），1 未读，2 已读；
 */
@property (nonatomic,assign)NSInteger readState;

/**
 限制响应体中的条目数，如不指定则默认为 1000；
 */
@property (nonatomic,assign)NSInteger limit;

/**
 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
 */
@property (nonatomic,copy)NSString *marker;

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;
-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHMesssageListResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
