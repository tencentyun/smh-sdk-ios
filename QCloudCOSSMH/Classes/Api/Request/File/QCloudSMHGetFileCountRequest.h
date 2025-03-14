//
//  QCloudSMHGetFileCountRequest.h
//  QCloudCOSSMH
//
//  Created by qinghaochen on 2023/10/30.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHFileCountInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取云盘文件数量
 */
@interface QCloudSMHGetFileCountRequest : QCloudSMHBizRequest

- (void)setFinishBlock:(void (^)(QCloudSMHFileCountInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
