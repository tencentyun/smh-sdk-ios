//
//  QCloudSMHCopyObjectRequest.m
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHCopyObjectRequest.h"
#import "QCloudSMHBatchCopyRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHService.h"

@interface QCloudSMHCopyObjectRequest()
@property (nonatomic)NSString *timer;
@end
@implementation QCloudSMHCopyObjectRequest


- (void)fakeStart{
    QCloudSMHBatchCopyRequest *req = [QCloudSMHBatchCopyRequest new];
    req.priority = self.priority;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.spaceOrgId = self.spaceOrgId;
    req.shareAccessToken = self.shareAccessToken;
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
    [[QCloudSMHService defaultSMHService]batchCopy:req];
}

@end
