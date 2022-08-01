//
//  QCloudSMHDeleteTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于删除标签
 */
@interface QCloudSMHDeleteTagRequest : QCloudSMHBizRequest

/**
 标签 ID，必选参数；
 */
@property (nonatomic,strong)NSString *tagId;

@end

NS_ASSUME_NONNULL_END
