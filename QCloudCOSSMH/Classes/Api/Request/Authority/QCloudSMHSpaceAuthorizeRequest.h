//
//  QCloudSMHSpaceAuthorizeRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN


/**
 用于给空间分配权限
 */
@interface QCloudSMHSpaceAuthorizeRequest : QCloudSMHBizRequest

///  授权团队的空间 id
@property (nonatomic,strong)NSString *authorizeSpaceId;

///  授权团队名称 或 授权用户昵称
@property (nonatomic,strong)NSString *name;

///  授权的角色：操作者 or 上传者等
@property (nonatomic,assign)NSInteger roleId;
 
@end

NS_ASSUME_NONNULL_END
