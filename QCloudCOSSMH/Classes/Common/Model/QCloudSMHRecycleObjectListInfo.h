//
//  QCloudSMHRecycleObjectListInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHBaseContentInfo.h"

@class QCloudSMHRoleInfo;
@class QCloudSMHTeamInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHRecycleObjectItemInfo : QCloudSMHBaseContentInfo

/// 当返回的条目被截断需要分页获取下一页时返回该字段，在请求下一页时该字段的值即为 NextMarker 参数值；当返回的条目没有被截断即无需继续获取下一页时，不返回该字段；
@property (nonatomic, copy) NSString *nextMarker;
@property (nonatomic, strong) NSString* creationTime;
@property (nonatomic, strong) NSString* modificationTime;

/// 字符串，文件名称；
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* originalPath;

/// 数字，回收站id；
@property (nonatomic, strong) NSString* recycledItemId;

/// 数字，剩余天数，不足一天的部分不计入；
@property (nonatomic, strong) NSString* remainingTime;

///  ISO 8601格式的日期与时间字符串，表示目录或相簿的删除时间，例如 2020-10-14T10:17:57.953Z；
@property (nonatomic, strong) NSString* removalTime;

/// 文件大小，为了避免数字精度问题，这里为字符串格式；
@property (nonatomic, strong) NSString* size;

/// 是否可通过万象预览；
@property (nonatomic, assign) BOOL previewByCI;

/// 是否可用预览图当做 icon
@property (nonatomic, assign) BOOL previewAsIcon;

/// 是否可通过 wps 预览；
@property (nonatomic, assign) BOOL previewByDoc;

/// 字符串，条目类型：
/// dir: 目录或相簿；
/// file: 文件，仅用于文件类型媒体库；
/// image: 图片，仅用于媒体类型媒体库；
/// video: 视频，仅用于媒体类型媒体库；
@property (nonatomic, assign) QCloudSMHContentInfoType type;

@property (nonatomic, strong) NSString* cosUrl;

/**
 病毒详细名称信息
 */
@property (nonatomic, strong) NSString * virusName;


/// QCloudSMHVirusAuditStatus 检测状态
@property (nonatomic, assign) QCloudSMHVirusAuditStatus virusAuditStatus;

@property (nonatomic, assign) QCloudSMHSensitiveWordAuditStatus sensitiveWordAuditStatus;

/// 允许操作的权限；
@property (nonatomic, strong) QCloudSMHRoleInfo*authorityList;
@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;
@property (nonatomic, assign) QCloudSMHContentInfoType fileType;
@property (nonatomic,copy) NSArray * paths;
@property (nonatomic,copy) NSArray * detailPaths;

/// 删除人昵称；
@property (nonatomic, strong) NSString* removalPerson;
@property (nonatomic, strong) NSString *versionId;

/// 当该文件夹是同步盘，或是同步盘的子级文件目录时，返回该字段
@property (nonatomic, strong) QCloudSMHLocalSync * localSync;


@end

@interface QCloudSMHRecycleObjectListInfo : NSObject
@property (nonatomic, copy) NSString *eTag;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, strong) NSString* nextMarker;
@property (nonatomic, strong) NSArray <QCloudSMHRecycleObjectItemInfo *>* contents;
@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;
@property (nonatomic, strong) QCloudSMHRoleInfo*authorityList;

@end



NS_ASSUME_NONNULL_END
