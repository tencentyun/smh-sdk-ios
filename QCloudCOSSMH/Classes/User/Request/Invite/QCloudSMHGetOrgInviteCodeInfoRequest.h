//
//  QCloudSMHGetOrgInviteCodeInfoRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHInviteModel.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询加入企业邀请码信息
 */
@interface QCloudSMHGetOrgInviteCodeInfoRequest : QCloudSMHBaseRequest


/// 用户令牌 非必传，若当前账号未登录则不传，登录则传
@property (nonatomic,strong)NSString *userToken;

/// 组织 ID 非必传，若当前账号未登录则不传，登录则传
@property (nonatomic,strong)NSString *organizationId;

/// 邀请码
@property (nonatomic, copy) NSString * code;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHInviteOrgCodeInfoModel *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
