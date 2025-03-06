//
//  QCloudSetSpaceTrafficLimitRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 设置租户空间限速
 
 设置限速之后，将会对该空间后续所有的下载请求设置单链接限速
 如果下载请求自身也设置了单链接限速，则最终的限速为两者的最小值
 正常的预览行为不限速，但使用预览接口获取不可预览的文件类型的下载链接时，将会进行限速
 */
@interface QCloudSetSpaceTrafficLimitRequest : QCloudSMHBizRequest

/**
 空间下载限速，数字类型，必选参数，范围 100KB/s - 100MB/s ，单位Byte，当输入-1时表示取消限速；
 */
@property (nonatomic,assign)NSInteger downloadTrafficLimit;

@end

NS_ASSUME_NONNULL_END
