//
//  QCloudSMHGetOrgSpacesRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSpacesSizeInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询组织空间总使用量。
 */
@interface QCloudSMHGetOrgSpacesRequest : QCloudSMHUserBizRequest

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHOrgSpacesSizeInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END

