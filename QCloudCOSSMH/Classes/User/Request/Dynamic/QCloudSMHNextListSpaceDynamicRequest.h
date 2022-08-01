//
//  QCloudSMHNextListSpaceDynamicRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHDynamicModel.h"
#import "QCloudSMHDynamicEnum.h"

NS_ASSUME_NONNULL_BEGIN
/**
 继续获取空间或文件夹动态
 */
@interface QCloudSMHNextListSpaceDynamicRequest : QCloudSMHUserBizRequest


/// 空间所在企业 ID，可选参数，不传默认为当前企业，主要用于跨企业查询共享群组场景；
@property (nonatomic,copy)NSString *spaceOrgId;

/// QCloudSMHListSpaceDynamicRequest接口返回的本次搜索id;
@property (nonatomic,copy)NSString *searchId;

/// 分页标识，创建搜索任务时或继续获取搜索结果时返回的 nextMarker 字段，可选参数；
@property (nonatomic,copy)NSString *marker;


-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHSpaceDynamicList *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END

