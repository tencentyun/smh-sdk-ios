//
//  QCloudSMHGetCreateGroupCountRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询用户创建的群组数量
 
 该接口用于组织管理员删除用户时，查询该用户是否创建有群组。删除用户时，该用户创建的群组都会被解散。
 */
@interface QCloudSMHGetCreateGroupCountRequest : QCloudSMHUserBizRequest

/// 用户 ID 列表
@property (nonatomic, strong) NSArray * userIds;

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHCreateGroupCountResult *> * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
