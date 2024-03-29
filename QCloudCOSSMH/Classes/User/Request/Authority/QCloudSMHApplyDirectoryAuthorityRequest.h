//
//  QCloudSMHApplyDirectoryAuthorityRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于发起文件审批
 */
@interface QCloudSMHApplyDirectoryAuthorityRequest : QCloudSMHUserBizRequest

/// 空间 ID
@property (nonatomic,strong)NSString * spaceId;

/// 授权文件目录集合
@property (nonatomic,strong)NSArray * pathList;

/// 审批标题
@property (nonatomic,strong)NSString * title;

/// 申请原因
@property (nonatomic,strong)NSString * reason;

/// 申请角色 ID
@property (nonatomic,strong)NSString * roleId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHAppleDirectoryResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
