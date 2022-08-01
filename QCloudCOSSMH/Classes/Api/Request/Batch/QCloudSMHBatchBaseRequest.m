//
//  QCloudSMHBatchBaseRequest.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import "QCloudSMHBatchBaseRequest.h"

@interface QCloudSMHBatchBaseRequest ()
@property (nonatomic)NSString *timer;
@end

@implementation QCloudSMHBatchBaseRequest


- (void)startAsyncTask{
    /**
     创建定时器
     每隔一段时间调用一下查询任务的接口
     */
    //这里async传值为YES，即在子线程
    NSString* timer = [QCloudGCDTimer timerTask:^{
        [self getTaskStatus];
    } start:1 interval:3 repeats:YES async:YES];
    
    self.timer = timer;
}

- (void)getTaskStatus{
    if (!self.taskId) {
        return;
    }
    QCloudGetTaskStatusRequest *req = [QCloudGetTaskStatusRequest new];
    req.priority = QCloudAbstractRequestPriorityLow;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.taskIdList = @[self.taskId];
    [req setFinishBlock:^(NSArray * _Nonnull result, NSError * _Nonnull error) {
        if(error){
            if(self.finishBlock){
                self.finishBlock(nil, error);
                [QCloudGCDTimer canelTimer:self.timer];
            }
            return;
        }
        for (QCloudSMHBatchResult *obj in result) {
            if([obj.taskId isEqualToString:self.taskId] && (obj.status != QCloudSMHBatchTaskStatusWating)){
                if(self.finishBlock){
                    self.finishBlock(obj, error);
                    [QCloudGCDTimer canelTimer:self.timer];
                }
            }
        }
        
    }];
    [[QCloudSMHService defaultSMHService] getTaskStatus:req];
}
-(void)dealloc{
    [QCloudGCDTimer canelTimer:self.timer];
}
@end
