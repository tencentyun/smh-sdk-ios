//
//  QCloudSMHOrganizationShareList.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/17.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHContentTypeEnum.h"

@class QCloudSMHOrganizationShareListItem;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHOrganizationShareList : NSObject
@property (nonatomic,strong) NSString * totalNum;
@property (nonatomic,strong) NSArray <QCloudSMHOrganizationShareListItem *> * contents;
@end


@interface QCloudSMHOrganizationShareListItem : NSObject

/// 分享文件时不需传 分享id
@property (nonatomic,strong) NSString * shareId;

/// 字符串，分享文件名集合，如果有多个文件，显示第一个文件名 + 等；
@property (nonatomic,strong) NSString * name;

/// 日期字符串，过期时间
@property (nonatomic,strong) NSString * expireTime;

/// 日期字符串，创建时间
@property (nonatomic,strong) NSString * creationTime;

/// 字符串，创建人昵称
@property (nonatomic,strong) NSString * nickname;

/// 文件类型；混合文件：multi-file、文件：file、文件夹：dir；
@property (nonatomic,assign)QCloudSMHShareFileType type;

/// 最大可预览次数，可选参数，默认无限制； 返回参数中 null标识不限制
@property (nonatomic,assign) NSInteger previewCount;

/// 最大可下载次数，可选参数，默认无限制； 返回参数中 null标识不限制
@property (nonatomic,assign) NSInteger downloadCount;

/// 已使用预览次数；
@property (nonatomic,assign) NSInteger previewCountUsed;

/// 已使用下载次数；
@property (nonatomic,assign) NSInteger downloadCountUsed;

/// /// 文件类型 分享文件时不需设置
@property (nonatomic,assign) QCloudSMHContentInfoType fileType;

/// 布尔值，是否可通过 onlyoffice 预览；
@property (nonatomic,assign) BOOL previewByDoc;

/// 布尔值，是否可通过万象预览；
@property (nonatomic,assign) BOOL previewByCI;

/// 布尔值，是否可用预览图当做 icon；
@property (nonatomic,assign) BOOL previewAsIcon;

/// 链接产生的外网下行流量，单位 Byte
@property (nonatomic,assign) NSInteger shareTraffic;

/// 是否被禁用
@property (nonatomic,assign) BOOL disabled;

@end

NS_ASSUME_NONNULL_END
