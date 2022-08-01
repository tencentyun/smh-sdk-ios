//
//  QCloudSMHUserService.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/19.
//

#import "QCloudSMHUserService.h"
#import "QCloudSMHGetSpaceAccessTokenRequest.h"
#import "QCloudSMHFileShareRequest.h"
#import "QCloudSMHGeFileShareLinkDetailRequest.h"
#import "QCloudSMHDeleteFileShareRequest.h"
#import "QCloudSMHLoginOrganizationRequest.h"
#import "QCloudSMHCheckLoginQrcodeRequest.h"
#import "QCloudSMHLoginQrcodeRequest.h"
#import "QCloudSMHVerifyShareCodeRequest.h"
#import "QCloudSMHFileShareDetailInfoRequest.h"
#import "QCloudSMHGetStoreCodeDetailRequest.h"
#import "QCloudSMHCancelLoginQrcodeRequest.h"
#import "QCloudSMHGetOrganizationRequest.h"
#import "QCloudSMHDeregisterRequest.h"

#import "QCloudSMHRecentlyFileRequest.h"
#import "QCloudSMHRelatedToMeFileRequest.h"
#import "QCloudSMHCreateInviteOrgCodeRequest.h"
#import "QCloudSMHCreateInviteGroupCodeRequest.h"
#import "QCloudSMHDeleteInviteRequest.h"
#import "QCloudSMHGetGroupInviteCodeInfoRequest.h"
#import "QCloudSMHGetGroupInviteCodeRequest.h"
#import "QCloudSMHGetOrgInviteCodeInfoRequest.h"
#import "QCloudSMHGetOrgInviteCodeRequest.h"
#import "QCloudSMHJoinGroupRequest.h"
#import "QCloudSMHJoinOrgRequest.h"
#import "QCloudSMHUpdateOrgInviteInfoRequest.h"
#import "QCloudSMHUpdateGroupInviteInfoRequest.h"

#import "QCloudSMHAddMemberToGroupRequest.h"
#import "QCloudSMHCreateGroupRequest.h"
#import "QCloudSMHDeleteGroupMemberRequest.h"
#import "QCloudSMHDeleteGroupRequest.h"
#import "QCloudSMHExitGroupRequest.h"
#import "QCloudSMHGetCreateGroupCountRequest.h"
#import "QCloudSMHGetGroupRequest.h"
#import "QCloudSMHListGroupMemberRequest.h"
#import "QCloudSMHListGroupRequest.h"
#import "QCloudSMHUpdateGroupMemberRoleRequest.h"
#import "QCloudSMHUpdateGroupRequest.h"
#import "QCloudSMHListSpaceDynamicRequest.h"
#import "QCloudSMHNextListSpaceDynamicRequest.h"
#import "QCloudSMHWXLoginRequest.h"
#import "QCloudSMHBindWXRequest.h"
#import "QCloudSMHUnbindWXRequest.h"

#import "QCloudGetFileExtraInfoRequest.h"
#import "QCloudSMHDisableFileShareLinkRequest.h"

#import "QCloudSMHUploadPersonalInfoRequest.h"

#import "QCloudSMHCheckDeregisterRequest.h"
#import "QCloudSMHDeleteOrgDeregisterRequest.h"
#import "QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest.h"
#import "QCloudSMHGetTeamMemberDetailRequest.h"

#import "QCloudSMHBatchDeleteSpaceRecycleObjectReqeust.h"
#import "QCloudSMHBatchRestoreSpaceRecycleObjectReqeust.h"

#import "QCloudSMHGetYufuLoginAddressRequest.h"
#import "QCloudSMHVerifyYufuCodeRequest.h"
#import "QCloudSMHGetTaskStatusRequest.h"

@interface QCloudSMHUserService()
@property (nonatomic,strong)QCloudConfiguration *configuration;
@property (nonatomic, strong, readonly) QCloudOperationQueue *batchQueue;
@end

