//
//  QCloudSMHService.m
//  Pods
//
//  Created by karisli(李雪) on 2021/7/13.
//

#import "QCloudSMHService.h"
#import "QCloudSMHSpaceInfo.h"
#import <QCloudCore/QCloudConfiguration_Private.h>
#import "QCloudSMHListContentsRequest.h"
#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHHeadDirectoryRequest.h"
#import "QCloudSMHPutDirectoryRequest.h"
#import "QCloudSMHDeleteDirectoryRequest.h"
#import "QCloudSMHDownloadFileRequest.h"
#import "QCloudSMHGetUploadStateRequest.h"
#import "QCloudCOSSMHPutObjectRequest.h"
#import "QCloudSMHUploadPartRequest.h"
#import "QCloudCOSSMHUploadPartRequest.h"
#import "QCloudSMHCompleteUploadRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"

#import "QCloudSMHGetRecycleObjectListReqeust.h"
#import "QCloudSMHDeleteRecycleObjectReqeust.h"
#import "QCloudSMHRestoreRecycleObjectReqeust.h"
#import "QCloudSMHDeleteAllRecycleObjectReqeust.h"
#import "QCloudSMHBatchDeleteRecycleObjectReqeust.h"
#import "QCloudSMHBatchRestoreRecycleObjectReqeust.h"

#import "QCloudSMHPutObjectRenewRequest.h"
#import "QCloudSMHGetPresignedURLRequest.h"
#import "QCloudSMHBatchBaseRequest.h"
#import "QCloudSMHGetRoleListRequest.h"
#import "QCloudSMHPostAuthorizeRequest.h"
#import "QCloudSMHDeleteAuthorizeRequest.h"
#import "QCloudSMHGetDownloadInfoRequest.h"

#import "QCloudSMHGetHistoryInfoRequest.h"
#import "QCloudSMHQuickPutObjectRequest.h"
#import "QCloudDeleteLocalSyncRequest.h"

#import "QCloudSMHGetFileListByTagsRequest.h"
#import "QCloudSMHDeleteFileTagRequest.h"
#import "QCloudSMHGetFileTagRequest.h"
#import "QCloudSMHPutFileTagRequest.h"
#import "QCloudSMHDeleteTagRequest.h"
#import "QCloudSMHGetTagListRequest.h"
#import "QCloudSMHPutTagRequest.h"
#import "QCloudSMHExitFileAuthorizeRequest.h"
#import "QCloudCOSSMHDownloadObjectRequest.h"
#import "QCloudSMHCrossSpaceAsyncCopyDirectoryRequest.h"
#import "QCloudSMHGetAlbumRequest.h"
#import "QCloudSMHCrossSpaceCopyDirectoryRequest.h"
#import "QCloudSMHCreateFileRequest.h"
#import "QCloudSMHEditFileOnlineRequest.h"
#import "QCloudSMHCheckHostRequest.h"
#import "QCloudSMHDetailDirectoryRequest.h"
#import "QCloudSMHSpaceAuthorizeRequest.h"
#import "QCloudSMHAPIListHistoryVersionRequest.h"
#import "QCloudSMHGetFileCountRequest.h"
#import "QCloudSMHGetINodeDetailRequest.h"
#import "QCloudSMHGetRecentlyUsedFileRequest.h"
#import "QCloudUpdateDirectoryTagRequest.h"
#import "QCloudSMHGetSpaceHomeFileRequest.h"
#import "QCloudUpdateFileTagRequest.h"
#import "QCloudSMHGetRecyclePresignedURLRequest.h"
#import "QCloudSMHGetRecycleFileDetailReqeust.h"
#import "QCloudSetSpaceTrafficLimitRequest.h"
#import "QCloudSMHListFavoriteSpaceFileRequest.h"
#import "QCloudSMHFavoriteSpaceFileRequest.h"
#import "QCloudSMHDeleteFavoriteSpaceFileRequest.h"
#import "QCloudGetSpaceUsageRequest.h"
#import "QCloudSMHPutObjectLinkRequest.h"
#import "QCloudSMHExternalURLDownloadRequest.h"
#import "QCloudSMHFileDeletionCheckRequest.h"
#import "QCloudSMHCreateTokenRequest.h"
#import "QCloudSMHRenewTokenRequest.h"
#import "QCloudSMHDeleteTokenRequest.h"
#import "QCloudSMHUpdateQuotaByIdRequest.h"
#import "QCloudSMHGetQuotaInfoRequest.h"
#import "QCloudSMHPrepareM3u8UploadRequest.h"
#import "QCloudSMHConfirmM3u8UploadRequest.h"
#import "QCloudSMHRenewM3u8UploadRequest.h"
#import "QCloudSMHModifyM3u8SegmentsRequest.h"
#import "QCloudSMHLiveTranscodeMediaFileRequest.h"
#import "QCloudSMHDeleteUserTokensRequest.h"
#import "QCloudSMHCreateSpaceRequest.h"
#import "QCloudSMHListSpaceRequest.h"
#import "QCloudSMHGetSpaceExtensionRequest.h"
#import "QCloudSMHUpdateSpaceExtensionRequest.h"
#import "QCloudSMHDeleteSpaceRequest.h"
#import "QCloudSMHGetLibrarySpaceCountRequest.h"
#import "QCloudSMHGetLibraryUsageRequest.h"
#import "QCloudSMHConvertFileRequest.h"
#import "QCloudSMHPreviewFileRequest.h"
#import "QCloudSMHDownloadTranscodedVideoRequest.h"
#import "QCloudSMHGetDeltaCursorRequest.h"
#import "QCloudSMHQueryDeltaLogRequest.h"
#import "QCloudSMHEmptyHistoryRequest.h"
#import "QCloudSMHCreateQuotaRequest.h"
#import "QCloudSMHGetQuotaRequest.h"
#import "QCloudSMHUpdateQuotaRequest.h"
#import "QCloudSMHGetMediaFileInfoRequest.h"
#import "QCloudSMHCreateTranscodeTaskRequest.h"
#import "QCloudSMHGetDirectoryStatsRequest.h"
#import "QCloudSMHCalibrateDirectoryStatsRequest.h"
#import "QCloudSMHRecycleSetLifecycleRequest.h"
#import "QCloudSMHVerifyExtractionCodeRequest.h"
#import "QCloudSMHSearchSharesRequest.h"
#import "QCloudSMHSetShareEnabledRequest.h"
#import "QCloudSMHGetShareDetailRequest.h"
#import "QCloudSMHListSharesRequest.h"
#import "QCloudSMHGetShareUrlDetailRequest.h"
#import "QCloudSMHUpdateShareRequest.h"
#import "QCloudSMHSaveShareFileRequest.h"
#import "QCloudSMHPreviewShareFileRequest.h"
#import "QCloudSMHDownloadShareFileRequest.h"
#import "QCloudSMHListShareFilesRequest.h"
#import "QCloudSMHCreateShareRequest.h"
#import "QCloudSMHDeleteShareRequest.h"

