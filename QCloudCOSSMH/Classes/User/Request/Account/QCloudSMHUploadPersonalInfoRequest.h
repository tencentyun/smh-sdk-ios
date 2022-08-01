//
//  QCloudSMHUploadPersonalInfoRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHUserInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 数据上报流程
 1. 客户端上报数据至后端，后端返回 32 位的 code
 2. 客户端发起 h5 页面，带上 code & userToken
 3. h5 通过 code & userToken 向后端请求完整个人信息
 */
@interface QCloudSMHUploadPersonalInfoRequest : QCloudSMHBaseRequest

@property (nonatomic,strong)NSString * userToken;

@property (nonatomic,strong)NSString * idfv;

@property (nonatomic,strong)NSString * model;

@property (nonatomic,strong)NSString * system;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHUploadPersonalInfoResult * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
