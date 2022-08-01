//
//  QCloudSMHGetGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询群组
 */
@interface QCloudSMHGetGroupRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHGroupInfo *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
