//
//  QCloudSMHErrorCode.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/10.
//

#import <Foundation/Foundation.h>


typedef NSString * QCloudSMHErrorCode;


/// 错误请求
extern QCloudSMHErrorCode const KBadRequest;

/// 媒体库ID或密钥为空
extern QCloudSMHErrorCode const KEmptyLibraryIdOrSecret;

/// 用户ID长度超出限制
extern QCloudSMHErrorCode const KUserIdLengthExceed;

/// 客户端ID长度超出限制
extern QCloudSMHErrorCode const KClientIdLengthExceed;

/// 媒体库密钥为空
extern QCloudSMHErrorCode const KEmptyLibrarySecret;

/// 媒体库ID为空
extern QCloudSMHErrorCode const KEmptyLibraryId;

/// 该媒体库非多租户模式
extern QCloudSMHErrorCode const KNotMultiSpaceLibrary;

/// 访问令牌为空
extern QCloudSMHErrorCode const KEmptyAccessToken;

/// 文件已被删除或移动至其他位置
extern QCloudSMHErrorCode const KEmptyPath;

/// 目录名长度超出限制，请修改
extern QCloudSMHErrorCode const KDirectoryNameLengthExceed;

/// 目录名称不合法，请修改
extern QCloudSMHErrorCode const KDirectoryNotAllowed;

/// 仅允许存在一级目录，请联系管理员修改
extern QCloudSMHErrorCode const KDirectoryLevelExceed;

/// 文件名称为空，请重新设置
extern QCloudSMHErrorCode const KEmptyFileName;

/// 文件名称长度超过限制，请修改
extern QCloudSMHErrorCode const KFileNameLengthExceed;

/// 本目录不支持此类型文件
extern QCloudSMHErrorCode const KExtnameNotAllowed;

/// 不支持上传文件至根目录，请联系管理员修改
extern QCloudSMHErrorCode const KUploadToRootDirectoryNotAllowed;

/// 源目录无效
extern QCloudSMHErrorCode const KInvalidSourceDirectory;

/// 目标路径为源文件夹的子文件夹，请重新选择
extern QCloudSMHErrorCode const KSourceDirectoryIsParentOfDestination;

/// 源文件无效
extern QCloudSMHErrorCode const KInvalidSourceFile;

/// 源路径无效
extern QCloudSMHErrorCode const KInvalidSourcePath;

/// 该文件为无效文件，请检查后重新上传
extern QCloudSMHErrorCode const KInvalidTargetFile;

/// 目标路径无效
extern QCloudSMHErrorCode const KInvalidDestinationPath;

/// 目标文件类型与源文件不匹配
extern QCloudSMHErrorCode const KFileTypeNotMatched;

/// 文件分段上传未完成
extern QCloudSMHErrorCode const KMultipartUploadIncomplete;

/// 可用存储额度不足
extern QCloudSMHErrorCode const KQuotaLimitReached;

/// 可用存储额度不足
extern QCloudSMHErrorCode const KLibraryQuotaLimitReached;

/// 本操作需要更多存储空间，请联系管理员
extern QCloudSMHErrorCode const KQuotaCapacityRequired;

/// 存储额度无效
extern QCloudSMHErrorCode const KQuotaCapacityInvalid;

/// 多租户空间需要分配空间额度
extern QCloudSMHErrorCode const KQuotaSpacesRequired;

/// 参数无效
extern QCloudSMHErrorCode const KParamInvalid;

/// 回收站未开启
extern QCloudSMHErrorCode const KRecycleBinNotEnabled;

/// 指定的冲突解决策略无效或不受支持
extern QCloudSMHErrorCode const KInvalidConflictResolutionStrategy;

/// 排序字段无效
extern QCloudSMHErrorCode const KOrderByNotAllowed;

/// 排序方式无效
extern QCloudSMHErrorCode const KOrderByTypeNotAllowed;

/// 最新版本不能够被删除
extern QCloudSMHErrorCode const KDirectoryHistoryNotBeDeleted;

/// 搜索功能未开启
extern QCloudSMHErrorCode const KSearchNotEnabled;

