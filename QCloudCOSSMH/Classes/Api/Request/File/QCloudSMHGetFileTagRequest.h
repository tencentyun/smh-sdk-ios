//
//  QCloudSMHGetFileTagRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudTagModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于获取文件标签
 */
@interface QCloudSMHGetFileTagRequest : QCloudSMHBizRequest

/**
 完整源文件路径，例如 foo/bar/file.docx；
 */
@property (nonatomic,strong)NSString * filePath;

- (void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudFileTagItemModel *> * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
