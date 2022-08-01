//
//  QCloudCOSSMHDownloadObjectRequest.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/23.
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHDownloadFileRequest.h"

@interface QCloudCOSSMHDownloadObjectRequest : QCloudAbstractRequest


/**
 当前请求所属的队列，nil 标识sdk内默认队列，
 */
@property (nonatomic, weak) QCloudOperationQueue * ownerQueue;

/**
媒体库 ID，必选参数
*/
@property (nonatomic,strong)NSString *libraryId;

/**
空间 ID，如果媒体库为单租户模式，则该参数固定为连字符(-)；如果媒体库为多租户模式，则必须指定该参数
*/
@property (nonatomic,strong)NSString *spaceId;

/**
 空间所在组织id,仅访问外部群组时需要填写该字段;
 */
@property (nonatomic,strong)NSString *spaceOrgId;

/**
用户身份识别，当访问令牌对应的权限为管理员权限且申请访问令牌时的用户身份识别为空时用来临时指定用户身份，详情请参阅生成访问令牌接口
*/
@property (nonatomic,strong)NSString *userId;

/**
 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
 */
@property (nonatomic,strong)NSString *filePath;

/**
 历史版本 ID，用于获取不同版本的文件内容，可选参数，不传默认为最新版；
 */
@property (assign, nonatomic) NSInteger historVersionId;

/**
 如果存在改参数，则数据会下载到改路径指名的地址下面，而不会写入内存中。
 */
@property (nonatomic, strong) NSURL *downloadingURL;

/**
该选项设置为YES后，在下载完成后会比对COS上储存的文件crc64和下载到本地的文件crc64
目前默认开启。
*/
@property (assign, nonatomic) BOOL enableCRC64Verification;

/**
 指定是否使用分块及续传下载，默认为 YES。
 */
@property (assign, nonatomic)BOOL resumableDownload;


/// 下载开始之前返回文件信息
@property (strong, nonatomic)QCloudSMHReciveResponseHeader responseHeader;


/// 删除下载任务 清理下载进度缓存以及临时文件
- (void)remove;

@end
