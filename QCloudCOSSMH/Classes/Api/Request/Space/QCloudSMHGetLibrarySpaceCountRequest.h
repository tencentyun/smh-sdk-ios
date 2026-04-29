//
//  QCloudSMHGetLibrarySpaceCountRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 查询媒体库租户空间数量
@interface QCloudSMHGetLibrarySpaceCountRequest : QCloudSMHBizRequest
- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
