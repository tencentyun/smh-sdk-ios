//
//  CBContetInfo.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHRoleInfo.h"
#import "QCloudSMHHighLightInfo.h"
#import "QCloudTagModel.h"
#import "QCloudSMHDynamicModel.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHBaseContentInfo.h"
#import "QCloudSMHCommonEnum.h"
@class QCloudSMHUserInfo;
@class QCloudSMHTeamInfo;
@class QCloudSMHLocalSync;
@class QCloudSMHContentGroupInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHContentInfo : QCloudSMHBaseContentInfo
/**
 目录或相簿名或文件名
 */
@property (nonatomic, strong) NSString * name;

/**
 条目类型
 QCloudSMHContentInfoTypeDir: 目录或相簿；
 QCloudSMHContentInfoTypeFile: 文件，仅用于文件类型媒体库；
 QCloudSMHContentInfoTypeImage: 图片，仅用于媒体类型媒体库；
 QCloudSMHContentInfoTypeVideo: 视频，仅用于媒体类型媒体库；
 */
@property (nonatomic, assign) QCloudSMHContentInfoType type;
/**
 ISO 8601格式的日期与时间字符串，表示目录或相簿的创建时间或文件的上传时间，例如 2020-10-14T10:17:57.953Z；
 */
@property (nonatomic, strong) NSString*creationTime;
/**
 日期字符串，修改时间；
 */
@property (nonatomic, strong) NSString*modificationTime;


@property (nonatomic, strong) NSString*spaceId;


@property (nonatomic, strong) NSString*libraryId;
/**
 创建人昵称；
 */
@property (nonatomic, strong) NSString*creationPerson;
/**
 媒体类型
 */
@property (nonatomic, strong) NSString *contentType;
/**
 文件大小
 */
@property (nonatomic, strong) NSString *size;

/**
 文件大小
 */
@property (nonatomic, strong) NSString *historySize;


/**
 历史版本号
 */
@property (nonatomic, strong) NSString *versionId;

/**
 文件大小
 */
@property (nonatomic, strong) NSString *organizationName;


/**
 文件 CRC64ECMA 校验值
 */
@property (nonatomic, strong) NSString *crc64;

@property (nonatomic, strong) NSString *userId;

/**
 文件 CRC64ECMA 校验值
 */
@property (nonatomic, strong) NSString *eTag;

/**
 整数，当前目录中的文件数（不包含孙子级）；
 */
@property (nonatomic) NSInteger fileCount;

/**
 整数，当前目录中的子目录数（不包含孙子级）；
 */
@property (nonatomic) NSInteger subDirCount;


/**
 整数，当前目录中的子目录数（不包含孙子级）；
 */
@property (nonatomic) QCloudSMHContentInfoType fileType;

/**
 QCloudSMHFileAuthTypeNone = 0, // 未知类型
 QCloudSMHFileAuthTypeToMe, // 共享给我
 QCloudSMHFileAuthTypeMine, // 我的共享
 */
@property (nonatomic,assign) QCloudSMHFileAuthType authType;

/// 是否可通过万象预览；
@property (nonatomic, assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

@property (nonatomic,strong)QCloudSMHLocalSync * localSync;

/**
 文件 CRC64ECMA 校验值
 */
@property (nonatomic, strong) NSArray *paths;

@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;

@property (nonatomic, strong)  QCloudSMHHighLightInfo *highlight;

@property (nonatomic, strong) NSArray <QCloudFileTagItemModel *> * tagList;


@end


@interface QCloudSMHLocalSync : NSObject

/// 当该文件夹为同步盘时，返回同步任务 ID
@property (nonatomic, strong)NSString * syncId;

/// 当该文件夹为同步盘时，返回同步方式，local_to_cloud，非必返
@property (nonatomic, strong)NSString * strategy;

/// 当前文件夹是否为同步盘，如果是同步盘根目录返回 true，如果是同步盘子级节点，返回 false，如果不是同步盘，不返回该字段
@property (nonatomic, assign)BOOL isSyncRootFolder;

/// 当该文件夹为同步盘时，返回设置同步任务的 userID
@property (nonatomic, strong)NSString * syncUserId;
@end


@interface QCloudSMHFileInputInfo : NSObject

/// 是否是目录 是：YES  否： NO
@property (nonatomic, assign) BOOL isDirectory;

/// 文件所在空间id
@property (nonatomic, strong) NSString * spaceId;

/// 空间所在组织id
@property (nonatomic, strong) NSString * spaceOrgId;

/// 文件path
@property (nonatomic, strong) NSString * path;
 
@end

@interface QCloudSMHListFileInfo : NSObject
/// 文件所在空间id
@property (nonatomic, assign) NSInteger totalNum;

/// 文件path
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *> * contents;
@end

NS_ASSUME_NONNULL_END
