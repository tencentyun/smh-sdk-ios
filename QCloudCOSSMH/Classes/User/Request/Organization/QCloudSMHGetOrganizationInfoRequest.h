//
//  QCloudSMHGetOrganizationInfoRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHOrganizationDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 获取当前组织信息
@interface QCloudSMHGetOrganizationInfoRequest : QCloudSMHUserBizRequest


- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHOrganizationDetailInfo *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
