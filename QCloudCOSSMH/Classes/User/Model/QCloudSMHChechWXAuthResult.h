//
//  QCloudSMHChechWXAuthResult.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 检查微信授权是否有效结果
 */
@interface QCloudSMHChechWXAuthResult : NSObject

/**
 是否有效
 */
@property (nonatomic,assign)BOOL available;
@end

NS_ASSUME_NONNULL_END
