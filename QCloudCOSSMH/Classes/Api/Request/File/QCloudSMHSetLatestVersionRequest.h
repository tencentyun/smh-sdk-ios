//
//  QCloudSMHSetLatestVersionRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于设置历史版本为最新版本
 */
@interface QCloudSMHSetLatestVersionRequest : QCloudSMHBizRequest

//历史版本 ID
@property (nonatomic)NSInteger historyId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END

