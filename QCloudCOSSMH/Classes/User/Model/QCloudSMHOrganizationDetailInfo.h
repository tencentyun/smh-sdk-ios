//
//  QCloudSMHOrganizationDetailInfo.h
//  Pods
//
//  Created by garenwang on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
@class QCloudSMHOrgExtensionData;
@class QCloudSMHOrgExtDefaultTeamOptions;
@class QCloudSMHOrgExtDefaultUserOptions;
@class QCloudSMHOrgExtWatermarkOptions;
@class QCloudSMHOrgExtDomains;
@class QCloudSMHOrgEditionConfig;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHOrganizationDetailInfo : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray <QCloudSMHOrgExtDomains *> *domains;
@property (nonatomic,strong) QCloudSMHOrgExtensionData *extensionData;

@end

@interface QCloudSMHOrgExtensionData : NSObject
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,assign) BOOL ensurePersonalSpace;

/// 组织渠道标识
@property (nonatomic, assign) QCloudSMHChannnelFlag channelFlag;

@property (nonatomic, strong) NSString *allowProduct;

/// 布尔值，是否允许分享；
@property (nonatomic,assign) BOOL enableShare;

@property (nonatomic,assign) BOOL showWeworkAppLink;

/// 布尔值，是否在 UI 上展示企业名称，非必返；
@property (nonatomic,assign) BOOL showOrgNameInUI;
@property (nonatomic,assign) NSInteger userLimit;

/// 新建团队时的默认配置；
@property (nonatomic,strong) QCloudSMHOrgExtDefaultTeamOptions *defaultTeamOptions;

/// 新建用户时的默认配置；
@property (nonatomic,strong) QCloudSMHOrgExtDefaultUserOptions *defaultUserOptions;

/// 水印配置信息；
@property (nonatomic,strong) QCloudSMHOrgExtWatermarkOptions *watermarkOptions;
@property (nonatomic,strong) QCloudSMHOrgEditionConfig *editionConfig;

/// 布尔值，是否允许企业微信扫码登录
@property (nonatomic,assign) BOOL enableWeworkLogin;
@property (nonatomic,strong) NSString *expireTime;
@end


@interface QCloudSMHOrgExtDefaultTeamOptions : NSObject

/// 默认角色
@property (nonatomic,strong) NSString *defaultRoleId;

/// 空间大小
@property (nonatomic,strong) NSString *spaceQuotaSize;
@end

@interface QCloudSMHOrgExtDefaultUserOptions : NSObject

/// 是否可用
@property (nonatomic,assign) BOOL enabled;

/// /// 是否允许分配个人空间；
@property (nonatomic,assign) BOOL allowPersonalSpace;
@property (nonatomic,strong) NSString *personalSpaceQuotaSize;
@end

@interface QCloudSMHOrgExtDomains : NSObject
@property (nonatomic,strong) NSString *isCustom;
@property (nonatomic,strong) NSString *domain;
@end
  
@interface QCloudSMHOrgEditionConfig : NSObject


/// 'personal', 表示个人版
/// 'team', 表示团队版
/// 'enterprise', 表示企业版
@property (nonatomic,assign) QCloudSMHOrganizationType editionFlag;

/// 企业用户上限
@property (nonatomic,assign) NSInteger userCountLimit;

/// 企业存储空间上限，1GB
@property (nonatomic,assign) NSInteger quotaLimit;

/// 是否允许团队空间，企业空间
@property (nonatomic,assign) BOOL enableTeamSpace;

/// 共享空间数量上限
@property (nonatomic,assign) NSInteger shareGroupLimit;

/// 共享空间人数上限
@property (nonatomic,assign) NSInteger shareGroupUserCountLimit;

/// 是否允许共享空间动态
@property (nonatomic,assign) BOOL enableShareGroupDynamic;

/// 是否允许同步盘
@property (nonatomic,assign) BOOL enableDirectoryLocalSync;

/// 是否可进行外链管理，外链次数限制 or 查看已分享的外链
@property (nonatomic,assign) BOOL enableManageShareDirectory;

/// 外链条数限制
@property (nonatomic,assign) NSInteger shareLinkLimit;

/// 是否可管理水印配置
@property (nonatomic,assign) BOOL enableManageWatermark;

/// 是否可后台管理历史版本
@property (nonatomic,assign) BOOL enableDirectoryHistory;

/// 可恢复回收站天数，3 天之内可恢复，3 天之外不可恢复，但在列表页可见
@property (nonatomic,assign) NSInteger restoreRecycledDays;

/// 是否可以离职转接
@property (nonatomic,assign) BOOL enabledResignationTransfer;

/// 是否允许管理操作日志
@property (nonatomic,assign) BOOL enableLog;

/// 是否允许查看统计报表
@property (nonatomic,assign) BOOL enableStatsReport;

/// 是否允许团队管理员（多级管理员设置）
@property (nonatomic,assign) BOOL enableTeamAdmin;

/// 是否允许企业微信导入
@property (nonatomic,assign) BOOL enableWechatIntegration;

/// 是否允许海外手机号
@property (nonatomic,assign) BOOL enableOverseasPhoneNumber;

/// 是否允许在线编辑
@property (nonatomic,assign) BOOL enableOnlineEdit;

@end

@interface QCloudSMHOrgExtWatermarkOptions : NSObject


///  布尔值，是否开启预览水印；
@property (nonatomic,assign) BOOL enablePreviewWatermark;

///  整型，0 用户昵称+uid水印，1 企业名称水印；
@property (nonatomic,assign) NSInteger previewWatermarkType;

///  布尔值，是否开启下载水印；
@property (nonatomic,assign) BOOL enableDownloadWatermark;

///  整型，0 用户昵称+uid水印，1 企业名称水印；
@property (nonatomic,assign) NSInteger downloadWatermarkType;

///  布尔值，是否开启预览水印；
@property (nonatomic,assign) BOOL enableShareWatermark;

///  整型，1 企业名称水印；
@property (nonatomic,assign) NSInteger shareWatermarkType;

@end


NS_ASSUME_NONNULL_END

