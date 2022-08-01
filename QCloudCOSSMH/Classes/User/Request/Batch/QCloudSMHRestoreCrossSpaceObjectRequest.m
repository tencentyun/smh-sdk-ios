//
//  QCloudSMHRestoreCrossSpaceObjectRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHRestoreCrossSpaceObjectRequest.h"
#import "QCloudSMHBatchRestoreSpaceRecycleObjectReqeust.h"
#import "QCloudSMHUserService.h"
@implementation QCloudSMHRestoreCrossSpaceObjectRequest

- (void)fakeStart{
    QCloudSMHBatchRestoreSpaceRecycleObjectReqeust *req = [QCloudSMHBatchRestoreSpaceRecycleObjectReqeust new];
    req.priority = self.priority;
    req.organizationId = self.organizationId;
    req.userToken = self.userToken;
    req.recycledItems = self.batchInfos;
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError * _Nullable error) {
        //如果是同步任务，从http的状态码中获取任务的状态
        QCloudSMHBatchTaskStatus status = QCloudSMHBatchTaskStatusTypeFromStatus([result __originHTTPURLResponse__].statusCode);
        result.status = status;
        if(status != QCloudSMHBatchTaskStatusWating || error){
            if(self.finishBlock){
                self.finishBlock(result, error);
            }
        }else{
            if (result.taskId) {
                self.taskIdList = @[ result.taskId];
                [self startAsyncTask];
            }else{
                self.finishBlock(result, error);
            }
        }

    }];
    [[QCloudSMHUserService defaultSMHUserService]batchRestoreCrossSpaceRecycleObject:req];
}
@end
