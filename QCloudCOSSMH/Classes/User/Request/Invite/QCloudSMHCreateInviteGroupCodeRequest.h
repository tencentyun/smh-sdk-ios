//
//  QCloudSMHCreateInviteGroupCodeRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHInviteModel.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 生成加入群组邀请码
 */
@interface QCloudSMHCreateInviteGroupCodeRequest : QCloudSMHUserBizRequest

/// 群组 id
@property (nonatomic, copy) NSString * groupId;

/// 加入时的默认权限 （预览者、下载者等角色对应的id）
@property (nonatomic, copy) NSString * authRoleId;

/// 是否允许外部用户 默认false
@property (nonatomic, strong) NSNumber * allowExternalUser;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHCodeResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
