//
//  QCloudHistorVersionInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHCreationWayEnum.h"

@class QCloudSMHRoleInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHHistoryVersionInfo : NSObject
// 版本号
@property (nonatomic, assign)  NSInteger version;

@property (nonatomic, assign) NSInteger versionID;

//是否最新版本
@property (nonatomic, assign)  bool isLatestVersion;
@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;
//修改者头像
@property (nonatomic, strong)  NSString *avatar;
//文件大小
@property (nonatomic, assign)  NSInteger size;
//目录或相簿名或文件名
@property (nonatomic, strong)  NSString *name;

@property (nonatomic, strong)  NSString *crc64;
/**
 条目类型
 QCloudSMHContentInfoTypeDir: 目录或相簿；
 QCloudSMHContentInfoTypeFile: 文件，仅用于文件类型媒体库；
 QCloudSMHContentInfoTypeImage: 图片，仅用于媒体类型媒体库；
 QCloudSMHContentInfoTypeVideo: 视频，仅用于媒体类型媒体库；
 */
@property (nonatomic, assign) QCloudSMHContentInfoType type;

/// ISO 8601格式的日期与时间字符串，表示目录或相簿的创建时间或文件的上传时间，例如 2020-10-14T10:17:57.953Z；
@property (nonatomic, strong) NSString*creationTime;

/// 日期字符串，修改时间；
@property (nonatomic, strong) NSString*modificationTime;

@property (nonatomic, assign) QCloudSMHCreationWay creationWay;

/// 创建者昵称
@property (nonatomic, strong) NSString *createdUserNickname;

/// 创建者头像
@property (nonatomic, strong) NSString *createdUserAvatar;

/// 创建者id
@property (nonatomic, strong) NSString *createdUserId;


@end

NS_ASSUME_NONNULL_END
