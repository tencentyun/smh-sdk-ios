//
//  QCloudSMHNextSearchTeamRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTeamInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 继续获取搜索结果
 */
@interface QCloudSMHNextSearchTeamRequest : QCloudSMHUserBizRequest

/// YES 或 NO，检查是否有 children，可选参数
@property (nonatomic,assign)BOOL checkChildren;

///  1 或 0，检查是否有 children，可选参数
@property (nonatomic,strong)NSString * searchId;

///  分页标识，创建搜索任务时或继续获取搜索结果时返回的 nextMarker 字段；
@property (nonatomic,strong)NSString * marker;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchTeamResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
