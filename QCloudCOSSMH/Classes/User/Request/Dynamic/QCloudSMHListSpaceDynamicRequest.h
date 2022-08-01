//
//  QCloudSMHListSpaceDynamicRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHDynamicModel.h"
#import "QCloudSMHDynamicEnum.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查看单个空间（个人空间、团队空间、共享空间）或空间下的文件夹动态。
 
 动态从产生到可搜索，中间可能存在分钟级延迟
 使用本接口发起异步搜索任务时，接口将在大约 2s 的时间返回，如果在返回时有部分或全部搜索结果，则返回已搜索出的结果的第一页（每页 20 个），如果暂未搜索到结果则返回空数组，因此该接口实际返回的 contents 数量可能为 0 到 20 之间不等，且是否还有更多搜索结果，不应参考 contents 的数量，而应参考 hasMore 字段；
 当需要获取后续页时，使用 QCloudSMHNextListSpaceDynamicRequest 接口；
 */
@interface QCloudSMHListSpaceDynamicRequest : QCloudSMHUserBizRequest

/// 空间所在企业 ID，可选参数，不传默认为当前企业，主要用于跨企业查询共享群组场景；
@property (nonatomic,copy)NSString *spaceOrgId;

/// 空间 ID，可选参数，不填则筛选自身拥有权限的所有空间动态；
@property (nonatomic,copy)NSString *spaceId;

/// 动态类型，多种类型用|分隔；当前支持类型如下：
/// 多个类型 可以组合搜索，比如 QCloudSMHDynamicActionDetailDownload | QCloudSMHDynamicActionDetailPreview | QCloudSMHDynamicActionDetailDelete。
/// 不指定 则搜索全部类型
@property (nonatomic,assign)QCloudSMHDynamicActionDetailType actionTypeDetail;

/// ndTime: 搜索时间范围，建议使用示例中的标准时间，与时区无关；"2021-08-01T04:40:01.000Z",
@property (nonatomic,copy)NSString *startTime;

/// ndTime: 搜索时间范围，建议使用示例中的标准时间，与时区无关；"2021-08-19T04:40:01.000Z",
@property (nonatomic,copy)NSString *endTime;

/// 可选参数，文件夹 path，搜索文件夹动态时传入；
@property (nonatomic,copy)NSString *dirPath;


-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpaceDynamicList *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END

