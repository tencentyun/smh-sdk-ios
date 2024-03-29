//
//  QCloudSMHFavoriteInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/13.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHBaseContentInfo.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHFavoriteInfo : QCloudSMHBaseContentInfo

/// 文件目名称；
@property (nonatomic,copy) NSString *name;

/// 文件的 CRC64-ECMA182 校验值，为了避免数字精度问题，这里为字符串格式；
@property (nonatomic,copy) NSString *crc64;
@property (nonatomic,copy) NSString *favoriteTime;
@property (nonatomic,copy) NSString *eTag;

/// 收藏 ID；
@property (nonatomic, assign) NSInteger favoriteId;

/// 字符串，空间 ID；
@property (nonatomic,strong) NSString *spaceId;

/// 空间所在组织id
@property (nonatomic,strong) NSString *spaceOrgId;

/// 文件目录大小，非必返；
@property (nonatomic, assign)NSInteger size;

@property (nonatomic,copy) NSString *versionId;

/// 当该文件夹是同步盘，或是同步盘的子级文件目录时，返回该字段
@property (nonatomic, strong) QCloudSMHLocalSync * localSync;

/// 日期字符串，修改时间；
@property (nonatomic, strong) NSString*modificationTime;

/// 条目类型
/// QCloudSMHContentInfoTypeDir: 目录或相簿；
/// QCloudSMHContentInfoTypeFile: 文件，仅用于文件类型媒体库；
/// QCloudSMHContentInfoTypeImage: 图片，仅用于媒体类型媒体库；
/// QCloudSMHContentInfoTypeVideo: 视频，仅用于媒体类型媒体库；
@property (nonatomic, assign) QCloudSMHContentInfoType type;
@property (nonatomic, assign) QCloudSMHContentInfoType fileType;
@property (nonatomic, strong) NSArray *paths;

/// 是否可通过万象预览；
@property (nonatomic, assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

/// 是否可见（文件目录被删除或无权限时为 false)；
@property (nonatomic, assign) BOOL visible;

/// 权限列表
@property (nonatomic, strong)  QCloudSMHRoleInfo * authorityList;
@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;

@end

NS_ASSUME_NONNULL_END
