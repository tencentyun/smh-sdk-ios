//
//  QCloudSMHListWorkBenchDynamicRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHDynamicModel.h"
#import "QCloudSMHDynamicEnum.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查看工作台动态。
 动态从产生到可搜索，中间可能存在分钟级延迟
 */
@interface QCloudSMHListWorkBenchDynamicRequest : QCloudSMHUserBizRequest

/// 动态类型，多种类型用|分隔；当前支持类型如下：
/// 多个类型 可以组合搜索，比如 QCloudSMHDynamicActionDetailDownload | QCloudSMHDynamicActionDetailPreview | QCloudSMHDynamicActionDetailDelete。
/// 不指定 则搜索全部类型
@property (nonatomic,assign)QCloudSMHDynamicActionDetailType actionTypeDetail;

/// ndTime: 搜索时间范围，建议使用示例中的标准时间，与时区无关； "2021-08-01T04:40:01.000Z"
@property (nonatomic,copy)NSString *startTime;

/// ndTime: 搜索时间范围，建议使用示例中的标准时间，与时区无关；"2021-08-19T04:40:01.000Z"
@property (nonatomic,copy)NSString *endTime;


-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHWorkBenchDynamicList *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END