static QCloudSMHUserService *_service;
@implementation QCloudSMHUserService
+ (QCloudSMHUserService *)defaultSMHUserService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QCloudConfiguration *config = [QCloudConfiguration new
                                       ];
        _service = [[QCloudSMHUserService alloc] init];
        _service.configuration = config;
        
    });
    return _service;
}

- (instancetype)init{
    if(self  = [super init]){
        _batchQueue = [QCloudOperationQueue new];
    }
    return self;
}

-(void)sendSMHCode:(QCloudSMHSendSMSCodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)verifySMSCode:(QCloudSMHVerifySMSCodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];

}
- (void)getOrganizationInfo:(QCloudSMHGetOrganizationInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)exitOrganization:(QCloudSMHDeregisterRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)deleteOrgDeregister:(QCloudSMHDeleteOrgDeregisterRequest*)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)checkDeregister:(QCloudSMHCheckDeregisterRequest*)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)getOrganizationList:(QCloudSMHGetOrganizationRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)getStoreCodeDetail:(QCloudSMHGetStoreCodeDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)getTeamInfo:(QCloudSMHGetSpacesRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getOrgSpaceSizeInfo:(QCloudSMHGetOrgSpacesRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)getTeam:(QCloudSMHGetTeamRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getSpaceAccessToken:(id)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)getAccessToken:(QCloudSMHGetAccessTokenRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
- (void)getFileInfo:(QCloudSMHGetFileInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)batchGetFileInfo:(QCloudSMHBatchGetFileInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)getAuthorizedToMeDirectory:(QCloudSMHGetAuthorizedToMeDirectoryRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}


-(void)getVCodeByUpdatePhone:(QCloudSMHGetUpdatePhoneCodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)updatePhone:(QCloudSMHUpdatePhoneRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)updateUserInfo:(QCloudSMHUpdateUserInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)getUserInfo:(QCloudSMHGetUserInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)logout:(QCloudSMHLogoutRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getTeamDetail:(QCloudSMHGetTeamDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getTeamMemberDetail:(QCloudSMHGetTeamMemberDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getSearchTeamDetail:(QCloudSMHSearchTeamDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)listHisotryVersion:(QCloudSMHListHistoryVersionRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}


-(void)getInitUploadAvater:(QCloudSMHInitUploadAvatarRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)completeUploadAvatar:(QCloudSMHCompleteUploadAvatarRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getFileAuthority:(QCloudSMHGetFileAuthorityRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getFavoriteList:(QCloudGetFavoriteListRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)getRecycleItemDetail:(QCloudSMHGetRecycleItemDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getRecycleList:(QCloudSMHGetRecycleListRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)checkFavoriteState:(QCloudSMHCheckFavoriteRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
- (void)deleteFavoriteFiles:(QCloudSMHDeleteFavoriteRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
- (void)favoriteFile:(QCloudSMHFavoriteFileRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)shareFile:(QCloudSMHFileShareRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)getListShareLink:(QCloudSMHGetListFileShareLinkRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getShareLinkDetail:(QCloudSMHGeFileShareLinkDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)updateShareLink:(QCloudSMHFileShareUpdateLinkRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)deleteShareFileLink:(QCloudSMHDeleteFileShareRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

- (void)loginToOrganization:(QCloudSMHLoginOrganizationRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)checkLoginQrcode:(QCloudSMHCheckLoginQrcodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)cancelLoginQrcode:(QCloudSMHCancelLoginQrcodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)loginQrcode:(QCloudSMHLoginQrcodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)verifyShareCode:(QCloudSMHVerifyShareCodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}

-(void)getShareDetailInfo:(QCloudSMHFileShareDetailInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:request];
}
- (void)getMessageList:(QCloudSMHGetMessageListRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)markMessageHasRead:(QCloudSMHMarkMessageHasReadRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)clearMessage:(QCloudSMHClearMessageRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getRecentlyFiles:(QCloudSMHRecentlyFileRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)putCreateGroup:(QCloudSMHCreateGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

- (void)getRelatedToMeFile:(QCloudSMHRelatedToMeFileRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)createInviteOrgCode:(QCloudSMHCreateInviteOrgCodeRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)createInviteGroupCode:(QCloudSMHCreateInviteGroupCodeRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)deleteInvite:(QCloudSMHDeleteInviteRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)getGroupInviteCodeInfo:(QCloudSMHGetGroupInviteCodeInfoRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)getGroupInviteCode:(QCloudSMHGetGroupInviteCodeRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)getOrgInviteCodeInfo:(QCloudSMHGetOrgInviteCodeInfoRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)getOrgInviteCode:(QCloudSMHGetOrgInviteCodeRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)joinGroup:(QCloudSMHJoinGroupRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)joinOrg:(QCloudSMHJoinOrgRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)updateGroupInviteInfo:(QCloudSMHUpdateGroupInviteInfoRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}
-(void)updateOrgInviteInfo:(QCloudSMHUpdateOrgInviteInfoRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)listFavoriteGroup:(QCloudListFavoriteGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)createFavoriteGroup:(QCloudCreateFavoriteGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)updateFavoriteGroup:(QCloudUpdateFavoriteGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)deleteFavoriteGroup:(QCloudDeleteFavoriteGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)addMemberToGroup:(QCloudSMHAddMemberToGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)deleteGroupMember:(QCloudSMHDeleteGroupMemberRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)deleteGroup:(QCloudSMHDeleteGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)exitGroup:(QCloudSMHExitGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getCreateGroupCount:(QCloudSMHGetCreateGroupCountRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getGroup:(QCloudSMHGetGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)listGroupMember:(QCloudSMHListGroupMemberRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)listGroup:(QCloudSMHListGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)updateGroupMemberRole:(QCloudSMHUpdateGroupMemberRoleRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)updateGroup:(QCloudSMHUpdateGroupRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)listSpaceDynamic:(QCloudSMHListSpaceDynamicRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)nextListSpaceDynamic:(QCloudSMHNextListSpaceDynamicRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)listWorkBenchDynamic:(QCloudSMHListWorkBenchDynamicRequest * )request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)wxLogin:(QCloudSMHWXLoginRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)bindWX:(QCloudSMHBindWXRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)unbindWX:(QCloudSMHUnbindWXRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getFileExtraInfo:(QCloudGetFileExtraInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)disableFileShareLink:(QCloudSMHDisableFileShareLinkRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)uploadPersonalInfo:(QCloudSMHUploadPersonalInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)batchMultiSpaceFileInfo:(QCloudSMHBatchMultiSpaceFileInfoRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)getAuthorizedRelatedToMeDirectory:(QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

- (void)getTeamAllMemberDetail:(QCloudSMHGetTeamAllMemberDetailRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getUserList:(QCloudSMHGetUserListRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)batchRestoreCrossSpaceRecycleObject:(QCloudSMHBatchRestoreSpaceRecycleObjectReqeust *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)batchDeleteCrossSpaceRecycleObject:(QCloudSMHBatchDeleteSpaceRecycleObjectReqeust *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)checkWXAuth:(QCloudSMHCheckWXAuthRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest*)request];
}

-(void)restoreCrossSpaceObject:(QCloudSMHRestoreCrossSpaceObjectRequest *)request{
    QCloudFakeRequestOperation *operation = [[QCloudFakeRequestOperation alloc] initWithRequest:(QCloudAbstractRequest *)request];
    [self.batchQueue addOpreation:operation];
}

-(void)getYufuLoginAddress:(QCloudSMHGetYufuLoginAddressRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)verifyYufuCode:(QCloudSMHVerifyYufuCodeRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

-(void)getTaskStatus:(QCloudSMHGetTaskStatusRequest *)request{
    [[QCloudHTTPSessionManager shareClient] performRequest:(QCloudHTTPRequest *)request];
}

@end
