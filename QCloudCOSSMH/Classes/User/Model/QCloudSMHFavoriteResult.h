//
//  QCloudSMHFavoriteResult.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/13.
//

#import <Foundation/Foundation.h>
@class QCloudSMHFavoriteInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHFavoriteResult : NSObject

/// 对象被创建时对象内容的信息标识
@property (nonatomic,copy) NSString *eTag;

/// 当前页码
@property (nonatomic, assign) NSInteger page;

/// 列表总数
@property (nonatomic, assign) NSInteger totalNum;

/// 每一页数据count
@property (nonatomic, assign) NSInteger pageSize;

/// 当前页面数据
@property (nonatomic,strong) NSArray<QCloudSMHFavoriteInfo *> * contents;

/// 用于获取后续页的分页标识，仅当 hasMore 为 true 时才返回该字段；
@property (nonatomic,copy) NSString *nextMarker;

@end

@interface QCloudSMHFavoriteGroupInfo : NSObject

@property (nonatomic,copy) NSString *favoriteGroupid;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *tag;

@end

@interface QCloudSMHFavoriteGroupList : NSObject

/// 列表总数
@property (nonatomic, assign) NSInteger totalNum;

/// 对象数组，收藏夹具体信息：
@property (nonatomic,strong) NSArray<QCloudSMHFavoriteInfo *> * contents;

@end

@interface QCloudSMHCreateFavoriteGroupResult : NSObject

/// 收藏夹id
@property (nonatomic,copy) NSString *favoriteGroupid;

@end

NS_ASSUME_NONNULL_END
