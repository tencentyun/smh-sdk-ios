//
//  QCloudSMHGetApplyDirectoryListTotalInfoRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 文件权限审批列表
 */

@class QCloudSMHListAppleDirectoryTotalInfoResult;
@interface QCloudSMHGetApplyDirectoryListTotalInfoRequest : QCloudSMHUserBizRequest

/// 查询类型：my_audit（我审核的）、my_apply（我申请的）；
@property (nonatomic,assign)QCloudSMHAppleType type;

/// 状态筛选，可选，不传返回全部，auditing 返回等待审批中的单，history 返回已审批、已取消、已驳回的单；
@property (nonatomic,assign)QCloudSMHAppleStatusType status;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHListAppleDirectoryTotalInfoResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

@interface QCloudSMHListAppleDirectoryTotalInfoResult : NSObject
@property (nonatomic,assign)NSInteger totalNum;
@end

NS_ASSUME_NONNULL_END
