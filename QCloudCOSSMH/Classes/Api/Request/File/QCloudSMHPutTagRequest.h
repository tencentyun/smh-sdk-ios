//
//  QCloudSMHPutTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于创建标签
 */
@interface QCloudSMHPutTagRequest : QCloudSMHBizRequest

/// 字符串，标签名称；
@property (nonatomic,strong)NSString * tagName;

/// 数字，标签类型，可选参数，用于键值对标签；
@property (nonatomic,strong)NSString * tagType;

@end

NS_ASSUME_NONNULL_END