@interface QCloudSMHService()
@property (nonatomic,strong)QCloudConfiguration *configuration;
@property (nonatomic, strong, readonly) QCloudOperationQueue *uploadFileQueue;
@property (nonatomic, strong, readonly) QCloudOperationQueue *contentListQueue;

@end
static QCloudSMHService *_service;
@implementation QCloudSMHService
+ (QCloudSMHService *)defaultSMHService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QCloudConfiguration *config = [QCloudConfiguration new];
        _service = [[QCloudSMHService alloc] init];
        _service.configuration = config;
    });
    return _service;
}

- (instancetype)init{
    if(self  = [super init]){
        _uploadFileQueue = [QCloudOperationQueue new];
        _contentListQueue = [QCloudOperationQueue new];
        
    }
    return self;
}

- (void)deleteLocalSync:(QCloudDeleteLocalSyncRequest *)request{
    [self performRequest:request];
}


-(void)smhPutObject:(QCloudSMHPutObjectRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)smhQuickPutObject:(QCloudSMHQuickPutObjectRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)getUploadStateInfo:(QCloudSMHGetUploadStateRequest *)request{
    [self performRequest:request];
}

-(void)smhStartPartUpload:(QCloudSMHUploadPartRequest *)request{
    [self performRequest:request];
}

-(void)putObject:(QCloudCOSSMHPutObjectRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)uploadPartObject:(QCloudCOSSMHUploadPartRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}


-(void)complelteUploadPartObject:(QCloudSMHCompleteUploadRequest *)request{
    [self performRequest:request];
}

-(void)deleteUploadPartObject:(QCloudSMHAbortMultipfartUploadRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

- (void)listContents:(QCloudSMHListContentsRequest *)request{
    [self performRequest:request];
}

- (void)batchListContents:(QCloudSMHListContentsRequest *)request {
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:request];
    [self.contentListQueue addOpreation:operation];
}