/// 获取文件失败
extern QCloudSMHErrorCode const KBadCrc64;

/// 暂不支持该文件类型
extern QCloudSMHErrorCode const KDocumentTypeNotSupport;

/// 该模板名称无效
extern QCloudSMHErrorCode const KInvalidTemplateName;

/// 未开启个人空间
extern QCloudSMHErrorCode const KPersonalSpaceNotAllowed;

/// 未找到历史版本
extern QCloudSMHErrorCode const KDirectoryHistoryNotFound;

/// 批量导入用户表格表头信息不完整，请参考导入模板填写
extern QCloudSMHErrorCode const KInvalidBatchAllowlistInfo;

/// 团队空间文件不可移交至其子团队空间
extern QCloudSMHErrorCode const KChildTeamAsDestinationTeam;

/// 二维码与当前登录企业不匹配，请使用该域名绑定的企业云盘APP扫码
extern QCloudSMHErrorCode const KQrCodeOrganizationNotMatch;

/// 当前域名未关联企业
extern QCloudSMHErrorCode const KNoOrganizationOfSpecifiedDomain;

/// 权限角色不存在
extern QCloudSMHErrorCode const KInvalidAuthorityRoleId;

/// 企微配置测试失败，请检查后重新填写
extern QCloudSMHErrorCode const KInvalidWeworkParams;

/// 二维码无效或已过期，请刷新后重试
extern QCloudSMHErrorCode const KInvalidWeworkAuthCode;

/// 企业ID参数无效，请检查后重新填写
extern QCloudSMHErrorCode const KInvalidWeworkCorpid;

/// Secret参数无效，请检查后重新填写
extern QCloudSMHErrorCode const KInvalidWeworkCredential;

/// AgentId参数错误，请检查后重新填写
extern QCloudSMHErrorCode const KInvalidWeworkAgentId;

/// 在线编辑文档不能超过 4M
extern QCloudSMHErrorCode const KEditFileSizeExceed;

/// 用户license数达购买上限，若需新建用户请扩容
extern QCloudSMHErrorCode const KUserLimitReached;

/// 权限设置失败，不支持对自己授权
extern QCloudSMHErrorCode const KAuthorizeMyselfNotAllowed;

/// 企微应用回调 URL 配置错误
extern QCloudSMHErrorCode const KInvalidWeworkRedirectUrl;

/// 该任务不可被删除
extern QCloudSMHErrorCode const KTaskNotDeletable;

/// 不支持对企业根目录执行该操作
extern QCloudSMHErrorCode const KRootDirectoryNotAllowed;

/// 企业剩余可用流量额度不足
extern QCloudSMHErrorCode const KNoEnoughRemainingTrafficQuota;

/// 同步任务 ID 不存在
extern QCloudSMHErrorCode const KDirectorySyncIdInvalid;

/// 同步盘已被锁定
extern QCloudSMHErrorCode const KSyncFolderLocked;

/// 文件因存储空间不足被删除
extern QCloudSMHErrorCode const KFileRemovedByQuota;

/// 处理超时，请稍后再试
extern QCloudSMHErrorCode const KProcessTimeout;

/// 所选用户空间额度不足，请重新选择
extern QCloudSMHErrorCode const KDestUserSpaceQuotaLimited;

/// 下载或预览次数限制只支持单文件分享
extern QCloudSMHErrorCode const KShareDownloadOrPreviewCountLimitOnlyAllowedSingleFile;

/// 图形验证码无效
extern QCloudSMHErrorCode const KInvalidGraphicCaptcha;

/// 参数重复
extern QCloudSMHErrorCode const KDuplicatePropertyInParams;

/// 群组管理员不允许退出群组
extern QCloudSMHErrorCode const KGroupOwnerCanNotExit;

/// 群组名称不合法，请重新填写
extern QCloudSMHErrorCode const KInvalidGroupName;

/// 群组用户授权信息错误
extern QCloudSMHErrorCode const KInvalidGroupUserAuthRoleId;

/// 分块上传
extern QCloudSMHErrorCode const KMultipartUploadPartTooSmall;

