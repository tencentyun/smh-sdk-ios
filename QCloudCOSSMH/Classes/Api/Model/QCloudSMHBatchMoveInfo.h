//
//  QCloudSMHBatchMoveInfo.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHConflictStrategyEnumType.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHBatchMoveInfo : NSObject

///  被重命名或移动的源目录、相簿或文件路径；
@property (nonatomic,strong)NSString *from;

/// 目标目录、相簿或文件路径；
@property (nonatomic,strong)NSString *to;

/// 文件名冲突时的处理方式，ask: 冲突时返回 status: 409 及 SameNameDirectoryOrFileExists 错误码，rename: 冲突时自动重命名文件，overwrite: 如果冲突目标为目录时返回 status: 409 及 SameNameDirectoryOrFileExists 错误码，否则覆盖已有文件，如果目标为目录或相簿时，默认为 ask 且不支持 overwrite，如果目标为文件默认为 rename；
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

/// 是否移动文件夹权限，true 移动，false 不移动；
@property (nonatomic,assign)BOOL moveAuthority;
@end

NS_ASSUME_NONNULL_END
