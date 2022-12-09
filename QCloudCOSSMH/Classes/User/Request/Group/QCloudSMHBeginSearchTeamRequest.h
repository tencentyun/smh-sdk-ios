//
//  QCloudSMHBeginSearchTeamRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTeamInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 开始搜索团队
 
 使用本接口发起异步搜索任务时，接口将在大约 2s 的时间返回，如果在返回时有部分或全部搜索结果，则返回已搜索出的结果的第一页（每页 20 个），如果暂未搜索到结果则返回空数组，因此该接口实际返回的 contents 数量可能为 0 到 20 之间不等，且是否还有更多搜索结果，不应参考 contents 的数量，而应参考 hasMore 字段；
 当需要获取后续页时，使用【继续获取搜索结果】接口；
 */
@interface QCloudSMHBeginSearchTeamRequest : QCloudSMHUserBizRequest

/// YES 或 NO，检查是否有 children，可选参数
@property (nonatomic,assign)BOOL checkChildren;

/// YES 或 NO，只搜索能够管理的团队，可选参数
@property (nonatomic,assign)BOOL checkManagementPermission;

/// YES 或 NO，只搜索加入的团队，可选参数
@property (nonatomic,assign)BOOL checkBelongingTeams;

/// keyword: 字符串，搜索关键字，可使用空格分隔多个关键字，关键字之间为“或”的关系并优先展示匹配关键字较多的项目，可选参数；
@property (nonatomic,strong)NSString * keyword;

/// ancestorId: 整数，搜索范围，指定搜索的祖先团队，如搜索所有团队可不指定该字段，可选参数；
@property (nonatomic,assign)NSInteger  ancestorId;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSearchTeamResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
