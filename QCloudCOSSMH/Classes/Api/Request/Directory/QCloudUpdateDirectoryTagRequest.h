//
//  QCloudUpdateDirectoryTagRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2025/2/27.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 更新目录自定义标签
 */
@interface QCloudUpdateDirectoryTagRequest : QCloudSMHBizRequest

/**
 目录路径
 */
@property (nonatomic,strong)NSString * dirPath;
/**
 文件标签列表, 比如 ["动物", "大象", "亚洲象"]
 */
@property (nonatomic,strong)NSArray <NSString *> * labels;

@end

NS_ASSUME_NONNULL_END
