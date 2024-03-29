//
//  QCloudSMHUserInitiateSearchRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSearchTypeEnum.h"
#import "QCloudSMHSearchListInfo.h"
#import "QCloudSMHSortTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN


/**
 用于全局搜索目录与文件
 */
@interface QCloudSMHUserInitiateSearchRequest : QCloudSMHUserBizRequest

/**
 搜索关键字，可使用空格分隔多个关键字，关键字之间为“或”的关系并优先展示匹配关键字较多的项目；
 */
@property (nonatomic,strong)NSString *keyword;

/**
 搜索范围，指定搜索的目录，如搜索根目录可指定为空字符串、“/”或不指定该字段
 */
@property (nonatomic,strong)NSString *scope;

/**
 搜索类型，字符串或字符串数组 QCloudSMHSearchType
 */
@property (nonatomic,strong)NSArray<NSNumber *> *searchTypes;

@property (nonatomic,strong)NSArray<NSString *> *extname;

@property (nonatomic,strong)NSArray<QCloudSMHSearchTag *> *searchTags;

@property (nonatomic,strong)NSString * spaceOrgId;

/// 搜索创建/更新者，可选参数，对象数组
@property (nonatomic,strong)NSArray<QCloudSMHSearchCreator *> *creators;

/// 根据文件名或文件内容搜索，"fileName"表示仅搜索文件名，"fileContents"表示仅搜索文件内容，"all"表示搜索文件名+文件内容
@property (nonatomic,assign)QCloudSMHSearchSearchByType searchBy;

@property (nonatomic,strong)NSString *spaceId;
/// 搜索文件大小范围，整数，单位 Byte，均为可选参数
@property (nonatomic,assign)NSInteger minFileSize;
@property (nonatomic,assign)NSInteger maxFileSize;

/// 搜索更新时间范围，时间戳字符串，与时区无关，均可选参数
@property (nonatomic,strong)NSString *modificationTimeStart;
@property (nonatomic,strong)NSString *modificationTimeEnd;


@property (nonatomic,assign)QCloudSMHSortType sortType;

/// 是否为精准搜索，"true"表示精准搜索，"false"表示模糊搜索
@property (nonatomic,assign)BOOL accurate;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end


NS_ASSUME_NONNULL_END
