//
//  QCloudSMHGetStoreCodeDetailRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudStoreDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查询存储码对应的临时数据
 */
@interface QCloudSMHGetStoreCodeDetailRequest : QCloudSMHBaseRequest

/// 必填，保存 Code 时返回的 code 标识；
@property (nonatomic,strong)NSString *code;

/// 可选，访问文件令牌；
/// AccessToken 和 UserToken 二选一，但必须和保存时传入的 token 一致；
@property (nonatomic,strong)NSString *accessToken;

/// 可选，访问文件令牌，分享外链保存至网盘可不传，除此之外必传，防止 web 和 app 登录账号不一致，导致的权限问题；
/// AccessToken 和 UserToken 二选一，但必须和保存时传入的 token 一致；
@property (nonatomic,strong)NSString *userToken;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudStoreDetailInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
