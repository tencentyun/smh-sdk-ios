//
//  QCloudSMHMoveObjectRequest.m
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHMoveObjectRequest.h"
#import "QCloudGetTaskStatusRequest.h"
#import "QCloudSMHBatchMoveRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHService.h"

#import "QCloudSMHTaskResult.h"

@implementation QCloudSMHMoveObjectRequest


- (void)fakeStart{
    QCloudSMHBatchMoveRequest *req = [QCloudSMHBatchMoveRequest new];
    req.priority = self.priority;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.spaceOrgId = self.spaceOrgId;
    req.batchInfos = self.batchInfos;
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError * _Nullable error) {
        //如果是同步任务，从http的状态码中获取任务的状态
        QCloudSMHBatchTaskStatus status = QCloudSMHBatchTaskStatusTypeFromStatus([result __originHTTPURLResponse__].statusCode);
        result.status = status;
        if(status != QCloudSMHBatchTaskStatusWating || error){
            if(self.finishBlock){
                self.finishBlock(result, error);
            }
        }else{
            self.taskId = result.taskId;
            [self startAsyncTask];
        }

    }];
    [[QCloudSMHService defaultSMHService]batchMove:req];
}

@end
