//
//  QCloudSMHService.h
//  Pods
//
//  Created by karisli(李雪) on 2021/7/13.
//

#import <QCloudCore/QCloudCore.h>
#include <QCloudCore/QCloudConfiguration.h>
#import "QCloudSMHAccessTokenProvider.h"

@class QCloudSMHListContentsRequest;
@class QCloudSMHInitiateSearchRequest;
@class QCloudSMHResumeSearchRequest;
@class QCloudSMHAbortSearchRequest;
@class QCloudSMHHeadDirectoryRequest;
@class QCloudSMHPutDirectoryRequest;
@class QCloudSMHDeleteDirectoryRequest;
@class QCloudSMHRenameDirectoryRequest;
@class QCloudSMHDownloadFileRequest;
@class QCloudSMHHeadFileRequest;
@class QCloudSMHDeleteFileRequest;
@class QCloudSMHRenameFileRequest;
@class QCloudGetFileThumbnailRequest;

@class QCloudSMHGetUploadStateRequest;
@class QCloudSMHPutObjectRequest;
@class QCloudCOSSMHPutObjectRequest;
@class QCloudSMHUploadPartRequest;
@class QCloudCOSSMHUploadPartRequest;
@class QCloudSMHCompleteUploadRequest;

@class QCloudSMHAbortMultipfartUploadRequest;
@class QCloudSMHRenameFileRequest;
@class QCloudSMHCopyFileRequest;
@class QCloudCOSSMHUploadObjectRequest;

@class QCloudSMHGetRecycleObjectListReqeust;
@class QCloudSMHDeleteRecycleObjectReqeust;
@class QCloudSMHRestoreRecycleObjectReqeust;
@class QCloudSMHDeleteAllRecycleObjectReqeust;
@class QCloudSMHBatchDeleteRecycleObjectReqeust;
@class QCloudSMHDeleteAllRecycleObjectReqeust;
@class QCloudSMHBatchRestoreRecycleObjectReqeust;
@class QCloudSMHBatchDeleteSpaceRecycleObjectReqeust;
@class QCloudSMHBatchRestoreSpaceRecycleObjectReqeust;
@class QCloudSMHDeleteHistoryVersionRequest;

@class QCloudSMHCompleteUploadAvatarRequest;
@class QCloudSMHInitUploadAvatarRequest;
@class QCloudSMHBatchCopyRequest;
@class QCloudSMHBatchDeleteRequest;
@class QCloudSMHBatchMoveRequest;
@class QCloudSMHPutObjectRenewRequest;
@class QCloudGetTaskStatusRequest;


@class QCloudSMHCopyObjectRequest;
@class QCloudSMHDeleteObjectRequest;
@class QCloudSMHMoveObjectRequest;
@class QCloudSMHGetPresignedURLRequest;
@class QCloudSMHRestoreObjectRequest;

@class QCloudSMHGetMyAuthorizedDirectoryRequest;


@class QCloudSMHPostAuthorizeRequest;
@class QCloudSMHGetFileAuthorityRequest;
@class QCloudSMHDeleteAuthorizeRequest;
@class QCloudSMHGetRoleListRequest;

@class QCloudSMHGetDownloadInfoRequest;
@class QCloudSMHPutHisotryVersionRequest;
@class QCloudSMHSetLatestVersionRequest;

@class QCloudSMHGetHistoryInfoRequest;
@class QCloudDeleteLocalSyncRequest;
@class QCloudSMHQuickPutObjectRequest;

@class QCloudSMHGetFileListByTagsRequest;
@class QCloudSMHDeleteFileTagRequest;
@class QCloudSMHGetFileTagRequest;
@class QCloudSMHPutFileTagRequest;
@class QCloudSMHDeleteTagRequest;
@class QCloudSMHGetTagListRequest;
@class QCloudSMHPutTagRequest;

@class QCloudSMHCrossSpaceAsyncCopyDirectoryRequest;
@class QCloudSMHRestoreCrossSpaceObjectRequest;
@class QCloudSMHExitFileAuthorizeRequest;
@class QCloudCOSSMHDownloadObjectRequest;
@class QCloudSMHGetAlbumRequest;

