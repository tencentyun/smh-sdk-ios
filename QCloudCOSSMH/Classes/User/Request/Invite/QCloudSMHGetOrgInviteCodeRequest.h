//
//  QCloudSMHGetOrgInviteCodeRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHInviteModel.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询加入企业邀请码
 */
@interface QCloudSMHGetOrgInviteCodeRequest : QCloudSMHUserBizRequest

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHCodeResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
