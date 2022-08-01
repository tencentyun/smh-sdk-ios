//
//  QCloudSMHHistoryStateInfo.h
//  Pods
//
//  Created by garenwang on 2021/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHHistoryStateInfo : NSObject

/// 是否打开历史版本；
@property (nonatomic,assign)BOOL enableFileHistory;

/// 历史版本最大数量；
@property (nonatomic,assign)NSInteger fileHistoryCount;

/// 历史版本过期时间；
@property (nonatomic,assign)NSInteger fileHistoryExpireDay;
@end

NS_ASSUME_NONNULL_END