- (void)initSearch:(QCloudSMHInitiateSearchRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)resumeSearch:(QCloudSMHResumeSearchRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)abortSearch:(QCloudSMHAbortSearchRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}
-(void)deleteFile:(QCloudSMHDeleteFileRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}
- (void)headDirectory:(QCloudSMHHeadDirectoryRequest *)request{
    [self performRequest:request];
}


-(void)putDirectory:(QCloudSMHPutDirectoryRequest *)request{
    [self performRequest:request];
}

-(void)deleteDirectory:(QCloudSMHDeleteDirectoryRequest *)request{
    [self performRequest:request];
}

- (void)renameDirecotry:(QCloudSMHRenameDirectoryRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}
- (BOOL)fillCommonParamtersForRequest:(QCloudSMHBizRequest *)request error:(NSError *_Nullable __autoreleasing *)error {
    request.accessTokenProvider = self.accessTokenProvider;
    if (self.configuration.userAgent.length) {
        [request.requestData setValue:self.configuration.userAgent forHTTPHeaderField:HTTPHeaderUserAgent];
    }
    return YES;
}

-(void)downloadFile:(QCloudSMHDownloadFileRequest *)request{
    [self performRequest:request];
}

-(void)headFile:(QCloudSMHHeadFileRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}


- (void)putHisotryVersion:(QCloudSMHPutHisotryVersionRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)setLatestVersion:(QCloudSMHSetLatestVersionRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)deleteHisotryVersion:(QCloudSMHDeleteHistoryVersionRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

-(void)renameFile:(QCloudSMHRenameFileRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}
-(void)getPresignedURL:(QCloudSMHGetPresignedURLRequest *)request{
    request.accessTokenProvider = self.accessTokenProvider;
    NSError *error;
    NSURLRequest *urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return;
    }
    __block NSString *requestURLString = urlRequest.URL.absoluteString;
    [request.accessTokenProvider accessTokenWithRequest:request urlRequest:urlRequest compelete:^(QCloudSMHSpaceInfo *spaceInfo, NSError *error) {
        if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
            requestURLString = [requestURLString stringByAppendingFormat:@"access_token=%@",spaceInfo.accessToken];
        } else {
            requestURLString = [requestURLString stringByAppendingFormat:@"&access_token=%@", spaceInfo.accessToken];
        }
        if (spaceInfo.libraryId != nil) {
            if (request.libraryId) {
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:request.libraryId withString:spaceInfo.libraryId];
            }else{
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"emptyLibraryId" withString:spaceInfo.libraryId];
            }
        }
        
        if (request.finishBlock) {
            request.finishBlock(requestURLString, nil);
        }
    }];
}

-(void)getEditFileOnlineUrl:(QCloudSMHEditFileOnlineRequest *)request{
    request.accessTokenProvider = self.accessTokenProvider;
    NSError *error;
    NSURLRequest *urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return;
    }
    __block NSString *requestURLString = urlRequest.URL.absoluteString;
    [request.accessTokenProvider accessTokenWithRequest:request urlRequest:urlRequest compelete:^(QCloudSMHSpaceInfo *spaceInfo, NSError *error) {
        if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
            requestURLString = [requestURLString stringByAppendingFormat:@"access_token=%@",spaceInfo.accessToken];
        } else {
            requestURLString = [requestURLString stringByAppendingFormat:@"&access_token=%@", spaceInfo.accessToken];
        }
        if (spaceInfo.libraryId != nil) {
            if (request.libraryId) {
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:request.libraryId withString:spaceInfo.libraryId];
            }else{
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"emptyLibraryId" withString:spaceInfo.libraryId];
            }
        }
        
        if (request.finishBlock) {
            request.finishBlock(requestURLString, nil);
        }
    }];

}

- (void)copyFile:(QCloudSMHCopyFileRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}
- (void)uploadObject:(QCloudCOSSMHUploadObjectRequest *)request {
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:request];
    request.ownerQueue = self.uploadFileQueue;
    [self.uploadFileQueue addOpreation:operation];
}


-(void)getThumbnail:(QCloudGetFileThumbnailRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

- (int)performRequest:(QCloudSMHBizRequest *)httpRequst {
    httpRequst.timeoutInterval = self.configuration.timeoutInterval;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error;
        [self fillCommonParamtersForRequest:httpRequst error:&error];
        if (error) {
            [httpRequst onError:error];
            return;
        }

        [[QCloudHTTPSessionManager shareClient] performRequest:httpRequst];
    });

    return (int)httpRequst.requestID;
}


