//
//  QCloudSMHJoinGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHInviteModel.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 接受加入群组邀请
 */
@interface QCloudSMHJoinGroupRequest : QCloudSMHUserBizRequest

///  邀请码;
@property (nonatomic, copy) NSString * code;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHJoinResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
