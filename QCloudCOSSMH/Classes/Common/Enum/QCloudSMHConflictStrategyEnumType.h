//
//  QCloudSMHRenameEnumType.h
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(uint8_t, QCloudSMHConflictStrategyEnum) {
    QCloudSMHConflictStrategyEnumAsk         = 0,
    QCloudSMHConflictStrategyEnumRename          = 1,
    QCloudSMHConflictStrategyEnumOverWrite      = 2,
};

NSString * QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnum type);

NS_ASSUME_NONNULL_END