-(void)getRecycleList:(QCloudSMHGetRecycleObjectListReqeust *)request{
    [self performRequest:request];
}

-(void)deleteRecycleObject:(QCloudSMHDeleteRecycleObjectReqeust *)request{
    [self performRequest:request];
}

-(void)restoreRecyleObject:(QCloudSMHRestoreRecycleObjectReqeust *)request{
    [self performRequest:request];
}

-(void)deleteAllRecyleObject:(QCloudSMHDeleteAllRecycleObjectReqeust *)request{
    [self performRequest:request];
}

-(void)batchDeleteRecycleObject:(QCloudSMHBatchDeleteRecycleObjectReqeust *)request{
    [self performRequest:request];
}

-(void)batchRestoreRecycleObject:(QCloudSMHBatchRestoreRecycleObjectReqeust *)request{
    [self performRequest:request];
}

#pragma mark - batch

-(void)getTaskStatus:(QCloudGetTaskStatusRequest *)request{
    [self performRequest:request];
}

- (void)batchMove:(QCloudSMHBatchMoveRequest *)request{
    [self performRequest:request];
}

- (void)batchDelete:(QCloudSMHBatchDeleteRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}

- (void)batchCopy:(QCloudSMHBatchCopyRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];

}

- (void)renewUploadInfo:(QCloudSMHPutObjectRenewRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}


-(void)deleteObject:(QCloudSMHDeleteObjectRequest*)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.uploadFileQueue addOpreation:operation];
}

-(void)copyObject:(QCloudSMHCopyObjectRequest*)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.uploadFileQueue addOpreation:operation];
}

-(void)moveObject:(QCloudSMHMoveObjectRequest*)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.uploadFileQueue addOpreation:operation];
}

-(void)restoreObject:(QCloudSMHRestoreObjectRequest *)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.uploadFileQueue addOpreation:operation];
}


#pragma mark - authority
 
/**
 获取文件
 */
- (void)getMyAuthorizedDirectory:(QCloudSMHGetMyAuthorizedDirectoryRequest *)request{
    [self performRequest:(QCloudSMHBizRequest *)request];
}


//授权给某个人
- (void)authorizedDirectoryToSomeone:(QCloudSMHPostAuthorizeRequest *)request{
    [self performRequest:request];
}

///  删除授权
- (void)deleteAuthorizedDirectoryFromSomeone:(QCloudSMHDeleteAuthorizeRequest *)request{
    [self performRequest:request];
}

- (void)getRoleList:(QCloudSMHGetRoleListRequest *)request{
    [self performRequest:request];
}

- (void)getDonwloadInfo:(QCloudSMHGetDownloadInfoRequest *)request{
    [self performRequest:request];
}

- (void)getHistoryDetailInfo:(QCloudSMHGetHistoryInfoRequest *)request{
    [self performRequest:request];
}

- (void)getFileListByTags:(QCloudSMHGetFileListByTagsRequest *)request{
    [self performRequest:request];
}

- (void)deleteFileTag:(QCloudSMHDeleteFileTagRequest *)request{
    [self performRequest:request];
}

- (void)getFileTag:(QCloudSMHGetFileTagRequest *)request{
    [self performRequest:request];
}

- (void)putFileTag:(QCloudSMHPutFileTagRequest *)request{
    [self performRequest:request];
}

- (void)deleteTag:(QCloudSMHDeleteTagRequest *)request{
    [self performRequest:request];
}

- (void)getTagList:(QCloudSMHGetTagListRequest *)request{
    [self performRequest:request];
}

- (void)putTag:(QCloudSMHPutTagRequest *)request{
    [self performRequest:request];
}

- (void)exitFileAuthorize:(QCloudSMHExitFileAuthorizeRequest *)request{
    [self performRequest:request];
}

-(void)smhDownload:(QCloudCOSSMHDownloadObjectRequest *)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:request];
    request.ownerQueue = self.uploadFileQueue;
    [self.uploadFileQueue addOpreation:operation];
}




-(void)crossSpaceAsyncCopyDirectory:(QCloudSMHCrossSpaceAsyncCopyDirectoryRequest *)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.uploadFileQueue addOpreation:operation];
}

-(void)getAlbum:(QCloudSMHGetAlbumRequest *)request{
    [self performRequest:request];
}

-(void)crossSpaceCopyDirectory:(QCloudSMHCrossSpaceCopyDirectoryRequest *)request{
    [self performRequest:request];
}

-(void)createFileRequest:(QCloudSMHCreateFileRequest *)request{
    [self performRequest:request];
}

