//
//  QCloudSMHPutFileTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于创建标签
 */
@interface QCloudSMHPutFileTagRequest : QCloudSMHBizRequest

/// 完整源文件路径，例如 foo/bar/file.docx；
@property (nonatomic,strong)NSString * filePath;

/// 标签字符串数组
@property (nonatomic,strong)NSArray <NSString *> * tags;

@end

NS_ASSUME_NONNULL_END
