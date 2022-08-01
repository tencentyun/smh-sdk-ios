//
//  QCloudSMHCrossSpaceAsyncCopyDirectoryRequest.m
//  QCloudCOSSMH
//
//  Created by 李雪 on 2021/8/1.
//

#import "QCloudSMHCrossSpaceAsyncCopyDirectoryRequest.h"
#import "QCloudSMHCrossSpaceCopyDirectoryRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHService.h"

@interface QCloudGetCrossCopyTaskStatusRequest : QCloudGetTaskStatusRequest

@end

@implementation QCloudGetCrossCopyTaskStatusRequest
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithURLEncodeParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseJSONSerilizerBlock, QCloudResponseObjectSerilizerBlock([QCloudSMHCopyResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

@end



@interface QCloudSMHCrossSpaceAsyncCopyDirectoryRequest()
@property (nonatomic)NSString *timer;
@end
@implementation QCloudSMHCrossSpaceAsyncCopyDirectoryRequest


- (void)fakeStart{
    QCloudSMHCrossSpaceCopyDirectoryRequest *req = [QCloudSMHCrossSpaceCopyDirectoryRequest new];
    req.priority = self.priority;
    req.libraryId = self.libraryId;
    req.spaceId = self.spaceId;
    req.userId = self.userId;
    req.dirPath = self.dirPath;
    req.from = self.from;
    req.fromSpaceId = self.fromSpaceId;
    req.conflictStrategy = self.conflictStrategy;
    
    [req setFinishBlock:^(QCloudSMHCopyResult *result, NSError * _Nullable error) {
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
    [[QCloudSMHService defaultSMHService]performRequest:req];
}

- (void)getTaskStatus{
    if (!self.taskId) {
        return;
    }
    QCloudGetCrossCopyTaskStatusRequest *req = [QCloudGetCrossCopyTaskStatusRequest new];
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

@end
