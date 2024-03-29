//
//  QCloudSMHAgreeApplyDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 同意文件审批
 */
@interface QCloudSMHAgreeApplyDirectoryRequest : QCloudSMHUserBizRequest

/// 申请单号；
@property (nonatomic,strong)NSString * applyNo;

@end

NS_ASSUME_NONNULL_END
