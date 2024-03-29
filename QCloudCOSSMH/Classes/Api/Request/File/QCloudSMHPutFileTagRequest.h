//
//  QCloudSMHPutFileTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHTagModel : NSObject

/// d: 标签 id；
@property (nonatomic,strong) NSString *tagId;

/// 标签值，可选参数，用于键值对标签，如：标签名 ios 标签值 13.2，搜索特定版本标签；
@property (nonatomic,strong) NSString *tagValue;

@end
/**
 用于创建标签
 */
@interface QCloudSMHPutFileTagRequest : QCloudSMHBizRequest

/// 完整源文件路径，例如 foo/bar/file.docx；
@property (nonatomic,strong)NSString * filePath;

/// 标签字符串数组
@property (nonatomic,strong)NSArray <NSString *> * tags;
/// 键值对标签
@property (nonatomic,strong)NSArray <QCloudSMHTagModel *> * kvTags;

@end

NS_ASSUME_NONNULL_END