-(void)checkHost:(QCloudSMHCheckHostRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)detailDirectory:(QCloudSMHDetailDirectoryRequest *)request{
    [self performRequest:request];
}

-(void)spaceAuthorize:(QCloudSMHSpaceAuthorizeRequest *)request{
    [self performRequest:request];
}

-(void)listHistoryVersion:(QCloudSMHAPIListHistoryVersionRequest *)request{
    [self performRequest:request];
}

- (void)getCloudFileCount:(QCloudSMHGetFileCountRequest *)requset {
    [self performRequest:requset];
}

-(void)getINodeDetail:(QCloudSMHGetINodeDetailRequest *)request{
    [self performRequest:request];
}

-(void)getRecentlyUsedFile:(QCloudSMHGetRecentlyUsedFileRequest *)request{
    [self performRequest:request];
}

-(void)updateDirectoryTag:(QCloudUpdateDirectoryTagRequest *)request{
    [self performRequest:request];
}


-(void)getSpaceHomeFile:(QCloudSMHGetSpaceHomeFileRequest *)request{
    [self performRequest:request];
}

-(void)updateFileTag:(QCloudUpdateFileTagRequest *)request{
    [self performRequest:request];
}

-(void)getRecyclePresignedURL:(QCloudSMHGetRecyclePresignedURLRequest *)request{
    request.accessTokenProvider = self.accessTokenProvider;
    NSError *error;
    NSURLRequest *urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return;
    }
    __block NSString *requestURLString = urlRequest.URL.absoluteString;
    [request.accessTokenProvider accessTokenWithRequest:request urlRequest:urlRequest compelete:^(QCloudSMHSpaceInfo *spaceInfo, NSError *error) {
        if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
            requestURLString = [requestURLString stringByAppendingFormat:@"access_token=%@",spaceInfo.accessToken];
        } else {
            requestURLString = [requestURLString stringByAppendingFormat:@"&access_token=%@", spaceInfo.accessToken];
        }
        if (spaceInfo.libraryId != nil) {
            if (request.libraryId) {
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:request.libraryId withString:spaceInfo.libraryId];
            }else{
                requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"emptyLibraryId" withString:spaceInfo.libraryId];
            }
        }
        
        if (request.finishBlock) {
            request.finishBlock(requestURLString, nil);
        }
    }];
}
-(void)getRecycleFileDetail:(QCloudSMHGetRecycleFileDetailReqeust *)request{
    [self performRequest:request];
}
-(void)setSpaceTrafficLimit:(QCloudSetSpaceTrafficLimitRequest *)request{
    [self performRequest:request];
}
-(void)listFavoriteSpaceFile:(QCloudSMHListFavoriteSpaceFileRequest *)request{
    [self performRequest:request];
}
-(void)favoriteSpaceFile:(QCloudSMHFavoriteSpaceFileRequest *)request{
    [self performRequest:request];
}
-(void)deleteFavoriteSpaceFile:(QCloudSMHDeleteFavoriteSpaceFileRequest *)request{
    [self performRequest:request];
}


-(void)getSpaceUsage:(QCloudGetSpaceUsageRequest *)request{
    [self performRequest:request];
}

-(void)putObjectLink:(QCloudSMHPutObjectLinkRequest *)request{
    [self performRequest:request];
}

-(void)fileDeletionCheck:(QCloudSMHFileDeletionCheckRequest *)request{
    [self performRequest:request];
}

#pragma mark - 第三方 URL 下载（内部使用）

