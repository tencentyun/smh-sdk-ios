//
//  QCloudSMHGetApplyDirectoryDetailRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHApplyDircetoryDetailInfo.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 获取审批单详情的接口
 */
@interface QCloudSMHGetApplyDirectoryDetailRequest : QCloudSMHUserBizRequest

/// 申请单号；
@property (nonatomic,strong)NSString * applyNo;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHApplyDircetoryDetailInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