@class QCloudSMHCrossSpaceCopyDirectoryRequest;
@class QCloudSMHCreateFileRequest;
@class QCloudSMHEditFileOnlineRequest;

@class QCloudSMHCheckHostRequest;
@class QCloudSMHDetailDirectoryRequest;
@class QCloudSMHSpaceAuthorizeRequest;
@class QCloudSMHSpaceAuthorizeRequest;
@class QCloudSMHAPIListHistoryVersionRequest;
@class QCloudSMHGetFileCountRequest;
@class QCloudSMHGetINodeDetailRequest;
@class QCloudSMHGetRecentlyUsedFileRequest;
@class QCloudUpdateDirectoryTagRequest;
@class QCloudSMHGetSpaceHomeFileRequest;
@class QCloudUpdateFileTagRequest;

@class QCloudSMHGetRecyclePresignedURLRequest;
@class QCloudSMHGetRecycleFileDetailReqeust;
@class QCloudSetSpaceTrafficLimitRequest;
@class QCloudSMHListFavoriteSpaceFileRequest;
@class QCloudSMHFavoriteSpaceFileRequest;
@class QCloudSMHDeleteFavoriteSpaceFileRequest;
@class QCloudGetSpaceUsageRequest;
@class QCloudSMHPutObjectLinkRequest;
@class QCloudSMHExternalURLDownloadRequest;
@class QCloudSMHFileDeletionCheckRequest;

// ===== 新增 Request 类（codegen 2026-04-22）=====
@class QCloudSMHCreateTokenRequest;
@class QCloudSMHRenewTokenRequest;
@class QCloudSMHDeleteTokenRequest;
@class QCloudSMHDeleteUserTokensRequest;
@class QCloudSMHCreateSpaceRequest;
@class QCloudSMHListSpaceRequest;
@class QCloudSMHGetSpaceExtensionRequest;
@class QCloudSMHUpdateSpaceExtensionRequest;
@class QCloudSMHDeleteSpaceRequest;
@class QCloudSMHGetLibrarySpaceCountRequest;
@class QCloudSMHGetLibraryUsageRequest;
@class QCloudSMHConvertFileRequest;
@class QCloudSMHPreviewFileRequest;
@class QCloudSMHDownloadTranscodedVideoRequest;
@class QCloudSMHGetDeltaCursorRequest;
@class QCloudSMHQueryDeltaLogRequest;
@class QCloudSMHEmptyHistoryRequest;
@class QCloudSMHCreateQuotaRequest;
@class QCloudSMHGetQuotaRequest;
@class QCloudSMHUpdateQuotaRequest;
@class QCloudSMHUpdateQuotaByIdRequest;
@class QCloudSMHGetQuotaInfoRequest;
@class QCloudSMHGetMediaFileInfoRequest;
@class QCloudSMHCreateTranscodeTaskRequest;
@class QCloudSMHPrepareM3u8UploadRequest;
@class QCloudSMHConfirmM3u8UploadRequest;
@class QCloudSMHRenewM3u8UploadRequest;
@class QCloudSMHModifyM3u8SegmentsRequest;
@class QCloudSMHLiveTranscodeMediaFileRequest;
@class QCloudSMHGetDirectoryStatsRequest;
@class QCloudSMHCalibrateDirectoryStatsRequest;
@class QCloudSMHRecycleSetLifecycleRequest;
@class QCloudSMHVerifyExtractionCodeRequest;
@class QCloudSMHSearchSharesRequest;
@class QCloudSMHSetShareEnabledRequest;
@class QCloudSMHGetShareDetailRequest;
@class QCloudSMHListSharesRequest;
@class QCloudSMHGetShareUrlDetailRequest;
@class QCloudSMHUpdateShareRequest;
@class QCloudSMHSaveShareFileRequest;
@class QCloudSMHPreviewShareFileRequest;
@class QCloudSMHDownloadShareFileRequest;
@class QCloudSMHListShareFilesRequest;
@class QCloudSMHCreateShareRequest;
@class QCloudSMHDeleteShareRequest;


NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHService : NSObject



#pragma Factory
@property (nonatomic,strong,readonly)QCloudConfiguration *configuration;


/**
 当前服务所运行的HTTP Session Manager。一般情况下，所有服务都运行在统一的全局单例上面。
 */
@property (nonatomic, strong, readonly) QCloudHTTPSessionManager *sessionManager;

/**
 签名信息的回调接口，该委托必须实现。签名是腾讯云进行服务时进行用户身份校验的关键手段，同时也保障了用户访问的安全性。该委托中通过函数回调来提供签名信息。
 */
@property (nonatomic, strong) id<QCloudSMHAccessTokenProvider> accessTokenProvider;

+ (QCloudSMHService *)defaultSMHService;
- (int)performRequest:(QCloudSMHBizRequest *)httpRequst;


/**
 获取分块上传状态
 */
-(void)getUploadStateInfo:(QCloudSMHGetUploadStateRequest *)request;

/**
 高级上传
 */
-(void)uploadObject:(QCloudCOSSMHUploadObjectRequest *)request;

/**
 SMH简单上传
 */
-(void)smhPutObject:(QCloudSMHPutObjectRequest *)request;

/**
 快速上传
 */
-(void)smhQuickPutObject:(QCloudSMHQuickPutObjectRequest *)request;

/**
 实际简单上传
 */
-(void)putObject:(QCloudCOSSMHPutObjectRequest *)request;
/**
 开分块上传
 */
-(void)smhStartPartUpload:(QCloudSMHUploadPartRequest *)request;

/**
 分块上传
 */
-(void)uploadPartObject:(QCloudCOSSMHUploadPartRequest *)request;

/**
 完成上传
 */
-(void)complelteUploadPartObject:(QCloudSMHCompleteUploadRequest *)request;

/**
 取消上传
 */
-(void)deleteUploadPartObject:(QCloudSMHAbortMultipfartUploadRequest *)request;
/**
 获取文件
 */
- (void)listContents:(QCloudSMHListContentsRequest *)request;

/**
 获取目录内容（在队列中执行）
 */
- (void)batchListContents:(QCloudSMHListContentsRequest *)request;
/**
 搜索文件
 */
- (void)initSearch:(QCloudSMHInitiateSearchRequest *)request;

/**
 搜索文件
 */
- (void)resumeSearch:(QCloudSMHResumeSearchRequest *)request;

/**
 丢弃搜索
 */
- (void)abortSearch:(QCloudSMHAbortSearchRequest *)request;

/**
 获取目/相薄状态
 */
- (void)headDirectory:(QCloudSMHHeadDirectoryRequest *)request;

/**
 创建目录/相薄状态
 */
- (void)putDirectory:(QCloudSMHPutDirectoryRequest *)request;

/**
 删除目录/相薄状态
 */
- (void)deleteDirectory:(QCloudSMHDeleteDirectoryRequest *)request;

/**
 重命名或者移动
 */
- (void)renameDirecotry:(QCloudSMHRenameDirectoryRequest *)request;

/**
 复制
 */
- (void)copyFile:(QCloudSMHCopyFileRequest *)request;

/**
 检查文件状态
 */
- (void)headFile:(QCloudSMHHeadFileRequest *)request;

/**
 下载文件
 */
- (void)downloadFile:(QCloudSMHDownloadFileRequest *)request;

/**
 删除文件
 */
- (void)deleteFile:(QCloudSMHDeleteFileRequest *)request;

/**
 获取批量操作的任务的状态
 */
- (void)getTaskStatus:(QCloudGetTaskStatusRequest *)request;
/**
 删除文件
 */
- (void)renameFile:(QCloudSMHRenameFileRequest *)request;

/**
 获取文件封面
 */
- (void)getThumbnail:(QCloudGetFileThumbnailRequest *)request;

/**
 获取文件预签名链接
 */
- (void)getPresignedURL:(QCloudSMHGetPresignedURLRequest *)request;

/**
 获取回收站列表
 */
