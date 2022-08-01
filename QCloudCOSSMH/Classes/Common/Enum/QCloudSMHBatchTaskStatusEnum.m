//
//  QCloudSMHBatchTaskStatusEnum.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/31.
//

#import "QCloudSMHBatchTaskStatusEnum.h"
QCloudSMHBatchTaskStatus QCloudSMHBatchTaskStatusTypeFromStatus(NSInteger status){
    switch (status) {
        case 202:
            return QCloudSMHBatchTaskStatusWating;
            break;
        case 200:
        case 204:
            return QCloudSMHBatchTaskStatusSucceed;
            break;
        case 207:
            return QCloudSMHBatchTaskStatusFaliure;
            break;
        default:
            return QCloudSMHBatchTaskStatusWating;
            break;
    }
    return QCloudSMHBatchTaskStatusWating;
}
