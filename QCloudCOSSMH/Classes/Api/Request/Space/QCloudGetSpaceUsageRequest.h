//
//  QCloudGetSpaceUsageRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSpaceUsageInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 批量查询租户空间容量
 */
@interface QCloudGetSpaceUsageRequest : QCloudSMHBizRequest

/**
 空间列表，以逗号分隔，如 space1,space2
 */
@property (nonatomic,strong) NSString * spaceIds;

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHSpaceUsageInfo *> * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
