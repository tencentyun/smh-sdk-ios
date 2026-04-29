//
//  QCloudSMHDeleteFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHDeleteResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 删除文件
 */
@interface QCloudSMHDeleteFileRequest : QCloudSMHBizRequest

/**
 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
 */
@property (nonatomic,strong)NSString *filePath;

/**
 当媒体库开启回收站时，则该参数指定将文件移入回收站还是永久删除文件，1: 永久删除，0: 移入回收站，默认为 0
 */
@property (nonatomic,assign)int permanent;

/**
 文件内容的 Cas 标识，可选参数。当文件存在并且文件内容的 Cas 标识匹配时，才允许删除此文件；
 */
@property (nonatomic, strong, nullable) NSString *contentCas;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
