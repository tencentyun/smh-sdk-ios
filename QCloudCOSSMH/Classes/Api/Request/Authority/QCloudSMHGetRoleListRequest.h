//
//  QCloudSMHGetRoleListRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHRoleInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 获取角色列表
 */
@interface QCloudSMHGetRoleListRequest : QCloudSMHBizRequest

- (void)setFinishBlock:(void (^_Nullable)(NSArray <QCloudSMHRoleInfo *> *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
