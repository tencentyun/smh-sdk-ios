//
//  QCloudSMHDeleteObjectRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudSMHDeleteObjectRequest.h"
#import "QCloudSMHBatchDeleteRequest.h"


@implementation QCloudSMHDeleteObjectRequest

- (void)fakeStart{
    QCloudSMHBatchDeleteRequest *req = [QCloudSMHBatchDeleteRequest new];
    req.priority = self.priority;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.spaceOrgId = self.spaceOrgId;
    req.batchInfos = self.batchInfos;
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError * _Nullable error) {
        NSLog(@"%ld",result.status);
        //如果是同步任务，从http的状态码中获取任务的状态
        QCloudSMHBatchTaskStatus status = QCloudSMHBatchTaskStatusTypeFromStatus([result __originHTTPURLResponse__].statusCode);
        result.status = status;
        if(status != QCloudSMHBatchTaskStatusWating || error){
            if(self.finishBlock){
                self.finishBlock(result, error);
            }
        }else{
            //说明是一个异步任务，启动定时器，轮询查询
            self.taskId = result.taskId;
            [self startAsyncTask];
        }
    
        
    }];
    [[QCloudSMHService defaultSMHService]batchDelete:req];
}

@end
