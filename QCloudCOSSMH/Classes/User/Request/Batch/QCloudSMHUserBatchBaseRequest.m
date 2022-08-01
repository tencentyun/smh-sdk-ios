//
//  QCloudSMHUserBatchBaseRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHUserBatchBaseRequest.h"

@interface QCloudSMHUserBatchBaseRequest ()
@property (nonatomic)NSString *timer;
@end

@implementation QCloudSMHUserBatchBaseRequest


- (void)startAsyncTask{
    /**
     创建定时器
     每隔一段时间调用一下查询任务的接口
     */
    //这里async传值为YES，即在子线程
    NSString* timer = [QCloudGCDTimer timerTask:^{
        [self getTaskStatus];
    } start:1 interval:5 repeats:YES async:YES];
    
    self.timer = timer;
}

- (void)getTaskStatus{
    if (!self.taskIdList) {
        return;
    }
    QCloudSMHGetTaskStatusRequest *req = [QCloudSMHGetTaskStatusRequest new];
    req.priority = QCloudAbstractRequestPriorityLow;
    req.organizationId = self.organizationId;
    req.userToken = self.userToken;
    req.taskIdList = self.taskIdList;
    [req setFinishBlock:^(NSArray * _Nonnull result, NSError * _Nonnull error) {
        if(error){
            if(self.finishBlock){
                self.finishBlock(nil, error);
                [QCloudGCDTimer canelTimer:self.timer];
            }
            return;
        }
        for (QCloudSMHBatchResult *obj in result) {
            if((obj.status != QCloudSMHBatchTaskStatusWating)){
                if(self.finishBlock){
                    self.finishBlock(result, error);
                    [QCloudGCDTimer canelTimer:self.timer];
                }
            }
        }
        
    }];
    [[QCloudHTTPSessionManager shareClient] performRequest:req];
}
-(void)dealloc{
    [QCloudGCDTimer canelTimer:self.timer];
}
@end