-(void)getRecycleList:(QCloudSMHGetRecycleObjectListReqeust *)request;

/**
 删除回收站文件
 */
-(void)deleteRecycleObject:(QCloudSMHDeleteRecycleObjectReqeust *)request;

/**
 恢复回收站文件
 */
-(void)restoreRecyleObject:(QCloudSMHRestoreRecycleObjectReqeust *)request;

/**
 清空回收站
 */
-(void)deleteAllRecyleObject:(QCloudSMHDeleteAllRecycleObjectReqeust *)request;

/**
 批量删除回收站文件
 */
-(void)batchDeleteRecycleObject:(QCloudSMHBatchDeleteRecycleObjectReqeust *)request;

/**
 批量恢复回收站文件
 */
-(void)batchRestoreRecycleObject:(QCloudSMHBatchRestoreRecycleObjectReqeust *)request;

#pragma mark - batch
/**
 批量移动
 */
- (void)batchMove:(QCloudSMHBatchMoveRequest *)request;

/**
 批量移动
 */
- (void)batchDelete:(QCloudSMHBatchDeleteRequest *)request;

/**
 批量移动
 */
- (void)batchCopy:(QCloudSMHBatchCopyRequest *)request;
/**
 刷新上传信息
 */
-(void)renewUploadInfo:(QCloudSMHPutObjectRenewRequest *)request;
/**
 复制文件
 */
- (void)copyObject:(QCloudSMHCopyObjectRequest*)request;
/**
 移动文件
 */
- (void)moveObject:(QCloudSMHMoveObjectRequest*)request;
/**
 删除文件
 */
- (void)deleteObject:(QCloudSMHDeleteObjectRequest*)request;
/**
 批量恢复
 */
-(void)restoreObject:(QCloudSMHRestoreObjectRequest *)request;

/**
 设置历史版本配置信息
 */
- (void)putHisotryVersion:(QCloudSMHPutHisotryVersionRequest *)request;

/**
 用于设置历史版本为最新版本
 */
- (void)setLatestVersion:(QCloudSMHSetLatestVersionRequest *)request;

/**
 删除历史版本文件
 */
- (void)deleteHisotryVersion:(QCloudSMHDeleteHistoryVersionRequest *)request;

/**
 同 Library 跨空间复制目录或相簿
 */
-(void)crossSpaceAsyncCopyDirectory:(QCloudSMHCrossSpaceAsyncCopyDirectoryRequest *)request;
#pragma mark - authority

/**
 获取我共享的文件夹
 */
- (void)getMyAuthorizedDirectory:(QCloudSMHGetMyAuthorizedDirectoryRequest *)request;

/**
 分配权限
 */
- (void)authorizedDirectoryToSomeone:(QCloudSMHPostAuthorizeRequest *)request;

/**
 用于删除权限
 */
- (void)deleteAuthorizedDirectoryFromSomeone:(QCloudSMHDeleteAuthorizeRequest *)request;

/**
 获取角色列表
 */
- (void)getRoleList:(QCloudSMHGetRoleListRequest *)request;

/**
 获取下载文件信息
 */
- (void)getDonwloadInfo:(QCloudSMHGetDownloadInfoRequest *)request;

/**
 用于查询历史版本配置信息
 */
- (void)getHistoryDetailInfo:(QCloudSMHGetHistoryInfoRequest *)request;

/**
 删除同步盘
 */
- (void)deleteLocalSync:(QCloudDeleteLocalSyncRequest *)request;

/**
 用于根据标签筛选文件
 */
- (void)getFileListByTags:(QCloudSMHGetFileListByTagsRequest *)request;

/**
 用于删除给文件打的标签
 */
- (void)deleteFileTag:(QCloudSMHDeleteFileTagRequest *)request;

/**
 用于获取文件标签
 */
- (void)getFileTag:(QCloudSMHGetFileTagRequest *)request;

/**
 用于创建标签
 */
- (void)putFileTag:(QCloudSMHPutFileTagRequest *)request;

/**
 用于删除标签
 */
