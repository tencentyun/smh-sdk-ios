//
//  QCloudSMHUserService.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/19.
//

#import "QCloudSMHUserService.h"
#import <QcloudCore/QCloudHTTPSessionManager.h>
#import "QCloudConfiguration.h"

@class QCloudSMHListHistoryVersionRequest;
@class QCloudSMHGetTeamRequest;
@class QCloudSMHGetSpaceAccessTokenRequest;
@class QCloudSMHBizRequest;
@class QCloudSMHBaseRequest;
@class QCloudSMHSendSMSCodeRequest;
@class QCloudSMHVerifySMSCodeRequest;
@class QCloudSMHGetAccessTokenRequest;
@class QCloudSMHGetFileInfoRequest;
@class QCloudSMHGetUpdatePhoneCodeRequest;
@class QCloudSMHUpdatePhoneRequest;

@class QCloudSMHUpdateUserInfoRequest;
@class QCloudSMHGetUserInfoRequest;
@class QCloudSMHGetUserListRequest;
@class QCloudSMHLogoutRequest;
@class QCloudSMHGetTeamMemberDetailRequest;
@class QCloudSMHGetTeamAllMemberDetailRequest;
@class QCloudSMHGetTeamDetailRequest;
@class QCloudSMHSearchTeamDetailRequest;
@class QCloudSMHGetRoleListRequest;
@class QCloudSMHGetAuthorizedToMeDirectoryRequest;
@class QCloudSMHGetOrganizationInfoRequest;
@class QCloudSMHDeregisterRequest;
@class QCloudSMHGetSpacesRequest;
@class QCloudSMHGetOrgSpacesRequest;
@class QCloudSMHInitUploadAvatarRequest;
@class QCloudSMHCompleteUploadAvatarRequest;
@class QCloudSMHGetFileAuthorityRequest;
@class QCloudGetFavoriteListRequest;
@class QCloudCreateFavoriteGroupRequest;
@class QCloudUpdateFavoriteGroupRequest;
@class QCloudDeleteFavoriteGroupRequest;
@class QCloudListFavoriteGroupRequest;
@class QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest;
@class QCloudSMHCheckFavoriteRequest;
@class QCloudSMHFavoriteFileRequest;
@class QCloudSMHDeleteFavoriteRequest;
@class QCloudSMHFileShareRequest;
@class QCloudSMHGetListFileShareLinkRequest;
@class QCloudSMHFileShareUpdateLinkRequest;
@class QCloudSMHGeFileShareLinkDetailRequest;
@class QCloudSMHFileShareUpdateLinkRequest;
@class QCloudSMHDeleteFileShareRequest;
@class QCloudSMHGetRecycleItemDetailRequest;
@class QCloudSMHGetRecycleListRequest;
@class QCloudSMHLoginOrganizationRequest;

@class QCloudSMHCheckLoginQrcodeRequest;
@class QCloudSMHLoginQrcodeRequest;
@class QCloudSMHVerifyShareCodeRequest;
@class QCloudSMHFileShareDetailInfoRequest;
@class QCloudSMHGetStoreCodeDetailRequest;
@class QCloudSMHBatchGetFileInfoRequest;
@class QCloudSMHCancelLoginQrcodeRequest;
@class QCloudSMHGetMessageListRequest;
@class QCloudSMHMarkMessageHasReadRequest;
@class QCloudSMHClearMessageRequest;
@class QCloudSMHGetOrganizationRequest;

@class QCloudSMHRecentlyFileRequest;
@class QCloudSMHRelatedToMeFileRequest;
// 邀请模块

@class QCloudSMHCreateInviteOrgCodeRequest;
@class QCloudSMHCreateInviteGroupCodeRequest;
@class QCloudSMHDeleteInviteRequest;
@class QCloudSMHGetGroupInviteCodeInfoRequest;
@class QCloudSMHGetGroupInviteCodeRequest;
@class QCloudSMHGetOrgInviteCodeInfoRequest;
@class QCloudSMHGetOrgInviteCodeRequest;
@class QCloudSMHJoinGroupRequest;
@class QCloudSMHJoinOrgRequest;
@class QCloudSMHUpdateGroupInviteInfoRequest;
@class QCloudSMHUpdateOrgInviteInfoRequest;

// 群组模块
@class QCloudSMHAddMemberToGroupRequest;
@class QCloudSMHCreateGroupRequest;
@class QCloudSMHDeleteGroupMemberRequest;
@class QCloudSMHDeleteGroupRequest;
@class QCloudSMHExitGroupRequest;
@class QCloudSMHGetCreateGroupCountRequest;
@class QCloudSMHGetGroupRequest;
@class QCloudSMHListGroupMemberRequest;
@class QCloudSMHListGroupRequest;
@class QCloudSMHUpdateGroupMemberRoleRequest;
@class QCloudSMHUpdateGroupRequest;

