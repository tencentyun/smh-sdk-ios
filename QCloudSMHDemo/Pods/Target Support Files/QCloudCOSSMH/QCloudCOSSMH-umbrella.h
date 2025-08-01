#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QCloudSMHBatchCopyInfo.h"
#import "QCloudSMHBatchDeleteInfo.h"
#import "QCloudSMHBatchMoveInfo.h"
#import "QCloudSMHDeleteResult.h"
#import "QCloudSMHExitFileAuthorize.h"
#import "QCloudSMHFavoriteSpaceFileResult.h"
#import "QCloudSMHFileCountInfo.h"
#import "QCloudSMHHistoryStateInfo.h"
#import "QCloudSMHINodeDetailInfo.h"
#import "QCloudSMHRecentlyUsedFileInfo.h"
#import "QCloudSMHRenameResult.h"
#import "QCloudSMHSelectRoleInfo.h"
#import "QCloudSMHSpaceHomeFileInfo.h"
#import "QCloudSMHSpaceUsageInfo.h"
#import "QCloudSMHMultipartInfo.h"
#import "QCloudSMHMultipartUploadPart.h"
#import "QCloudSMHUploadObjectResult.h"
#import "QCloudSMHUploadPartResult.h"
#import "QCloudSMHConfirmInfo.h"
#import "QCloudSMHDownloadInfoModel.h"
#import "QCloudSMHPutObjectLinkInfo.h"
#import "QCloudSMHUploadStateInfo.h"
#import "QCloudSMHService.h"
#import "QCloudSMHDeleteAuthorizeRequest.h"
#import "QCloudSMHExitFileAuthorizeRequest.h"
#import "QCloudSMHGetMyAuthorizedDirectoryRequest.h"
#import "QCloudSMHGetRoleListRequest.h"
#import "QCloudSMHPostAuthorizeRequest.h"
#import "QCloudSMHSpaceAuthorizeRequest.h"
#import "QCloudGetTaskStatusRequest.h"
#import "QCloudSMHBatchBaseRequest.h"
#import "QCloudSMHBatchCopyRequest.h"
#import "QCloudSMHBatchDeleteRequest.h"
#import "QCloudSMHBatchMoveRequest.h"
#import "QCloudSMHCopyObjectRequest.h"
#import "QCloudSMHDeleteObjectRequest.h"
#import "QCloudSMHMoveObjectRequest.h"
#import "QCloudSMHRestoreObjectRequest.h"
#import "QCloudDeleteLocalSyncRequest.h"
#import "QCloudSMHCrossSpaceAsyncCopyDirectoryRequest.h"
#import "QCloudSMHCrossSpaceCopyDirectoryRequest.h"
#import "QCloudSMHDeleteDirectoryRequest.h"
#import "QCloudSMHDetailDirectoryRequest.h"
#import "QCloudSMHHeadDirectoryRequest.h"
#import "QCloudSMHPutDirectoryRequest.h"
#import "QCloudSMHRenameDirectoryRequest.h"
#import "QCloudUpdateDirectoryTagRequest.h"
#import "QCloudGetFileThumbnailRequest.h"
#import "QCloudSMHAbortSearchRequest.h"
#import "QCloudSMHAPIListHistoryVersionRequest.h"
#import "QCloudSMHCopyFileRequest.h"
#import "QCloudSMHCreateFileRequest.h"
#import "QCloudSMHDeleteFavoriteSpaceFileRequest.h"
#import "QCloudSMHDeleteFileRequest.h"
#import "QCloudSMHDeleteFileTagRequest.h"
#import "QCloudSMHDeleteHistoryVersionRequest.h"
#import "QCloudSMHDeleteTagRequest.h"
#import "QCloudSMHEditFileOnlineRequest.h"
#import "QCloudSMHFavoriteSpaceFileRequest.h"
#import "QCloudSMHGetFileCountRequest.h"
#import "QCloudSMHGetFileListByTagsRequest.h"
#import "QCloudSMHGetFileTagRequest.h"
#import "QCloudSMHGetHistoryInfoRequest.h"
#import "QCloudSMHGetINodeDetailRequest.h"
#import "QCloudSMHGetPresignedURLRequest.h"
#import "QCloudSMHGetRecentlyUsedFileRequest.h"
#import "QCloudSMHGetRecyclePresignedURLRequest.h"
#import "QCloudSMHGetSpaceHomeFileRequest.h"
#import "QCloudSMHGetTagListRequest.h"
#import "QCloudSMHHeadFileRequest.h"
#import "QCloudSMHInitiateSearchRequest.h"
#import "QCloudSMHListContentsRequest.h"
#import "QCloudSMHListFavoriteSpaceFileRequest.h"
#import "QCloudSMHPutFileTagRequest.h"
#import "QCloudSMHPutHisotryVersionRequest.h"
#import "QCloudSMHPutTagRequest.h"
#import "QCloudSMHRenameFileRequest.h"
#import "QCloudSMHResumeSearchRequest.h"
#import "QCloudSMHSetLatestVersionRequest.h"
#import "QCloudUpdateFileTagRequest.h"
#import "QCloudSMHCheckHostRequest.h"
#import "QCloudSMHBatchDeleteRecycleObjectReqeust.h"
#import "QCloudSMHBatchRestoreRecycleObjectReqeust.h"
#import "QCloudSMHDeleteAllRecycleObjectReqeust.h"
#import "QCloudSMHDeleteRecycleObjectReqeust.h"
#import "QCloudSMHGetRecycleFileDetailReqeust.h"
#import "QCloudSMHGetRecycleObjectListReqeust.h"
#import "QCloudSMHRestoreRecycleObjectReqeust.h"
#import "QCloudGetSpaceUsageRequest.h"
#import "QCloudSetSpaceTrafficLimitRequest.h"
#import "QCloudCOSSMHDownloadObjectRequest.h"
#import "QCloudCOSSMHPutObjectRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"
#import "QCloudCOSSMHUploadPartRequest.h"
#import "QCloudSMHAbortMultipfartUploadRequest.h"
#import "QCloudSMHCompleteUploadRequest.h"
#import "QCloudSMHDownloadFileRequest.h"
#import "QCloudSMHGetAlbumRequest.h"
#import "QCloudSMHGetDownloadInfoRequest.h"
#import "QCloudSMHGetUploadStateRequest.h"
#import "QCloudSMHPutObjectLinkRequest.h"
#import "QCloudSMHPutObjectRenewRequest.h"
#import "QCloudSMHPutObjectRequest.h"
#import "QCloudSMHQuickPutObjectRequest.h"
#import "QCloudSMHUploadPartRequest.h"
#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHBizRequest.h"
#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHBatchTaskStatusEnum.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHCreationWayEnum.h"
#import "QCloudSMHDynamicEnum.h"
#import "QCloudSMHFavoriteTypeEnum.h"
#import "QCloudSMHMessageTypeEnum.h"
#import "QCloudSMHSearchTypeEnum.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHBaseContentInfo.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHContentInfo+Transfer.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHContentListInfo.h"
#import "QCloudSMHDynamicModel.h"
#import "QCloudSMHHighLightInfo.h"
#import "QCloudSMHHistoryVersionInfo.h"
#import "QCloudSMHInitUploadInfo.h"
#import "QCloudSMHListHistoryVersionResult.h"
#import "QCloudSMHRecycleObjectListInfo.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHSearchListInfo.h"
#import "QCloudSMHSpaceInfo.h"
#import "QCloudSMHTaskResult.h"
#import "QCloudSMHTaskResultInfo.h"
#import "QCloudSMHTeamInfo.h"
#import "QCloudSMHUserInfo.h"
#import "QCloudTagModel.h"
#import "QCloudAbstractRequest+Quality.h"
#import "QCloudCOSSMHConfig.h"
#import "QCloudHTTPSessionManager+SMH.h"
#import "QCloudSMHErrorCode.h"
#import "QCloudSMHAccessTokenFenceQueue.h"
#import "QCloudSMHAccessTokenProvider.h"
#import "NSData+SHA256.h"
#import "NSNull+Safe.h"
#import "NSObject+Equal.h"
#import "QCloudCOSSMH.h"
#import "QCloudCOSSMHVersion.h"
#import "QCloudFileAutthorityInfo.h"
#import "QCloudFileShareInfo.h"
#import "QCloudSMHApplyDircetoryDetailInfo.h"
#import "QCloudSMHChechWXAuthResult.h"
#import "QCloudSMHCheckDeregisterResult.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHCheckFavoriteInfo.h"
#import "QCloudSMHCheckFavoriteResultInfo.h"
#import "QCloudSMHCrossSpaceRecycleItem.h"
#import "QCloudSMHFavoriteInfo.h"
#import "QCloudSMHFavoriteResult.h"
#import "QCloudSMHFileExtraInfo.h"
#import "QCloudSMHGroupInfo.h"
#import "QCloudSMHGroupModel.h"
#import "QCloudSMHInviteModel.h"
#import "QCloudSMHListGroupInfo.h"
#import "QCloudSMHListGroupMemberInfo.h"
#import "QCloudSMHMessageInfo.h"
#import "QCloudSMHMessageSetting.h"
#import "QCloudSMHMesssageListResult.h"
#import "QCloudSMHOrganizationDetailInfo.h"
#import "QCloudSMHOrganizationInfo.h"
#import "QCloudSMHOrganizationShareList.h"
#import "QCloudSMHOrganizationsInfo.h"
#import "QCloudSMHRecentlyFileListInfo.h"
#import "QCloudSMHShareUserInfo.h"
#import "QCloudSMHSpacesSizeInfo.h"
#import "QCloudSMHTeamMemberInfo.h"
#import "QCloudSMHTemporaryUserResult.h"
#import "QCloudSMHUserDetailInfo.h"
#import "QCloudSMHVerifyShareCodeResult.h"
#import "QCloudSMHVirusDetectionModel.h"
#import "QCloudSSOListModel.h"
#import "QCloudStoreDetailInfo.h"
#import "QCloudSMHUserService.h"
#import "QCloudSMHBindWXRequest.h"
#import "QCloudSMHCancelLoginQrcodeRequest.h"
#import "QCloudSMHCheckDeregisterRequest.h"
#import "QCloudSMHCheckLoginQrcodeRequest.h"
#import "QCloudSMHCheckOfficalFreeRequest.h"
#import "QCloudSMHCheckWXAuthRequest.h"
#import "QCloudSMHClearMessageRequest.h"
#import "QCloudSMHCompleteUploadAvatarRequest.h"
#import "QCloudSMHDeleteMessageRequest.h"
#import "QCloudSMHDeleteOrgDeregisterRequest.h"
#import "QCloudSMHDeregisterRequest.h"
#import "QCloudSMHGetMessageListRequest.h"
#import "QCloudSMHGetMessageSettingRequest.h"
#import "QCloudSMHGetOrgSpacesRequest.h"
#import "QCloudSMHGetSpacesRequest.h"
#import "QCloudSMHGetSSOListRequest.h"
#import "QCloudSMHGetTemporaryUserRequest.h"
#import "QCloudSMHGetUpdatePhoneCodeRequest.h"
#import "QCloudSMHGetUserInfoRequest.h"
#import "QCloudSMHGetUserListRequest.h"
#import "QCloudSMHGetYufuLoginAddressRequest.h"
#import "QCloudSMHInitUploadAvatarRequest.h"
#import "QCloudSMHLoginOrganizationRequest.h"
#import "QCloudSMHLoginQrcodeRequest.h"
#import "QCloudSMHLogoutRequest.h"
#import "QCloudSMHMarkMessageHasReadRequest.h"
#import "QCloudSMHOffcialFreeLoginRequest.h"
#import "QCloudSMHOffcialFreeRegisterRequest.h"
#import "QCloudSMHSendSMSCodeRequest.h"
#import "QCloudSMHSSOLoginRedirectRequest.h"
#import "QCloudSMHUnbindWXRequest.h"
#import "QCloudSMHUpdateMessageSettingRequest.h"
#import "QCloudSMHUpdatePhoneRequest.h"
#import "QCloudSMHUpdateUserInfoRequest.h"
#import "QCloudSMHUploadPersonalInfoRequest.h"
#import "QCloudSMHVerifyAccountLoginRequest.h"
#import "QCloudSMHVerifyShareCodeRequest.h"
#import "QCloudSMHVerifySMSCodeRequest.h"
#import "QCloudSMHVerifyYufuCodeRequest.h"
#import "QCloudSMHWXLoginRequest.h"
#import "QCloudSMHAgreeApplyDirectoryRequest.h"
#import "QCloudSMHApplyDirectoryAuthorityRequest.h"
#import "QCloudSMHCancelApplyDirectoryRequest.h"
#import "QCloudSMHCheckDirectoryApplyRequest.h"
#import "QCloudSMHDisagreeApplyDirectoryRequest.h"
#import "QCloudSMHGetApplyDirectoryDetailRequest.h"
#import "QCloudSMHGetApplyDirectoryListRequest.h"
#import "QCloudSMHGetApplyDirectoryListTotalInfoRequest.h"
#import "QCloudSMHGetTaskStatusRequest.h"
#import "QCloudSMHRestoreCrossSpaceObjectRequest.h"
#import "QCloudSMHUserBatchBaseRequest.h"
#import "QCloudSMHListSpaceDynamicRequest.h"
#import "QCloudSMHListWorkBenchDynamicRequest.h"
#import "QCloudSMHNextListSpaceDynamicRequest.h"
#import "QCloudCreateFavoriteGroupRequest.h"
#import "QCloudDeleteFavoriteGroupRequest.h"
#import "QCloudGetFavoriteListRequest.h"
#import "QCloudGetFileExtraInfoRequest.h"
#import "QCloudListFavoriteGroupRequest.h"
#import "QCloudSMHBatchDeleteSpaceRecycleObjectReqeust.h"
#import "QCloudSMHBatchGetFileInfoRequest.h"
#import "QCloudSMHBatchMultiSpaceFileInfoRequest.h"
#import "QCloudSMHBatchRestoreSpaceRecycleObjectReqeust.h"
#import "QCloudSMHCheckFavoriteRequest.h"
#import "QCloudSMHDeleteFavoriteRequest.h"
#import "QCloudSMHDeleteFileShareRequest.h"
#import "QCloudSMHDisableFileShareLinkRequest.h"
#import "QCloudSMHFavoriteFileRequest.h"
#import "QCloudSMHFileShareDetailInfoRequest.h"
#import "QCloudSMHFileShareRequest.h"
#import "QCloudSMHFileShareUpdateLinkRequest.h"
#import "QCloudSMHGeFileShareLinkDetailRequest.h"
#import "QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest.h"
#import "QCloudSMHGetAuthorizedToMeDirectoryRequest.h"
#import "QCloudSMHGetFileAuthorityRequest.h"
#import "QCloudSMHGetFileInfoRequest.h"
#import "QCloudSMHGetListFileShareLinkRequest.h"
#import "QCloudSMHGetRecycleItemDetailRequest.h"
#import "QCloudSMHGetRecycleListRequest.h"
#import "QCloudSMHGetStoreCodeDetailRequest.h"
#import "QCloudSMHListHistoryVersionRequest.h"
#import "QCloudSMHRecentlyFileRequest.h"
#import "QCloudSMHRelatedToMeFileRequest.h"
#import "QCloudSMHUserAbortSearchRequest.h"
#import "QCloudSMHUserInitiateSearchRequest.h"
#import "QCloudSMHUserResumeSearchRequest.h"
#import "QCloudUpdateFavoriteGroupRequest.h"
#import "QCloudSMHAbortSearchTeamRequest.h"
#import "QCloudSMHAddMemberToGroupRequest.h"
#import "QCloudSMHBeginSearchTeamRequest.h"
#import "QCloudSMHCreateGroupRequest.h"
#import "QCloudSMHDeleteGroupMemberRequest.h"
#import "QCloudSMHDeleteGroupRequest.h"
#import "QCloudSMHExitGroupRequest.h"
#import "QCloudSMHGetCreateGroupCountRequest.h"
#import "QCloudSMHGetGroupRequest.h"
#import "QCloudSMHListGroupMemberRequest.h"
#import "QCloudSMHListGroupRequest.h"
#import "QCloudSMHNextSearchTeamRequest.h"
#import "QCloudSMHUpdateGroupMemberRoleRequest.h"
#import "QCloudSMHUpdateGroupRequest.h"
#import "QCloudSMHCreateInviteGroupCodeRequest.h"
#import "QCloudSMHCreateInviteOrgCodeRequest.h"
#import "QCloudSMHDeleteInviteRequest.h"
#import "QCloudSMHGetGroupInviteCodeInfoRequest.h"
#import "QCloudSMHGetGroupInviteCodeRequest.h"
#import "QCloudSMHGetOrgInviteCodeInfoRequest.h"
#import "QCloudSMHGetOrgInviteCodeRequest.h"
#import "QCloudSMHJoinGroupRequest.h"
#import "QCloudSMHJoinOrgRequest.h"
#import "QCloudSMHUpdateGroupInviteInfoRequest.h"
#import "QCloudSMHUpdateOrgInviteInfoRequest.h"
#import "QCloudSMHGetOrganizationInfoRequest.h"
#import "QCloudSMHGetOrganizationRequest.h"
#import "QCloudSMHGetOrganizationShareListRequest.h"
#import "QCloudSMHGetOrgRoleListRequest.h"
#import "QCloudSMHGetTeamAllMemberDetailRequest.h"
#import "QCloudSMHGetTeamDetailRequest.h"
#import "QCloudSMHGetTeamMemberDetailRequest.h"
#import "QCloudSMHGetTeamRequest.h"
#import "QCloudSMHSearchTeamDetailRequest.h"
#import "QCloudSMHGetAccessTokenRequest.h"
#import "QCloudSMHGetSpaceAccessTokenRequest.h"
#import "QCloudSMHGetVirusDetectionListRequest.h"
#import "QCloudSMHVirusDetectionRestoreRequest.h"

FOUNDATION_EXPORT double QCloudCOSSMHVersionNumber;
FOUNDATION_EXPORT const unsigned char QCloudCOSSMHVersionString[];