- (void)deleteTag:(QCloudSMHDeleteTagRequest *)request;

/**
 用于获取标签列表
 */
- (void)getTagList:(QCloudSMHGetTagListRequest *)request;

/**
 用于创建标签
 */
- (void)putTag:(QCloudSMHPutTagRequest *)request;

/**
 用于用户主动退出被授权的 文件/文件夹 权限。
 */
- (void)exitFileAuthorize:(QCloudSMHExitFileAuthorizeRequest *)request;

/**
 高级下载接口
 */
-(void)smhDownload:(QCloudCOSSMHDownloadObjectRequest *)request;

/**
 获取相册封面
 */
-(void)getAlbum:(QCloudSMHGetAlbumRequest *)request;

/**
 异步跨空间复用接口
 */
-(void)crossSpaceCopyDirectory:(QCloudSMHCrossSpaceCopyDirectoryRequest *)request;

/**
 用于模板创建文件
 */
-(void)createFileRequest:(QCloudSMHCreateFileRequest *)request;

/**
 获取在线编辑链接
 */
-(void)getEditFileOnlineUrl:(QCloudSMHEditFileOnlineRequest *)request;

-(void)checkHost:(QCloudSMHCheckHostRequest *)request;

/// 查看文件详情
-(void)detailDirectory:(QCloudSMHDetailDirectoryRequest *)request;

/// 给空间分配权限
-(void)spaceAuthorize:(QCloudSMHSpaceAuthorizeRequest *)request;

/// 查看历史版本
-(void)listHistoryVersion:(QCloudSMHAPIListHistoryVersionRequest *)request;

/**
 获取云盘文件数量
 */
-(void)getCloudFileCount:(QCloudSMHGetFileCountRequest *)requset;

/// 查询 inode 文件信息（返回路径）
-(void)getINodeDetail:(QCloudSMHGetINodeDetailRequest *)request;

/// 查询最近使用的文件列表
-(void)getRecentlyUsedFile:(QCloudSMHGetRecentlyUsedFileRequest *)request;

/// 更新目录自定义标签
-(void)updateDirectoryTag:(QCloudUpdateDirectoryTagRequest *)request;

/// 用于列出空间首页内容，会忽略目录的层级关系，列出空间下所有文件
-(void)getSpaceHomeFile:(QCloudSMHGetSpaceHomeFileRequest *)request;

/// 用于更新文件的标签（Labels）或分类（Category）
-(void)updateFileTag:(QCloudUpdateFileTagRequest *)request;

///  用于预览回收站项目
-(void)getRecyclePresignedURL:(QCloudSMHGetRecyclePresignedURLRequest *)request;

/// 用于查看回收站文件详情，以便进行预览
-(void)getRecycleFileDetail:(QCloudSMHGetRecycleFileDetailReqeust *)request;

///  设置租户空间限速
-(void)setSpaceTrafficLimit:(QCloudSetSpaceTrafficLimitRequest *)request;

///  查看指定空间收藏列表
-(void)listFavoriteSpaceFile:(QCloudSMHListFavoriteSpaceFileRequest *)request;

/// 收藏文件目录
-(void)favoriteSpaceFile:(QCloudSMHFavoriteSpaceFileRequest *)request;

///  删除指定空间收藏
-(void)deleteFavoriteSpaceFile:(QCloudSMHDeleteFavoriteSpaceFileRequest *)request;

-(void)getSpaceUsage:(QCloudGetSpaceUsageRequest *)request;

-(void)putObjectLink:(QCloudSMHPutObjectLinkRequest *)request;

/// 查询文件删除原因
-(void)fileDeletionCheck:(QCloudSMHFileDeletionCheckRequest *)request;

#pragma mark - 第三方 URL 下载（内部使用）

/**
 * 执行第三方 URL 下载请求（内部使用）
 *
 * @param request 第三方 URL 下载请求
 * @note 此方法为 SDK 内部使用，用于流式同步上传场景
 */
- (void)downloadExternalURL:(QCloudSMHExternalURLDownloadRequest *)request;

#pragma mark - Token