/// 搜索参数无效，请重新输入
extern QCloudSMHErrorCode const KSearchIdInvalid;

/// 文件(夹)名称不合规，请重新输入
extern QCloudSMHErrorCode const KDirectoryNameNotAvailable;

/// 群主个人空间不存在
extern QCloudSMHErrorCode const KGroupOwnerSpaceNotFound;

/// 当前账号未加入任何团队，请前往官网购买
extern QCloudSMHErrorCode const KOrganizationNotRegistered;

/// 文件内容不合规，不支持进行该操作
extern QCloudSMHErrorCode const KFileContentNotAvailable;

/// 文件正在审核中，请稍后再试
extern QCloudSMHErrorCode const KFileContentIsLoading;

/// 超级管理员不允许注销，请转交管理员身份后进行操作
extern QCloudSMHErrorCode const KDeregisterNotAllowedForSuperAdmin;

/// 获取微信用户信息失败
extern QCloudSMHErrorCode const KGetWechatUserInfoFailed;

/// 玉符参数校验失败，请检查后重新填写
extern QCloudSMHErrorCode const KInvalidYufuParams;

/// 访问令牌无效/过期/不匹配
extern QCloudSMHErrorCode const KInvalidAccessToken;

/// 访问令牌不匹配
extern QCloudSMHErrorCode const KAccessTokenNotMatchSpace;

/// 无权限
extern QCloudSMHErrorCode const KNoPermission;

/// 企业已关闭分享功能，请联系管理员开启
extern QCloudSMHErrorCode const KOrganizationNotEnableShare;

/// 服务已到期，续期后方可继续使用
extern QCloudSMHErrorCode const KLibraryServiceTimeExpired;

/// 服务已到期，续期后方可继续使用
extern QCloudSMHErrorCode const KOrganizationServiceTimeExpired;

/// 腾讯会议授权失败
extern QCloudSMHErrorCode const KMeetingOauthFailed;

/// 创建腾讯会议失败
extern QCloudSMHErrorCode const KCreateMeetingFailed;

/// 指定组织中未找到该手机号
extern QCloudSMHErrorCode const KPhoneNumberNotInSpecifiedOrganization;

/// 无法操作其它用户发起的任务
extern QCloudSMHErrorCode const KNoPermissionToOtherUserTask;

/// 未绑定 CoFile企业云盘账号，请进行绑定
extern QCloudSMHErrorCode const KUserNotBindPhoneNumber;

/// 文件预览次数已达上限
extern QCloudSMHErrorCode const KFilePreviewCountLimitReached;

/// 文件下载次数已达上限
extern QCloudSMHErrorCode const KFileDownloadCountLimitReached;

/// 会中分享不允许选择文件夹
extern QCloudSMHErrorCode const KDirectoryNotAllowedForSingleFileShare;

/// 协作群组数量达到上限，升级套餐可解锁更多群组
extern QCloudSMHErrorCode const KShareGroupLimit;

/// 协作群组成员达到上限，升级套餐可解锁更大群组
extern QCloudSMHErrorCode const KShareGroupUserCountLimit;

/// 该用户不在群组中
extern QCloudSMHErrorCode const KUserNotInGroup;

/// 企业创建外链数量达到上限，升级套餐解锁更多
extern QCloudSMHErrorCode const KOrganizationShareLinkLimitReached;

/// 此套餐暂不支持团队管理员
extern QCloudSMHErrorCode const KOrganizationTeamAdminNotAllowed;

/// 此套餐暂不支持获取共享群组动态
extern QCloudSMHErrorCode const KGetShareGroupDynamicNotAllowed;

/// 海外手机号暂不支持
extern QCloudSMHErrorCode const KOverseasPhoneNumberNotAllowed;

/// 此套餐暂不支持分享管理
extern QCloudSMHErrorCode const KShareManageNotAllowed;

/// 此套餐暂不支持水印管理
extern QCloudSMHErrorCode const KWatermarkManageNotAllowed;

/// 此套餐暂不支持离职转接
extern QCloudSMHErrorCode const KResignationTransferNotAllowed;

