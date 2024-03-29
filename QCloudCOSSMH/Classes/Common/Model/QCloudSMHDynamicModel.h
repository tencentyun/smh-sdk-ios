//
//  QCloudSMHDynamicModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/27.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHDynamicEnum.h"
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHUserInfo.h"
#import "QCloudSpaceTagEnum.h"
#import "QCloudSMHBaseContentInfo.h"
#import "QCloudSMHRoleInfo.h"
@class QCloudSMHDynamicListContent;
@class QCloudSMHDynamicListTotal;
@class QCloudSMHWorkBenchDynamicListContentItem;
@class QCloudSMHWorkBenchDynamicListContentItemDetail;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHBaseDynamicList : NSObject


@property (nonatomic,assign)BOOL allResultCovered;

/// 搜索任务 ID，用于异步获取搜索结果；
@property (nonatomic,strong)NSString *searchId;

/// 布尔型，是否有更多搜索结果；
@property (nonatomic,assign)BOOL hasMore;

/// 布尔型，搜索任务是否完成；
@property (nonatomic,assign)BOOL searchFinished;

/// 本次搜索返回的结果总数
@property (nonatomic,strong)NSString *hitsCount;

/// 总数
@property (nonatomic,strong)QCloudSMHDynamicListTotal *total;

/// 用于获取后续页的分页标识，仅当 hasMore 为 true 时才返回该字段；
@property (nonatomic,strong)NSString *nextMarker;

/// newNextMarker
@property (nonatomic,strong)NSString *nNextMarker;

/// 搜索任务结束时，返回本次搜索任务的最后一条记录，数据结构与 contents 中记录一致；搜索任务未结束则无此字段；
@property (nonatomic,strong)QCloudSMHDynamicListContent *lastHit;

@end

@interface QCloudSMHDynamicListTotal : NSObject


/// 数字，总数
@property (nonatomic,assign)NSInteger value;

/// 字符串，eq表示总数为 total.value，gte 表示总数比 total.value 更多
@property (nonatomic,strong)NSString *relation;
@end

@interface QCloudSMHDynamicListContent : QCloudSMHBaseContentInfo

@property (nonatomic,strong)NSString * dynamicId;

/// 日志类型 user | api
@property (nonatomic,assign)QCloudSMHDynamicLogType logType;

/// 操作时间
@property (nonatomic,strong)NSString *operationTime;

/// 操作名称
@property (nonatomic,strong)NSString *action;

/// 操作类型分类
@property (nonatomic,assign)QCloudSMHDynamicActionType actionType;

/// 操作类型详情
@property (nonatomic,assign)QCloudSMHDynamicActionDetailType actionTypeDetail;

/// 组织 ID
@property (nonatomic,strong)NSString *orgId;

/// 空间 ID，必返
@property (nonatomic,strong)NSString *spaceId;


@property (nonatomic,strong)NSString *libraryId;

/// 操作者 ID
@property (nonatomic,strong)NSString *operatorId;

/// 操作者昵称
@property (nonatomic,strong)NSString *operatorName;

/// 操作者头像
@property (nonatomic,strong)NSString *operatorAvatar;

/// 操作者手机号
@property (nonatomic,strong)NSString *operatorPhoneNumber;

/// 操作对象 ID
@property (nonatomic,strong)NSString *objectId;

/// 操作对象类型 user | team | organization
@property (nonatomic,assign)QCloudSMHDynamicObjectType objectType;

/// 操作前对象名称
@property (nonatomic,strong)NSString *objectName;

/// 操作前的对象路径，绝对路径，包含文件名
@property (nonatomic,strong)NSString *objectPath;

/// 操作后的对象名称
@property (nonatomic,strong)NSString *toObjectName;

/// 操作后的对象路径，绝对路径，包含文件名
@property (nonatomic,strong)NSString *toObjectPath;

/// 操作后的对象 parentId
@property (nonatomic,strong)NSString *toParentId;

/// 操作后的对象内容类型
@property (nonatomic,strong)NSString *contentType;

/// 是否是文件
@property (nonatomic,assign)BOOL isFile;

/// 操作后的对象文件类型
@property (nonatomic,assign)QCloudSMHContentInfoType fileType;

/// 团队 ID（适用于团队操作类型）
@property (nonatomic,strong)NSString *teamId;

/// 团队 Path（适用于团队操作类型）
@property (nonatomic,strong)NSString *teamPath;

/// 操作内容
@property (nonatomic,strong)NSString *details;


@property (nonatomic,strong)NSString *crc64;


@property (nonatomic,assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;


/// 是否可用预览图做 icon，非必返；
@property (nonatomic, assign) BOOL previewAsIcon;


@property (nonatomic, assign) BOOL isExist;

@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;

@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;

@end


@interface QCloudSMHSpaceDynamicList : QCloudSMHBaseDynamicList

/// 第一页搜索结果，可能为空数组，有关异步搜索的说明请参阅【接口说明】；
@property (nonatomic,strong)NSArray <QCloudSMHDynamicListContent *> *contents;

@end

@interface QCloudSMHWorkBenchDynamicList : NSObject

@property (nonatomic, assign) NSInteger totalNum;
/// 第一页搜索结果，可能为空数组，有关异步搜索的说明请参阅【接口说明】；
@property (nonatomic,strong)NSArray <QCloudSMHWorkBenchDynamicListContentItem *> *contents;

@end

@interface QCloudSMHWorkBenchDynamicListContentItem : NSObject
@property (nonatomic, strong) NSString * date;
@property (nonatomic,strong)NSArray <QCloudSMHWorkBenchDynamicListContentItemDetail *> *list;
@end

@interface QCloudSMHWorkBenchDynamicListContentItemDetail : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic,strong)NSArray <QCloudSMHDynamicListContent *> *details;
@end

NS_ASSUME_NONNULL_END