/**
 生成访问令牌（Access Token）

 @param request 生成访问令牌请求
 */
- (void)createToken:(QCloudSMHCreateTokenRequest *)request;

/**
 续期访问令牌（Access Token）

 @param request 续期访问令牌请求
 */
- (void)renewToken:(QCloudSMHRenewTokenRequest *)request;

/**
 删除指定访问令牌（Access Token）

 @param request 删除访问令牌请求
 */
- (void)deleteToken:(QCloudSMHDeleteTokenRequest *)request;

/**
 删除特定用户的所有访问令牌（Access Token）

 @param request 删除用户所有访问令牌请求
 */
- (void)deleteUserTokens:(QCloudSMHDeleteUserTokensRequest *)request;

#pragma mark - Space

/**
 创建租户空间

 @param request 创建租户空间请求
 */
- (void)createSpace:(QCloudSMHCreateSpaceRequest *)request;

/**
 列出租户空间

 @param request 列出租户空间请求
 */
- (void)listSpace:(QCloudSMHListSpaceRequest *)request;

/**
 查询租户空间属性

 @param request 查询租户空间属性请求
 */
- (void)getSpaceExtension:(QCloudSMHGetSpaceExtensionRequest *)request;

/**
 修改租户空间属性

 @param request 修改租户空间属性请求
 */
- (void)updateSpaceExtension:(QCloudSMHUpdateSpaceExtensionRequest *)request;

/**
 删除租户空间

 @param request 删除租户空间请求
 */
- (void)deleteSpace:(QCloudSMHDeleteSpaceRequest *)request;

/**
 查询媒体库租户空间数量

 @param request 查询租户空间数量请求
 */
- (void)getLibrarySpaceCount:(QCloudSMHGetLibrarySpaceCountRequest *)request;

#pragma mark - Usage

/**
 查询媒体库容量信息

 @param request 查询媒体库容量信息请求
 */
- (void)getLibraryUsage:(QCloudSMHGetLibraryUsageRequest *)request;

#pragma mark - File

/**
 文档转码

 @param request 文档转码请求
 */
- (void)convertFile:(QCloudSMHConvertFileRequest *)request;

/**
 获取 HTML 格式文档预览

 @param request 文档预览请求
 */
- (void)previewFile:(QCloudSMHPreviewFileRequest *)request;

/**
 视频下载（获取转码后的视频下载链接）

 @param request 视频下载请求
 */
- (void)downloadTranscodedVideo:(QCloudSMHDownloadTranscodedVideoRequest *)request;

#pragma mark - Delta

/**
 获取增量游标

 @param request 获取增量游标请求
 */
- (void)getDeltaCursor:(QCloudSMHGetDeltaCursorRequest *)request;

/**
 查询增量变动日志

 @param request 查询增量变动日志请求
 */
- (void)queryDeltaLog:(QCloudSMHQueryDeltaLogRequest *)request;

#pragma mark - History

/**
 清空历史版本

 @param request 清空历史版本请求
 */
- (void)emptyHistory:(QCloudSMHEmptyHistoryRequest *)request;

#pragma mark - Quota

/**
 创建配额

 @param request 创建配额请求
 */
- (void)createQuota:(QCloudSMHCreateQuotaRequest *)request;

/**
 获取租户空间配额

 @param request 获取租户空间配额请求
 */
- (void)getQuota:(QCloudSMHGetQuotaRequest *)request;

/**
 修改配额

 @param request 修改配额请求
 */
- (void)updateQuota:(QCloudSMHUpdateQuotaRequest *)request;

/**
 根据配额 ID 修改配额

 @param request 根据配额 ID 修改配额请求
 */
- (void)updateQuotaById:(QCloudSMHUpdateQuotaByIdRequest *)request;

/**
 获取租户配额信息

 @param request 获取租户配额信息请求
 */
- (void)getQuotaInfo:(QCloudSMHGetQuotaInfoRequest *)request;

#pragma mark - HLS

/**
 查询媒体文件的元信息（视频高度、宽度、比特率、时长等）

 @param request 查询媒体文件元信息请求
 */
