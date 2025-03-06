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
@class QCloudSMHListHistoryVersionRequest;
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
- (void)renewUploadInfo:(QCloudSMHPutObjectRenewRequest *)request;
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

@end

NS_ASSUME_NONNULL_END
