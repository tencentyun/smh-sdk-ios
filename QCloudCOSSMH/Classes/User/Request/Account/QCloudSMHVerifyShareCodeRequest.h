//
//  QCloudSMHVerifyShareCodeRequest.h
//  Pods
//
//  Created by garenwang on 2021/11/25.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHVerifyShareCodeResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 验证提取码
 若不需要提取码，也需要调用该接口获取查询文件目录 access_token。
 */
@interface QCloudSMHVerifyShareCodeRequest : QCloudSMHBaseRequest

/// 分享 url 上带上的 Hash 值；
@property (nonatomic,strong)NSString * shareToken;

/// 访问令牌，可选参数；；
@property (nonatomic,strong)NSString * userToken;

/// 提取码；
@property (nonatomic,strong)NSString * extractionCode;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHVerifyShareCodeResult * _Nullable result , NSError * _Nullable error))finishBlock;
@end

NS_ASSUME_NONNULL_END
