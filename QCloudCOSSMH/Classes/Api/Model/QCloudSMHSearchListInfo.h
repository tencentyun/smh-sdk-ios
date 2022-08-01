//
//  QCloudSMHSearchListInfo.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN


/// 搜索标签
@interface QCloudSMHSearchTag : NSObject

/// d: 标签 id；
@property (nonatomic,strong) NSString *tagId;

/// 标签值，可选参数，用于键值对标签，如：标签名 ios 标签值 13.2，搜索特定版本标签；
@property (nonatomic,strong) NSString *tagValue;

@end

@interface QCloudSMHSearchListInfo : NSObject

/// 搜索任务 ID，用于异步获取搜索结果；
@property (nonatomic,strong) NSString *searchId;

/// 布尔型，是否有更多搜索结果
@property (nonatomic, assign) NSInteger hasMore;

/// 用于获取后续页的分页标识，仅当 hasMore 为 true 时才返回该字段；
@property (nonatomic, copy) NSString *nextMarker;

/// contents: 第一页搜索结果，可能为空数组
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *>*contents;
@end

NS_ASSUME_NONNULL_END
