//
//  QCloudSMHCreateGroupRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 创建群组
 权限要求：超级管理员或系统管理员
 */
@interface QCloudSMHCreateGroupRequest : QCloudSMHUserBizRequest

/// 字符串，群组名称，必填项；
@property (nonatomic, copy) NSString * name;

/// 群组用户列表，可选项；
@property (nonatomic,strong)NSArray <QCloudSMHCreateGroupItem *> * users;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHCreateGroupResult *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