- (void)downloadExternalURL:(QCloudSMHExternalURLDownloadRequest *)request {
    request.timeoutInterval = self.configuration.timeoutInterval;
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

#pragma mark - Token

- (void)createToken:(QCloudSMHCreateTokenRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)renewToken:(QCloudSMHRenewTokenRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)deleteToken:(QCloudSMHDeleteTokenRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)deleteUserTokens:(QCloudSMHDeleteUserTokensRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

#pragma mark - Space

- (void)createSpace:(QCloudSMHCreateSpaceRequest *)request {
    [self performRequest:request];
}

- (void)listSpace:(QCloudSMHListSpaceRequest *)request {
    [self performRequest:request];
}

- (void)getSpaceExtension:(QCloudSMHGetSpaceExtensionRequest *)request {
    [self performRequest:request];
}

- (void)updateSpaceExtension:(QCloudSMHUpdateSpaceExtensionRequest *)request {
    [self performRequest:request];
}

- (void)deleteSpace:(QCloudSMHDeleteSpaceRequest *)request {
    [self performRequest:request];
}

- (void)getLibrarySpaceCount:(QCloudSMHGetLibrarySpaceCountRequest *)request {
    [self performRequest:request];
}

#pragma mark - Usage

- (void)getLibraryUsage:(QCloudSMHGetLibraryUsageRequest *)request {
    [self performRequest:request];
}

#pragma mark - File

- (void)convertFile:(QCloudSMHConvertFileRequest *)request {
    [self performRequest:request];
}

- (void)previewFile:(QCloudSMHPreviewFileRequest *)request {
    [self performRequest:request];
}

- (void)downloadTranscodedVideo:(QCloudSMHDownloadTranscodedVideoRequest *)request {
    [self performRequest:request];
}

#pragma mark - Delta

- (void)getDeltaCursor:(QCloudSMHGetDeltaCursorRequest *)request {
    [self performRequest:request];
}

- (void)queryDeltaLog:(QCloudSMHQueryDeltaLogRequest *)request {
    [self performRequest:request];
}

#pragma mark - History

- (void)emptyHistory:(QCloudSMHEmptyHistoryRequest *)request {
    [self performRequest:request];
}

#pragma mark - Quota

- (void)createQuota:(QCloudSMHCreateQuotaRequest *)request {
    [self performRequest:request];
}

- (void)getQuota:(QCloudSMHGetQuotaRequest *)request {
    [self performRequest:request];
}

- (void)updateQuota:(QCloudSMHUpdateQuotaRequest *)request {
    [self performRequest:request];
}

- (void)updateQuotaById:(QCloudSMHUpdateQuotaByIdRequest *)request {
    [self performRequest:request];
}

- (void)getQuotaInfo:(QCloudSMHGetQuotaInfoRequest *)request {
    [self performRequest:request];
}

#pragma mark - HLS

- (void)getMediaFileInfo:(QCloudSMHGetMediaFileInfoRequest *)request {
    [self performRequest:request];
}

- (void)createTranscodeTask:(QCloudSMHCreateTranscodeTaskRequest *)request {
    [self performRequest:request];
}

- (void)prepareM3u8Upload:(QCloudSMHPrepareM3u8UploadRequest *)request {
    [self performRequest:request];
}

- (void)confirmM3u8Upload:(QCloudSMHConfirmM3u8UploadRequest *)request {
    [self performRequest:request];
}

- (void)renewM3u8Upload:(QCloudSMHRenewM3u8UploadRequest *)request {
    [self performRequest:request];
}

- (void)modifyM3u8Segments:(QCloudSMHModifyM3u8SegmentsRequest *)request {
    [self performRequest:request];
}

- (void)liveTranscodeMediaFile:(QCloudSMHLiveTranscodeMediaFileRequest *)request {
    [self performRequest:request];
}

#pragma mark - Directory

- (void)getDirectoryStats:(QCloudSMHGetDirectoryStatsRequest *)request {
    [self performRequest:request];
}

- (void)calibrateDirectoryStats:(QCloudSMHCalibrateDirectoryStatsRequest *)request {
    [self performRequest:request];
}

#pragma mark - Recycle

- (void)recycleSetLifecycle:(QCloudSMHRecycleSetLifecycleRequest *)request {
    [self performRequest:request];
}

#pragma mark - Share

- (void)verifyExtractionCode:(QCloudSMHVerifyExtractionCodeRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)searchShares:(QCloudSMHSearchSharesRequest *)request {
    [self performRequest:request];
}

- (void)setShareEnabled:(QCloudSMHSetShareEnabledRequest *)request {
    [self performRequest:request];
}

- (void)getShareDetail:(QCloudSMHGetShareDetailRequest *)request {
    [self performRequest:request];
}

- (void)listShares:(QCloudSMHListSharesRequest *)request {
    [self performRequest:request];
}

- (void)getShareUrlDetail:(QCloudSMHGetShareUrlDetailRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)updateShare:(QCloudSMHUpdateShareRequest *)request {
    [self performRequest:request];
}

- (void)saveShareFile:(QCloudSMHSaveShareFileRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)previewShareFile:(QCloudSMHPreviewShareFileRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)downloadShareFile:(QCloudSMHDownloadShareFileRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)listShareFiles:(QCloudSMHListShareFilesRequest *)request {
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)createShare:(QCloudSMHCreateShareRequest *)request {
    [self performRequest:request];
}

- (void)deleteShare:(QCloudSMHDeleteShareRequest *)request {
    [self performRequest:request];
}

@end