// 动态模块
@class QCloudSMHListSpaceDynamicRequest;
@class QCloudSMHNextListSpaceDynamicRequest;
@class QCloudSMHListWorkBenchDynamicRequest;

// 微信登录模块
@class QCloudSMHWXLoginRequest;
@class QCloudSMHBindWXRequest;
@class QCloudSMHUnbindWXRequest;
@class QCloudSMHCheckWXAuthRequest;

@class QCloudGetFileExtraInfoRequest;
@class QCloudSMHDisableFileShareLinkRequest;

@class QCloudSMHUploadPersonalInfoRequest;

@class QCloudSMHBatchMultiSpaceFileInfoRequest;

@class QCloudSMHCheckDeregisterRequest;
@class QCloudSMHDeleteOrgDeregisterRequest;


@class QCloudSMHBatchDeleteSpaceRecycleObjectReqeust;
@class QCloudSMHBatchRestoreSpaceRecycleObjectReqeust;
@class QCloudSMHRestoreCrossSpaceObjectRequest;

@class QCloudSMHGetYufuLoginAddressRequest;
@class QCloudSMHVerifyYufuCodeRequest;
@class QCloudSMHGetTaskStatusRequest;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHUserService : NSObject
#pragma Factory
@property (nonatomic,strong,readonly)QCloudConfiguration *configuration;


/// 当前服务所运行的HTTP Session Manager。一般情况下，所有服务都运行在统一的全局单例上面。
@property (nonatomic, strong, readonly) QCloudHTTPSessionManager *sessionManager;

+ (QCloudSMHUserService *)defaultSMHUserService;


/// 发送短信验证
- (void)sendSMHCode:(QCloudSMHSendSMSCodeRequest *)request;

/// 登录成功之后获取：userToken organizations等信息
- (void)verifySMSCode:(QCloudSMHVerifySMSCodeRequest *)request;

/// 获取：accessTokens信息
- (void)getAccessToken:(QCloudSMHGetAccessTokenRequest *)request;

/// 登出
-(void)logout:(QCloudSMHLogoutRequest *)request;

///  查询团队
-(void)getTeam:(QCloudSMHGetTeamRequest *)request;

/// 获取指定空间accesstoken；
- (void)getSpaceAccessToken:(QCloudSMHGetSpaceAccessTokenRequest *)request;

/// 更换手机号 发送验证码
-(void)getVCodeByUpdatePhone:(QCloudSMHGetUpdatePhoneCodeRequest *)request;

/// 更换手机号
-(void)updatePhone:(QCloudSMHUpdatePhoneRequest *)request;

/// 更新用户信息
-(void)updateUserInfo:(QCloudSMHUpdateUserInfoRequest *)request;

/// 获取用户信息
-(void)getUserInfo:(QCloudSMHGetUserInfoRequest *)request;

/// 获取当前组织信息
- (void)getOrganizationInfo:(QCloudSMHGetOrganizationInfoRequest *)request;

/// 退出组织
- (void)exitOrganization:(QCloudSMHDeregisterRequest *)request;

/// 列出当前登录用户所属组织
- (void)getOrganizationList:(QCloudSMHGetOrganizationRequest *)request;

///  列出个人空间
- (void)getTeamInfo:(QCloudSMHGetSpacesRequest *)request;

/// 查询组织空间总使用量
- (void)getOrgSpaceSizeInfo:(QCloudSMHGetOrgSpacesRequest *)request;

/// 获取成员&搜索成员
- (void)getTeamMemberDetail:(QCloudSMHGetTeamMemberDetailRequest *)request;

/// 获取团队
- (void)getTeamDetail:(QCloudSMHGetTeamDetailRequest *)request;

/// 搜索团队
- (void)getSearchTeamDetail:(QCloudSMHSearchTeamDetailRequest *)request;

/// 获取共享给我的文件夹
- (void)getAuthorizedToMeDirectory:(QCloudSMHGetAuthorizedToMeDirectoryRequest *)request;

/// 确认上传头像
-(void)completeUploadAvatar:(QCloudSMHCompleteUploadAvatarRequest *)request;

///  获取头像简单上传文件参数
-(void)getInitUploadAvater:(QCloudSMHInitUploadAvatarRequest *)request;

/// 查看文件共享权限列表
- (void)getFileAuthority:(QCloudSMHGetFileAuthorityRequest *)request;

/// 获取收藏列表
- (void)getFavoriteList:(QCloudGetFavoriteListRequest *)request;

/// 创建收藏夹
- (void)createFavoriteGroup:(QCloudCreateFavoriteGroupRequest *)request;

/// 更新收藏夹
- (void)updateFavoriteGroup:(QCloudUpdateFavoriteGroupRequest *)request;

