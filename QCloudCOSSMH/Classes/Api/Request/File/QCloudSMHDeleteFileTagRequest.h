//
//  QCloudSMHDeleteFileTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于删除给文件打的标签
 */
@interface QCloudSMHDeleteFileTagRequest : QCloudSMHBizRequest

/**
 文件标签 ID，必选参数；
 */
@property (nonatomic,strong)NSString * fileTagId;
@end

NS_ASSUME_NONNULL_END
