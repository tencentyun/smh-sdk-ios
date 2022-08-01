//
//  QCloudFileShareInfo.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHBaseContentInfo.h"

@class QCloudFileShareItem;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudFileShareInfo : QCloudSMHBaseContentInfo

/// 分享文件时不需传 分享id
@property (nonatomic,strong) NSString * shareId;

/// 字符串，分享文件名集合，如果有多个文件，显示第一个文件名 + 等；
@property (nonatomic,strong) NSString * name;

/// 数组，文件信息集合；
@property (nonatomic,strong) NSArray <QCloudFileShareItem *> * directoryInfoList;

///  日期字符串，过期时间；
@property (nonatomic,strong) NSString * expireTime;

/// 分享code
@property (nonatomic,strong) NSString * code;

/// 创建时间，分享文件时不需传
@property (nonatomic,strong) NSString * creationTime;

/// 字符串，提取码；
@property (nonatomic, strong, nullable) NSString * extractionCode;

/// 链接 分享文件时不许传
@property (nonatomic,strong)NSString * shareLink;

/// 布尔型，是否链接到最新版；
@property (nonatomic,assign) BOOL linkToLatestVersion;

/// 布尔型，是否能预览；
@property (nonatomic,assign) BOOL canPreview;

/// 布尔型，是否能下载；
@property (nonatomic,assign) BOOL canDownload;

/// 是否可在线编辑
@property (nonatomic,assign) BOOL canModify;

/// 布尔型，是否能保存到网盘；
@property (nonatomic,assign) BOOL canSaveToNetDisc;

/// 最大可预览次数，可选参数，默认无限制； 返回参数中 null标识不限制
@property (nonatomic,assign) NSInteger previewCount;

/// 最大可下载次数，可选参数，默认无限制； 返回参数中 null标识不限制
@property (nonatomic,assign) NSInteger downloadCount;

/// 已使用预览次数；
@property (nonatomic,assign) NSInteger previewCountUsed;

/// 已使用下载次数；
@property (nonatomic,assign) NSInteger downloadCountUsed;

/// 文件类型 分享文件时不需设置
@property (nonatomic,strong) NSString * fileType;

/// 分享类型 分享文件时不需设置
@property (nonatomic,strong) NSString * type;

/// 是否被禁用
@property (nonatomic,assign) BOOL disabled;

/// 文件大小，分享单个文件才返回，文件夹不返回；
@property (nonatomic,strong) NSString * size;

@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;

@end


@interface QCloudFileListContent : NSObject

@property (nonatomic,strong) NSString * totalNum;
@property (nonatomic,strong) NSArray <QCloudFileShareInfo *> * contents;

@end

@interface QCloudFileShareItem : NSObject

/// 字符串，文件路径；
@property (nonatomic,strong) NSString * path;

/// 整型，文件版本 id；
@property (nonatomic,assign) NSInteger versionId;

/// 空间所属组织 ID；
@property (nonatomic,strong) NSString * spaceOrgId;

/// 字符串，空间 ID；
@property (nonatomic,strong) NSString * spaceId;

/// 文件类型；字符串 file 或 dir
@property (nonatomic,strong) NSString * type;

@end

@interface QCloudSMHFileShareResult : NSObject


/// 整数，分享 ID；
@property (nonatomic,strong) NSString * shareId;

/// 字符串，分享链接
@property (nonatomic,strong) NSString * shareLink;

/// 分享code
@property (nonatomic,strong) NSString * code;

/// 字符串，过期时间
@property (nonatomic,strong) NSString * expireTime;

/// 字符串，创建时间
@property (nonatomic,strong) NSString * creationTime;
@end

NS_ASSUME_NONNULL_END
