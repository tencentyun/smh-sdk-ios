//
//  QCloudSMHGetSpacesRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSpacesSizeInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 列出个人空间
 */
@interface QCloudSMHGetSpacesRequest : QCloudSMHUserBizRequest

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpacesSizeInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
