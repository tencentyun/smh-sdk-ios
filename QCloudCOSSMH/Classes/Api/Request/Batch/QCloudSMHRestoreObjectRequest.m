//
//  QCloudSMHRestoreObjectRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHRestoreObjectRequest.h"
#import "QCloudSMHBatchRestoreRecycleObjectReqeust.h"
@implementation QCloudSMHRestoreObjectRequest

- (void)fakeStart{
    QCloudSMHBatchRestoreRecycleObjectReqeust *req = [QCloudSMHBatchRestoreRecycleObjectReqeust new];
    req.priority = self.priority;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.spaceOrgId = self.spaceOrgId;
    req.recycledItemIds = self.batchInfos;
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
    [[QCloudSMHService defaultSMHService]batchRestoreRecycleObject:req];
}
@end
