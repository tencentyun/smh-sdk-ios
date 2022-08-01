//
//  QCloudSMHRenameResult.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/19.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHBatchTaskStatusEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHRenameResult : NSObject

@property (nonatomic,copy)NSArray *paths;

@end


@interface QCloudSMHCopyResult : QCloudSMHRenameResult

@property (nonatomic,assign) QCloudSMHBatchTaskStatus status;

@property (nonatomic,copy)NSString *taskId;

@end


NS_ASSUME_NONNULL_END
