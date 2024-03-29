//
//  QCloudSMHUserResumeSearchRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSearchListInfo.h"
#import "QCloudSMHSearchTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于继续获取搜索结果
 */
@interface QCloudSMHUserResumeSearchRequest :QCloudSMHUserBizRequest

//搜索任务 ID
@property (nonatomic)NSString *searchId;

// 分页标识，创建搜索任务时或继续获取搜索结果时返回的 nextMarker 字段；
@property (nonatomic,strong)NSString * nextMarker;

@property (nonatomic,strong)NSString * spaceId;

@property (nonatomic,strong)NSString * spaceOrgId;

/// 根据文件名或文件内容搜索，"fileName"表示仅搜索文件名，"fileContents"表示仅搜索文件内容，"all"表示搜索文件名+文件内容
@property (nonatomic,assign)QCloudSMHSearchSearchByType searchBy;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSearchListInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