/// 删除收藏夹
- (void)deleteFavoriteGroup:(QCloudDeleteFavoriteGroupRequest *)request;

/// 列出收藏夹
- (void)listFavoriteGroup:(QCloudListFavoriteGroupRequest *)request;

/// 删除收藏的文件
- (void)deleteFavoriteFiles:(QCloudSMHDeleteFavoriteRequest *)request;

/// 收藏文件
- (void)favoriteFile:(QCloudSMHFavoriteFileRequest *)request;

/// 查看历史版本列表
- (void)listHisotryVersion:(QCloudSMHListHistoryVersionRequest *)request;

/// 分享文件
- (void)shareFile:(QCloudSMHFileShareRequest *)request;

/// 获取我的分享列表
- (void)getListShareLink:(QCloudSMHGetListFileShareLinkRequest *)request;

/// 修改分享链接
- (void)updateShareLink:(QCloudSMHFileShareUpdateLinkRequest *)request;

/// 获取分享链接详情
- (void)getShareLinkDetail:(QCloudSMHGeFileShareLinkDetailRequest *)request;

/// 查看文件目录收藏状态
- (void)checkFavoriteState:(QCloudSMHCheckFavoriteRequest *)request;

/// 删除分享链接
- (void)deleteShareFileLink:(QCloudSMHDeleteFileShareRequest *)request;

/// 获取回收站目录详情
- (void)getRecycleItemDetail:(QCloudSMHGetRecycleItemDetailRequest *)request;

/// 列出误删恢复回收站项目
- (void)getRecycleList:(QCloudSMHGetRecycleListRequest *)request;

/// 登录进指定组织
- (void)loginToOrganization:(QCloudSMHLoginOrganizationRequest *)request;

/// 二维码验证
-(void)checkLoginQrcode:(QCloudSMHCheckLoginQrcodeRequest *)request;

/// 取消二维码扫码登录
-(void)cancelLoginQrcode:(QCloudSMHCancelLoginQrcodeRequest *)request;

///  二维码确认登录
-(void)loginQrcode:(QCloudSMHLoginQrcodeRequest *)request;

/// 验证提取码
-(void)verifyShareCode:(QCloudSMHVerifyShareCodeRequest *)request;

/// 获取分享链接信息（打开分享 url 时查询）
-(void)getShareDetailInfo:(QCloudSMHFileShareDetailInfoRequest *)request;

/// 查询 Code
- (void)getStoreCodeDetail:(QCloudSMHGetStoreCodeDetailRequest *)request;

/// 我的消息列表
- (void)getMessageList:(QCloudSMHGetMessageListRequest *)request;

/// 批量标记已读
- (void)markMessageHasRead:(QCloudSMHMarkMessageHasReadRequest *)request;

/// 删除所有消息
- (void)clearMessage:(QCloudSMHClearMessageRequest *)request;

/// 获取最近文件列表
- (void)getRecentlyFiles:(QCloudSMHRecentlyFileRequest *)request;

/// 创建群组
- (void)putCreateGroup:(QCloudSMHCreateGroupRequest *)request;

/// 获取与我相关的文件列表
- (void)getRelatedToMeFile:(QCloudSMHRelatedToMeFileRequest *)request;

///  生成加入企业邀请码
-(void)createInviteOrgCode:(QCloudSMHCreateInviteOrgCodeRequest * )request;

/// 生成加入群组邀请码
-(void)createInviteGroupCode:(QCloudSMHCreateInviteGroupCodeRequest * )request;

/// 删除邀请
-(void)deleteInvite:(QCloudSMHDeleteInviteRequest * )request;

/// 查询加入群组邀请码信息
-(void)getGroupInviteCodeInfo:(QCloudSMHGetGroupInviteCodeInfoRequest * )request;

/// 查询群组邀请码
-(void)getGroupInviteCode:(QCloudSMHGetGroupInviteCodeRequest * )request;

/// 查询加入企业邀请码信息
-(void)getOrgInviteCodeInfo:(QCloudSMHGetOrgInviteCodeInfoRequest * )request;

/// 查询加入企业邀请码
-(void)getOrgInviteCode:(QCloudSMHGetOrgInviteCodeRequest * )request;

/// 接受加入群组邀请
-(void)joinGroup:(QCloudSMHJoinGroupRequest * )request;

/// 接受加入企业邀请
-(void)joinOrg:(QCloudSMHJoinOrgRequest * )request;

/// 更新群组邀请信息
-(void)updateGroupInviteInfo:(QCloudSMHUpdateGroupInviteInfoRequest * )request;

/// 更新企业邀请信息
-(void)updateOrgInviteInfo:(QCloudSMHUpdateOrgInviteInfoRequest * )request;

