//
//  QCloudSMHUpdateUserInfoRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

/// 更新用户信息
@interface QCloudSMHUpdateUserInfoRequest : QCloudSMHUserBizRequest
@property (nonatomic,strong)NSString * userId;
@property (nonatomic,strong)NSString * nickname;   //"nickname": "inkie",
@property (nonatomic,strong)NSString * email;   //"email": "abc@tencent.com",
@property (nonatomic,assign)QCloudSMHOrgUserRole role;   //"role": "user",
@property (nonatomic,assign)NSNumber * enabled;   //"enabled": true,
@property (nonatomic,strong)NSString * comment;   //"comment": "研发部员工",
@property (nonatomic,strong)NSString * allowPersonalSpace;   //"allowPersonalSpace": true
@end

NS_ASSUME_NONNULL_END