/// 此套餐暂不支持企业微信同步
extern QCloudSMHErrorCode const KWechatIntegrationNotAllowed;

/// 此套餐暂不支持日志
extern QCloudSMHErrorCode const KLogManageNotAllowed;

/// 此套餐暂不支持统计数据
extern QCloudSMHErrorCode const KStatsReportNotAllowed;

/// 此套餐暂不支持同步盘
extern QCloudSMHErrorCode const KDirectoryLocalSyncNotAllowed;

/// 此套餐暂不支持历史版本
extern QCloudSMHErrorCode const KDirectoryHistoryNotAllowed;

/// 文件历史版本达到上限，升级套餐解锁更多
extern QCloudSMHErrorCode const KDirectoryHistoryCountLimitReached;

/// 不支持在线编辑文档
extern QCloudSMHErrorCode const KOnlineEditNotAllowed;

/// 已超过可恢复时间，无法恢复
extern QCloudSMHErrorCode const KRecoveryTimeExceeded;

/// 不支持团队空间
extern QCloudSMHErrorCode const KCreateTeamSpaceNotAllowed;

/// 企业初始化中，请耐心等待
extern QCloudSMHErrorCode const KLibraryInitializing;

/// 该手机号码已绑定其他微信账号
extern QCloudSMHErrorCode const KDuplicateBindPhoneNumber;

/// 该微信账号已绑定其他手机号码
extern QCloudSMHErrorCode const KDuplicateBindWechat;

/// 该腾讯会议账号已绑定其他手机号码
extern QCloudSMHErrorCode const KMeetingOauthDuplicateBindPhoneNumber;

/// 绑定手机号码失败
extern QCloudSMHErrorCode const KUserBindPhoneNumberFailed;

/// 微信授权失败
extern QCloudSMHErrorCode const KWechatOauthFailed;

/// 媒体库未注册
extern QCloudSMHErrorCode const KLibraryNotRegistered;

/// 玉符授权认证失败
extern QCloudSMHErrorCode const KYufuOauthFailed;

/// 获取玉符用户信息失败
extern QCloudSMHErrorCode const KGetYufuUserInfoFailed;

/// 获取 wellknown 信息失败，请检查后重新填写
extern QCloudSMHErrorCode const KGetYufuWellknownFailed;

/// 当前玉符账号已绑定手机号码，无需再次绑定
extern QCloudSMHErrorCode const KDuplicateBindYufu;

/// 当前手机号码已绑定其他玉符账号，请更换手机号进行绑定
extern QCloudSMHErrorCode const KYufuOauthDuplicateBindPhoneNumber;

/// 媒体库不存在
extern QCloudSMHErrorCode const KLibraryNotFound;

/// 租户空间不存在
extern QCloudSMHErrorCode const KSpaceNotFound;

/// 媒体库ID或密钥错误
extern QCloudSMHErrorCode const KWrongLibraryIdOrSecret;

/// 文件夹不存在
extern QCloudSMHErrorCode const KDirectoryNotFound;

/// 未找到上传文件或不支持访问
extern QCloudSMHErrorCode const KUploadNotFound;

/// 该文件并非分段上传文件
extern QCloudSMHErrorCode const KNotMultipartUpload;

/// 上传未完成
extern QCloudSMHErrorCode const KUploadIncomplete;

/// 文件不存在
extern QCloudSMHErrorCode const KFileNotFound;

/// 路径不存在
extern QCloudSMHErrorCode const KPathNotFound;

/// 该角色不存在？
extern QCloudSMHErrorCode const KRoleNotFound;

/// 源文件夹不存在或被移动至其他位置
extern QCloudSMHErrorCode const KSourceDirectoryNotFound;

/// 源文件不存在或被移动至其他位置
extern QCloudSMHErrorCode const KSourceFileNotFound;

/// 源路径不存在
extern QCloudSMHErrorCode const KSourcePathNotFound;

/// 存储额度不足
extern QCloudSMHErrorCode const KNoQuota;

/// 回收站中未查询到该文件（夹）
extern QCloudSMHErrorCode const KRecycledItemNotFound;

