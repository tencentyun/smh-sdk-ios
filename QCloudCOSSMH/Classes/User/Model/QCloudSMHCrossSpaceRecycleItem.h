//
//  QCloudSMHCrossSpaceRecycleItem.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHContentInfo.h"

#import "QCloudSMHUserInfo.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHTeamInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHCrossSpaceRecycleItem : NSObject

/// : 数字，回收站id；
@property (nonatomic, strong) NSString *recycledItemId;

/// : 字符串，回收站文件空间 ID；
@property (nonatomic, strong) NSString *spaceId;

/// 空间标签
@property (nonatomic, assign) QCloudSpaceTagEnum spaceTag;

/// : 数组，原始路径；
@property (nonatomic, strong) NSArray *originalPath;

/// : 文件大小，为了避免数字精度问题，这里为字符串格式；
@property (nonatomic, strong) NSString *size;

/// : 是否可通过 wps 预览；
@property (nonatomic, assign) BOOL previewByDoc;

/// : 是否可通过万象预览；
@property (nonatomic, assign) BOOL previewByCI;

/// : 是否可用预览图当做 icon；
@property (nonatomic, assign) BOOL previewAsIcon;

/// : 文件类型：excel、powerpoint 等；
@property (nonatomic, assign) QCloudSMHContentInfoType fileType;

/// : 是否超过恢复时间；
@property (nonatomic, assign) BOOL isOverRestoreTime;

/// : 字符串，目录或相簿名或文件名；
@property (nonatomic, strong) NSString *name;

/// : 字符串，条目类型：
@property (nonatomic, assign) QCloudSMHContentInfoType type;

/// : ISO 8601格式的日期与时间字符串，表示目录或相簿的创建时间或文件的上传时间，例如 2020-10-14T10:17:57.953Z；
@property (nonatomic, strong) NSString *creationTime;

/// : ISO 8601格式的日期与时间字符串，表示目录或相簿的修改时间，例如 2020-10-14T10:17:57.953Z；
@property (nonatomic, strong) NSString *modificationTime;

/// : ISO 8601格式的日期与时间字符串，表示目录或相簿的删除时间，例如 2020-10-14T10:17:57.953Z；
@property (nonatomic, strong) NSString *removalTime;

/// : 数字，剩余天数，不足一天的部分不计入；
@property (nonatomic, assign) NSInteger remainingTime;

///  允许操作的权限；
@property (nonatomic, strong) QCloudSMHRoleInfo *authorityList;
@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;

/// : 删除者姓名；
@property (nonatomic, strong) NSString *removedByNickname;

/// : 删除者头像；
@property (nonatomic, strong) NSString *removedByAvatar;

///  团队空间信息； 和 用户空间信息二选一返回
@property (nonatomic, strong) QCloudSMHTeamInfo *team;

/// : 用户空间信息；和 团队空间信息二选一返回
@property (nonatomic, strong) QCloudSMHUserInfo *user;

/// 共享群组空间信息；和 用户空间信息、团队空间信息三选一返回
@property (nonatomic, strong) QCloudSMHContentGroupInfo * group;

@end

@interface QCloudSMHCrossSpaceRecycleInfo : NSObject

/// 整数，回收站所有文件和文件夹总数。
@property (nonatomic, assign) NSInteger totalNum;

/// 字符串或整数，用于顺序列出分页的标识；
@property (nonatomic, strong) NSString* nextMarker;

/// 对象数组，目录或相簿内的具体内容：
@property (nonatomic, strong) NSArray <QCloudSMHCrossSpaceRecycleItem *>* contents;
@end

@interface QCloudSMHBatchInputRecycleInfo : NSObject

/// 空间 ID
@property (nonatomic, strong) NSString* spaceId;

/// recycledItemId 回收站文件 ID
@property (nonatomic, assign) NSInteger recycledItemId;

@end

NS_ASSUME_NONNULL_END



