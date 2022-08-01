//
//  QCloudSMHHeadFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于检查文件状态
 */
@interface QCloudSMHHeadFileRequest : QCloudSMHBizRequest

/// 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
@property (nonatomic,strong)NSString *filePath;

/// 历史版本 ID，用于获取不同版本的文件内容，可选参数，不传默认为最新版；
@property (nonatomic,assign)NSInteger historyId;

@end

NS_ASSUME_NONNULL_END