/// 搜索id无效
extern QCloudSMHErrorCode const KSearchIdNotFound;

/// 未找到对应收藏夹
extern QCloudSMHErrorCode const KFavoriteGroupNotFound;

/// 缓存已清空，获取数据失败
extern QCloudSMHErrorCode const KStoreDataNotFound;

/// 该企业未开启企微登录功能，请联系管理员
extern QCloudSMHErrorCode const KnoOrganizationWeworkIntegration;

/// 文件（夹）已被删除
extern QCloudSMHErrorCode const KShareDirectoryNotFound;

/// 未在企微中查询到该用户
extern QCloudSMHErrorCode const KWeworkUserIdNotFound;

/// 图形验证码未上传
extern QCloudSMHErrorCode const KGraphicCaptchaNotFound;

/// 未创建群组邀请码
extern QCloudSMHErrorCode const KGroupInvitationNotCreated;

/// 未创建企业邀请码
extern QCloudSMHErrorCode const KOrgInvitationNotCreated;

/// 未找到订单信息
extern QCloudSMHErrorCode const KNoPurchaseRecord;

/// 邀请无效
extern QCloudSMHErrorCode const KInvitationNotExist;

/// 群组不存在
extern QCloudSMHErrorCode const KGroupNotFound;

/// 邀请码无效或已过期，请联系分享人重新获取
extern QCloudSMHErrorCode const KInvitationCodeInvalidOrExpired;

/// 该邀请群组已被删除
extern QCloudSMHErrorCode const KInvitationGroupNotFound;

/// 该邀请企业已被删除
extern QCloudSMHErrorCode const KInvitationOrganizationNotFound;

/// 无法找到新手引导数据
extern QCloudSMHErrorCode const KNoviceGuidanceNotFound;

/// 玉符用户 openId 同步失败
extern QCloudSMHErrorCode const KYufuUserIdNotFound;

/// 云盘后台未找到玉符配置
extern QCloudSMHErrorCode const KYufuConfigNotFound;

/// 处理请求时出错
extern QCloudSMHErrorCode const KInternalServerError;

/// 搜索超时
extern QCloudSMHErrorCode const KSearchTimeout;

/// 企微父级团队同步失败
extern QCloudSMHErrorCode const KWeworkParentTeamSyncFail;

/// 企微同步超过频率限制（企微接口的限制，一般不会遇到）
extern QCloudSMHErrorCode const KWeworkFreqLimit;

/// 获取企微团队成员失败
extern QCloudSMHErrorCode const KGetWeworkTeamMemberFailed;

/// 同步玉符通讯录时，父团队同步失败
extern QCloudSMHErrorCode const KYufuParentTeamSyncFail;

/// 同步玉符通讯录时，成员获取失败
extern QCloudSMHErrorCode const KGetYufuTeamMemberFailed;

/// 只允许移交至父级及以上层级部门
extern QCloudSMHErrorCode const KSameSpaceIdTransfered;

/// 存在同名文件（夹）
extern QCloudSMHErrorCode const KSameNameDirectoryOrFileExists;

/// 创建额度失败，请稍后再试或联系客服
extern QCloudSMHErrorCode const KDuplicateQuota;

/// 循环符号链接错误
extern QCloudSMHErrorCode const KCircleSymlink;

/// 目标文件正被编辑
extern QCloudSMHErrorCode const KTargetBeingCoEdited;

/// 同一手机号对应用户在该企业已存在
extern QCloudSMHErrorCode const KDuplicateAllowlistOrUser;

/// 系统繁忙请稍后重试
extern QCloudSMHErrorCode const KDuplicatePurchaseRecord;

/// 系统繁忙请稍后重试
extern QCloudSMHErrorCode const KDuplicateInvitationRecord;

/// 国家代码或手机号码不合法
extern QCloudSMHErrorCode const KInvalidPhoneNumber;

/// 国家代码或手机号码不完整
extern QCloudSMHErrorCode const KIncompletePhoneNumber;

/// 设备ID长度超过限制
extern QCloudSMHErrorCode const KDeviceIdLengthExceed;

