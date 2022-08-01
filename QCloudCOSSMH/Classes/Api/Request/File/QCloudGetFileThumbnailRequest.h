//
//  QCloudGetFileThumbnailRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/20.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取照片/视频封面缩略图
 */
@interface QCloudGetFileThumbnailRequest : QCloudSMHBizRequest

/**
 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
 */
@property (nonatomic,strong)NSString *filePath;

/**
 缩放大小
 */
@property (nonatomic,assign)CGFloat size;

/**
 历史版本号
 */
@property (nonatomic,assign)NSInteger historyId;
@end

NS_ASSUME_NONNULL_END
