//
//  QCloudSMHCheckDeregisterResult.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 检查企业成员是否可注销 校验结果
 */
@interface QCloudSMHCheckDeregisterResult : NSObject

/// 是否可以注销
@property (nonatomic,assign)BOOL canDeregister;

/// 在该企业中创建的群组是否解散；
@property (nonatomic,assign)BOOL hasGroup;

/// 在该企业个人空间中的文件是否清空；
@property (nonatomic,assign)BOOL hasPersonalSpaceFile;

@end

NS_ASSUME_NONNULL_END