/// 用户ID无效
extern QCloudSMHErrorCode const KInvalidUserId;

/// 组织ID无效
extern QCloudSMHErrorCode const KInvalidOrganizationId;

/// 组织名称无效，请重新输入
extern QCloudSMHErrorCode const KInvalidOrganizationName;

/// 部门名称无效，请重新输入
extern QCloudSMHErrorCode const KInvalidTeamName;

/// 用户名称无效，请重新输入
extern QCloudSMHErrorCode const KInvalidUserName;

/// 用户扩展数据无效
extern QCloudSMHErrorCode const KInvalidUserExtensionData;

/// 空间配置数据无效
extern QCloudSMHErrorCode const KInvalidSpaceConfig;

/// 未填写名称或电话或部门（必填）
extern QCloudSMHErrorCode const KInvalidBatchAllowlist;

/// 未找到该空间或目录路径
extern QCloudSMHErrorCode const KInvalidSpaceOrDirectoryPath;

/// 不允许移动父级部门至子部门？
extern QCloudSMHErrorCode const KChildTeamAsDestTeam;

/// 用户访问令牌为空
extern QCloudSMHErrorCode const KEmptyUserToken;

/// 目标位置存储额度不足
extern QCloudSMHErrorCode const KDestTeamSpaceQuotaLimited;

/// 任务不可被取消或已完成
extern QCloudSMHErrorCode const KTaskNotCancelable;

/// 文件为空
extern QCloudSMHErrorCode const KEmptyAllowlistData;

/// 所选文件需位于同一目录下
extern QCloudSMHErrorCode const KShareDirectoryPathInvalid;

/// 验证码无效，请重新输入
extern QCloudSMHErrorCode const KShareExtractionCodeInvalid;

/// 分享过期了
extern QCloudSMHErrorCode const KShareExpired;

/// 分享被禁用
extern QCloudSMHErrorCode const KShareLinkIsDisabled;

/// 分配的额度不可小于当前已用额度
extern QCloudSMHErrorCode const KQuotaCapacityLessThanSize;

/// 二维码无效或过期
extern QCloudSMHErrorCode const KQrCodeInvalidOrExpired;

/// 二维码没有被扫描
extern QCloudSMHErrorCode const KQrCodeNotScanned;

/// 二维码没有被确认
extern QCloudSMHErrorCode const KQrCodeNotConfirmed;

/// 存储的 Code 数据和 userToken 不匹配
extern QCloudSMHErrorCode const KStoreDataNotMatchUserToken;

/// 存储的 Code 数据和 accessToken 不匹配
extern QCloudSMHErrorCode const KStoreDataNotMatchAccessToken;

/// 该文件夹不允许被保存到网盘
extern QCloudSMHErrorCode const KNotAllowSaveToNetDisc;

/// 文件标签已存在
extern QCloudSMHErrorCode const KSameNameTag;

/// 您未加入任何企业，请联系管理员添加
extern QCloudSMHErrorCode const KPhoneNumberNotInAllowlist;

/// 验证码获取过于频繁，请稍后再试
extern QCloudSMHErrorCode const KSmsFrequencyLimit;

/// 用户未加入该企业或未登录
extern QCloudSMHErrorCode const KUserNotInOrganization;

/// 用户未加入该企业
extern QCloudSMHErrorCode const KUserNotInAllowlist;

/// 验证码无效或已过期，请重新获取
extern QCloudSMHErrorCode const KSmsCodeInvalidOrExpired;

/// 验证码错误，请重新输入
extern QCloudSMHErrorCode const KWrongSmsCode;

/// 验证码已过期，请重新获取
extern QCloudSMHErrorCode const KSmsCodeVerificationExceeded;

/// 用户访问令牌无效或过期
extern QCloudSMHErrorCode const KInvalidUserToken;

/// 您已被该组织禁用，请联系组织管理员
extern QCloudSMHErrorCode const KUserDisabled;

/// 您未加入任何组织或被组织删除，请联系组织管理员
extern QCloudSMHErrorCode const KUserNotAllowed;

/// 不支持上传该类型文件
extern QCloudSMHErrorCode const KFileTypeNotAllowed;

