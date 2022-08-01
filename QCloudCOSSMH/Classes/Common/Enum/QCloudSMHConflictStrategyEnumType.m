//
//  QCloudSMHRenameEnumType.m
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/4.
//

#import "QCloudSMHConflictStrategyEnumType.h"


NSString * QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnum type){
    switch (type) {
        case QCloudSMHConflictStrategyEnumRename:
            return @"rename";
            break;
        case QCloudSMHConflictStrategyEnumAsk:
            return @"ask";
            break;
        case QCloudSMHConflictStrategyEnumOverWrite:
            return @"overwrite";
            break;
        default:
            return @"rename";
            break;
    }
}

