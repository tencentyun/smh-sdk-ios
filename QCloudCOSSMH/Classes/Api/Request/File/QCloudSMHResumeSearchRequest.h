//
//  QCloudContinueSearchRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSearchListInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于继续获取搜索结果
 */
@interface QCloudSMHResumeSearchRequest :QCloudSMHBizRequest

//搜索任务 ID
@property (nonatomic)NSString *searchId;

// 分页标识，创建搜索任务时或继续获取搜索结果时返回的 nextMarker 字段；
@property (nonatomic,strong)NSString * nextMarker;

/**
 是否返回 inode，即文件目录 ID，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withInode;
/**
 是否返回收藏状态，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withFavoriteStatus;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
