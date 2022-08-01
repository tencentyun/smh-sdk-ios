//
//  QCloudSMHDownloadFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^QCloudSMHReciveResponseHeader)(NSDictionary * header);

/**
 下载文件
 */
@interface QCloudSMHDownloadFileRequest : QCloudSMHBizRequest

/**
 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
 */
@property (nonatomic,strong)NSString *filePath;

/**
 RFC 2616 中定义的指定文件下载范围，以字节（bytes）为单位
 */
@property (strong, nonatomic) NSString *range;

/**
 历史版本 ID，用于获取不同版本的文件内容，可选参数，不传默认为最新版；
 */
@property (assign, nonatomic) NSInteger historVersionId;

@property (strong, nonatomic)QCloudSMHReciveResponseHeader responseHeader;

@end

NS_ASSUME_NONNULL_END
