//
//  QCloudSMHSearchRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSearchTypeEnum.h"
#import "QCloudSMHSearchListInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于搜索目录与文件
 */
@interface QCloudSMHInitiateSearchRequest : QCloudSMHBizRequest

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

@property (nonatomic,strong)NSArray<QCloudSMHSearchTag *> *searchTags;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end


NS_ASSUME_NONNULL_END
