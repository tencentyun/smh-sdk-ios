//
//  QCloudSMHExitFileAuthorize.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHExitFileAuthorize : NSObject

/// 退出授权用户的 ID；
@property (nonatomic,strong)NSString *userId;

/// 用户昵称，必选参数；
@property (nonatomic,strong)NSString *name;

/// 退出授权的角色 ID，操作者 or 上传者等，必选参数；
@property (nonatomic,assign)NSInteger roleId;
@end

NS_ASSUME_NONNULL_END