/// 添加群组成员
-(void)addMemberToGroup:(QCloudSMHAddMemberToGroupRequest * )request;

/// 删除群组成员
-(void)deleteGroupMember:(QCloudSMHDeleteGroupMemberRequest * )request;

/// 删除群组(群主)
-(void)deleteGroup:(QCloudSMHDeleteGroupRequest * )request;

/// 退出群组（非群主）
-(void)exitGroup:(QCloudSMHExitGroupRequest * )request;

/// 查询用户创建的群组数量
-(void)getCreateGroupCount:(QCloudSMHGetCreateGroupCountRequest * )request;

/// 查询群组
-(void)getGroup:(QCloudSMHGetGroupRequest * )request;

/// 查询群组成员
-(void)listGroupMember:(QCloudSMHListGroupMemberRequest * )request;

/// 列出用户所在群组
-(void)listGroup:(QCloudSMHListGroupRequest * )request;

/// 修改群组成员角色/权限
-(void)updateGroupMemberRole:(QCloudSMHUpdateGroupMemberRoleRequest * )request;

/// 更新群组信息
-(void)updateGroup:(QCloudSMHUpdateGroupRequest * )request;

/// 查看空间动态
-(void)listSpaceDynamic:(QCloudSMHListSpaceDynamicRequest * )request;

/// 继续获取空间或文件夹动态
-(void)nextListSpaceDynamic:(QCloudSMHNextListSpaceDynamicRequest * )request;

/// 查看工作台动态
-(void)listWorkBenchDynamic:(QCloudSMHListWorkBenchDynamicRequest * )request;

/// 用于检查微信授权是否有效
-(void)checkWXAuth:(QCloudSMHCheckWXAuthRequest *)request;

/// 根据微信授权 code 获取用户登录信息。
-(void)wxLogin:(QCloudSMHWXLoginRequest *)request;

/// 用于云盘用户绑定微信账号。
-(void)bindWX:(QCloudSMHBindWXRequest *)request;

/// 用于云盘用户解除绑定微信账号
-(void)unbindWX:(QCloudSMHUnbindWXRequest *)request;

/// 查看文件目录额外信息
-(void)getFileExtraInfo:(QCloudGetFileExtraInfoRequest *)request;

///  禁用分享链接
-(void)disableFileShareLink:(QCloudSMHDisableFileShareLinkRequest *)request;

/// 上报个人信息
-(void)uploadPersonalInfo:(QCloudSMHUploadPersonalInfoRequest *)request;

/// 获取文件目录详情
- (void)getFileInfo:(QCloudSMHGetFileInfoRequest *)request;

/// 批量获取文件详情（同一空间）
- (void)batchGetFileInfo:(QCloudSMHBatchGetFileInfoRequest *)request;

/// 批量获取文件详情（可跨空间）
- (void)batchMultiSpaceFileInfo:(QCloudSMHBatchMultiSpaceFileInfoRequest *)request;

/// 企业版驳回成员注销操作
-(void)deleteOrgDeregister:(QCloudSMHDeleteOrgDeregisterRequest*)request;

/// 检查是否可以注销账号
-(void)checkDeregister:(QCloudSMHCheckDeregisterRequest*)request;

/// 获取与我相关的共享文件列表
- (void)getAuthorizedRelatedToMeDirectory:(QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest *)request;

/// 查询该团队及其所有子级团队的成员
- (void)getTeamAllMemberDetail:(QCloudSMHGetTeamAllMemberDetailRequest *)request;

/// 查询用户列表
-(void)getUserList:(QCloudSMHGetUserListRequest *)request;

/// 恢复指定回收站项目（批量）跨空间
-(void)batchRestoreCrossSpaceRecycleObject:(QCloudSMHBatchRestoreSpaceRecycleObjectReqeust *)request;

///  永久删除指定回收站项目（批量）跨空间
-(void)batchDeleteCrossSpaceRecycleObject:(QCloudSMHBatchDeleteSpaceRecycleObjectReqeust *)request;

/// 对于QCloudSMHBatchRestoreSpaceRecycleObjectReqeust的封装，在返回204时进行轮询直到任务完成 回调finishblock
-(void)restoreCrossSpaceObject:(QCloudSMHRestoreCrossSpaceObjectRequest *)request;

/// 根据玉符租户 ID，获取单点登录云盘地址。
-(void)getYufuLoginAddress:(QCloudSMHGetYufuLoginAddressRequest *)request;

/// 根据玉符授权 code 获取用户登录信息。
-(void)verifyYufuCode:(QCloudSMHVerifyYufuCodeRequest *)request;


/// 查询任务状态
-(void)getTaskStatus:(QCloudSMHGetTaskStatusRequest *)request;
@end

NS_ASSUME_NONNULL_END