- (void)getMediaFileInfo:(QCloudSMHGetMediaFileInfoRequest *)request;

/**
 视频转码

 @param request 视频转码请求
 */
- (void)createTranscodeTask:(QCloudSMHCreateTranscodeTaskRequest *)request;

/**
 m3u8 上传准备

 @param request m3u8 上传准备请求
 */
- (void)prepareM3u8Upload:(QCloudSMHPrepareM3u8UploadRequest *)request;

/**
 m3u8 上传完成（确认）

 @param request m3u8 上传完成请求
 */
- (void)confirmM3u8Upload:(QCloudSMHConfirmM3u8UploadRequest *)request;

/**
 m3u8 上传续期

 @param request m3u8 上传续期请求
 */
- (void)renewM3u8Upload:(QCloudSMHRenewM3u8UploadRequest *)request;

/**
 m3u8 分片重传与追加

 @param request m3u8 分片重传与追加请求
 */
- (void)modifyM3u8Segments:(QCloudSMHModifyM3u8SegmentsRequest *)request;

/**
 发起实时转码任务并获取带授权信息的播放列表

 @param request 实时转码请求
 */
- (void)liveTranscodeMediaFile:(QCloudSMHLiveTranscodeMediaFileRequest *)request;

#pragma mark - Directory Stats

/**
 查询目录统计数据（子目录数量、文件数量、文件总大小）

 @param request 查询目录统计数据请求
 */
- (void)getDirectoryStats:(QCloudSMHGetDirectoryStatsRequest *)request;

/**
 校准目录统计数据

 @param request 校准目录统计数据请求
 */
- (void)calibrateDirectoryStats:(QCloudSMHCalibrateDirectoryStatsRequest *)request;

#pragma mark - Recycle Lifecycle

/**
 设置回收站生命周期

 @param request 设置回收站生命周期请求
 */
- (void)recycleSetLifecycle:(QCloudSMHRecycleSetLifecycleRequest *)request;

#pragma mark - Share

/**
 验证提取码

 @param request 验证提取码请求
 */
- (void)verifyExtractionCode:(QCloudSMHVerifyExtractionCodeRequest *)request;

/**
 搜索分享

 @param request 搜索分享请求
 */
- (void)searchShares:(QCloudSMHSearchSharesRequest *)request;

/**
 禁用或启用分享

 @param request 禁用或启用分享请求
 */
- (void)setShareEnabled:(QCloudSMHSetShareEnabledRequest *)request;

/**
 获取分享详情

 @param request 获取分享详情请求
 */
- (void)getShareDetail:(QCloudSMHGetShareDetailRequest *)request;

/**
 列出分享

 @param request 列出分享请求
 */
- (void)listShares:(QCloudSMHListSharesRequest *)request;

/**
 获取分享 URL 详情

 @param request 获取分享 URL 详情请求
 */
- (void)getShareUrlDetail:(QCloudSMHGetShareUrlDetailRequest *)request;

/**
 更新分享

 @param request 更新分享请求
 */
- (void)updateShare:(QCloudSMHUpdateShareRequest *)request;

/**
 分享文件转存

 @param request 分享文件转存请求
 */
- (void)saveShareFile:(QCloudSMHSaveShareFileRequest *)request;

/**
 分享文件预览

 @param request 分享文件预览请求
 */
- (void)previewShareFile:(QCloudSMHPreviewShareFileRequest *)request;

/**
 分享文件下载

 @param request 分享文件下载请求
 */
- (void)downloadShareFile:(QCloudSMHDownloadShareFileRequest *)request;

/**
 列出分享文件

 @param request 列出分享文件请求
 */
- (void)listShareFiles:(QCloudSMHListShareFilesRequest *)request;

/**
 创建分享

 @param request 创建分享请求
 */
- (void)createShare:(QCloudSMHCreateShareRequest *)request;

/**
 删除分享

 @param request 删除分享请求
 */
- (void)deleteShare:(QCloudSMHDeleteShareRequest *)request;

@end

NS_ASSUME_NONNULL_END