/// 文件路径无效
extern QCloudSMHErrorCode const KInvalidFilePath;

/// 普通用户无根目录操作权限
extern QCloudSMHErrorCode const KRootTeamOperationNotAllowed;

///  $1操作无权限
extern QCloudSMHErrorCode const KNoSpecifiedPermission;

/// 仅超级管理员可进行该操作
extern QCloudSMHErrorCode const KNoSuperAdminPermission;

/// 无该部门操作权限
extern QCloudSMHErrorCode const KNoTeamPermission;

/// 验证码失效，请刷新页面重新操作
extern QCloudSMHErrorCode const KInvalidShareAccessToken;

/// 未找到该组织
extern QCloudSMHErrorCode const KOrganizationNotFound;

/// 未查询到该任务
extern QCloudSMHErrorCode const KTaskNotFound;

/// 导入白名单文件加载失败
extern QCloudSMHErrorCode const KCanNotLoadAllowlistFile;

/// 文件已被删除或移动
extern QCloudSMHErrorCode const KShareInfoNotFound;

/// 无个人存储空间
extern QCloudSMHErrorCode const KNoPersonalSpace;

/// 未找到该空间
extern QCloudSMHErrorCode const KNoSpace;

/// 未查询到该用户
extern QCloudSMHErrorCode const KNoOrganizationUser;

/// 未查询到该部门
extern QCloudSMHErrorCode const KOrganizationTeamNotFound;

/// 未查询到目标部门？
extern QCloudSMHErrorCode const KDestOrganizationTeamNotFound;

/// 未找到指定用户
extern QCloudSMHErrorCode const KUserNotFound;

/// 该同步任务不存在或已被取消
extern QCloudSMHErrorCode const KDirectorySyncNotFound;

/// 文件标签未找到
extern QCloudSMHErrorCode const KTagNotFound;

/// 存在重复数据
extern QCloudSMHErrorCode const KDuplicateRecord;

/// 团队名称已存在，请重新输入
extern QCloudSMHErrorCode const KDuplicateTeamRecord;

/// 手机号码已被其他用户使用
extern QCloudSMHErrorCode const KDuplicateUserPhoneNumber;

/// 文件（夹）已加入收藏列表
extern QCloudSMHErrorCode const KDuplicateFavoriteRecord;

/// 该文件夹已被设置为同步盘，请重新选择
extern QCloudSMHErrorCode const KDuplicateDirectorySync;

/// 所选文件夹的某子文件夹已被设为同步盘，请重新选择
extern QCloudSMHErrorCode const KChildDirectorySyncExist;

/// 所选文件夹的某父级文件夹已被设为同步盘，请重新选择
extern QCloudSMHErrorCode const KParentDirectorySyncExist;

/// 该文件存在敏感字段
extern QCloudSMHErrorCode const KSensitiveContentRecognized;

/// 该组织logo存在敏感字段
extern QCloudSMHErrorCode const KSensitiveOrgLogoRecognized;

/// 该用户logo存在敏感字段
extern QCloudSMHErrorCode const KSensitiveUserLogoRecognized;

/// 名字存在敏感字段
extern QCloudSMHErrorCode const KSensitiveNameRecognized;

/// 共享内容正在加载
extern QCloudSMHErrorCode const KShareContentIsLoading;

/// 共享内容不可用
extern QCloudSMHErrorCode const KShareContentNotAvailable;

/// 任务已被取消
extern QCloudSMHErrorCode const KTaskCancelled;

/// 任务已被取消
extern QCloudSMHErrorCode const KTaskIsCancelled;

/// 登出请求出错
extern QCloudSMHErrorCode const KSignOutFail;

/// 发送验证码出错
extern QCloudSMHErrorCode const KSendSmsFailed;

/// SMH请求出错
extern QCloudSMHErrorCode const KSmartMediaHostingError;

/// 未分配默认角色
extern QCloudSMHErrorCode const KNoDefaultRoleFound;

/// 分配存储空间失败
extern QCloudSMHErrorCode const KSpaceAllocationFail;

