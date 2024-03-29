//
//  QCloudSMHRecentlyFileListInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHRecentlyFileListInfo.h"
#import "QCloudSMHUserInfo.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHBaseContentInfo.h"
@class QCloudSMHContentGroupInfo;
@class QCloudSMHRecentlyFileInfo;
@class QCloudSMHLocalSync;

NS_ASSUME_NONNULL_BEGIN


@interface QCloudSMHRecentlyFileListInfo : NSObject

/// 总数
@property (nonatomic, assign) NSInteger totalNum;

/// 字符串或整数，用于顺序列出分页的标识；
@property (nonatomic, strong) NSString * nextMarker;

/// 对象数组，目录或相簿内的具体内容
@property (nonatomic, strong) NSArray <QCloudSMHRecentlyFileInfo *>*contents;

@end


@interface QCloudSMHRecentlyFileInfo : QCloudSMHBaseContentInfo

/**
 目录或相簿名或文件名
 */
@property (nonatomic, strong) NSString * name;

/**
 媒体类型
 */
@property (nonatomic, strong) NSString *contentType;
/**
 文件大小
 */
@property (nonatomic, strong) NSString *size;
/**
 条目类型
 QCloudSMHContentInfoTypeDir: 目录或相簿；
 QCloudSMHContentInfoTypeFile: 文件，仅用于文件类型媒体库；
 QCloudSMHContentInfoTypeImage: 图片，仅用于媒体类型媒体库；
 QCloudSMHContentInfoTypeVideo: 视频，仅用于媒体类型媒体库；
 */
@property (nonatomic, assign) QCloudSMHContentInfoType type;

/**
 日期字符串，修改时间；
 */
@property (nonatomic, strong) NSString*modificationTime;


/// 是否可见
@property (nonatomic, assign) BOOL visible;


@property (nonatomic, strong) NSString*spaceId;


/// 空间所属企业 ID；
@property (nonatomic, copy) NSString * spaceOrgId;

/// 是否可用预览图做 icon，非必返；
@property (nonatomic, assign) BOOL previewAsIcon;


@property (nonatomic, strong) NSArray *paths;

/**
 文件 CRC64ECMA 校验值
 */
@property (nonatomic, strong) NSString *crc64;

@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;

@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;

@property (nonatomic) QCloudSMHContentInfoType fileType;

/// 是否可通过万象预览；
@property (nonatomic, assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

@property (nonatomic,strong)QCloudSMHLocalSync * localSync;

/// 访问时间
@property (nonatomic, strong) NSString * visitTime;

@end



NS_ASSUME_NONNULL_END
