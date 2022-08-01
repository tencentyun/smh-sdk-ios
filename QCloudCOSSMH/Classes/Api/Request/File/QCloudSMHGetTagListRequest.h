//
//  QCloudSMHGetTagListRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudTagModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于获取标签列表
 */
@interface QCloudSMHGetTagListRequest : QCloudSMHBizRequest

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudTagModel *> * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
