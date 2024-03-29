//
//  QCloudSMHDisagreeApplyDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于驳回文件审批
 */
@interface QCloudSMHDisagreeApplyDirectoryRequest : QCloudSMHUserBizRequest

/// 申请单号；
@property (nonatomic,strong)NSString * applyNo;

@end

NS_ASSUME_NONNULL_END
