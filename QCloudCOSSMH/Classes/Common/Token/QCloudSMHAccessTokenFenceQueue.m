//
//  QCloudSMHFenceQueue.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/20.
//

#import "QCloudSMHAccessTokenFenceQueue.h"
#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHSpaceInfo.h"
#import "QCloudSMHBizRequest.h"
typedef void (^__QCloudSMHFenceActionBlock)(QCloudSMHSpaceInfo *, NSError *);


@interface QCloudSMHAccessTokenFenceQueue ()
@property (nonatomic, strong) NSMutableArray *actionCache;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (atomic, strong) NSTimer *rquestTimer;
@property (atomic, strong) NSDate *expritionDate;


@property (nonatomic,strong)NSMutableDictionary * spaceInfoPool;
@end

@implementation QCloudSMHAccessTokenFenceQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeout = 2 * 60;
        _lock = [NSRecursiveLock new];
        _spaceInfoPool = [NSMutableDictionary new];
        _actionCache = [NSMutableArray new];
    }
    return self;
}

- (BOOL)fenceDataVaild:(NSString *)spaceId {
    if (!spaceId) {
        return NO;
    }
    QCloudSMHSpaceInfo * spaceInfo = [self.spaceInfoPool objectForKey:spaceId];
    if (!spaceInfo || !spaceInfo.accessToken) {
        return NO;
    }
    NSDate *date = [NSDate date];
    double timeInstence = [date timeIntervalSince1970]-[spaceInfo.beginDate timeIntervalSince1970];
    // 提前60s刷新缓存
    if (timeInstence > spaceInfo.expiresIn.integerValue - 60) {
        return false;
    }
    return YES;
}

-(void)performRequest:(QCloudSMHBizRequest *)request withAction:(void (^ _Nullable)(QCloudSMHSpaceInfo *, NSError *))action{
    NSParameterAssert(action);
    if (!_delegate) {
        @throw
            [NSException exceptionWithName:@"com.qcloud.smh.com"
                                    reason:@"当前的QCloudCredentailFenceQueue的delegate为空，请设置之后在使用。如果不设置，将会导致程序线程死锁！！"
                                  userInfo:nil];
    }
    [_lock lock];
    if ([self fenceDataVaild:[self checkSpaceId:request.spaceId libraryId:request.libraryId]]) {
        QCloudSMHSpaceInfo * spaceInfo = [self.spaceInfoPool objectForKey:[self checkSpaceId:request.spaceId libraryId:request.libraryId]];
        action(spaceInfo, nil);
    } else {
        [_actionCache addObject:action];
        [self requestFenceData:request];
    }
    [_lock unlock];
}

- (void)onTimeout {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self invalidTimeoutTimter];
        NSError *error = [NSError qcloud_errorWithCode:10000 message:@"InvalidCredentials：获取签名错误"];
        [self postError:error];
    });
}

- (void)invalidTimeoutTimter {
    [self.rquestTimer invalidate];
    self.rquestTimer = nil;
}

- (void)requestFenceData:(QCloudSMHBizRequest *)request {
    if (self.rquestTimer) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeout]
                                              interval:0
                                                target:[QCloudWeakProxy proxyWithTarget:self]
                                              selector:@selector(onTimeout)
                                              userInfo:nil
                                               repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.rquestTimer = timer;
    [self.delegate fenceQueue:self request:request requestCreatorWithContinue:^(QCloudSMHSpaceInfo * _Nonnull spaceInfo, NSError * _Nonnull error) {
        [weakSelf recive:spaceInfo error:error];
    } ];
}

- (void)postError:(NSError *)error {
    [_lock lock];
    NSArray *actions = [_actionCache copy];
    [_actionCache removeAllObjects];
    [_lock unlock];
    for (__QCloudSMHFenceActionBlock action in actions) {
        action(nil, error);
    }
}

- (void)postCreator:(QCloudSMHSpaceInfo *)spaceInfo {
    [_lock lock];
    NSArray *actions = [_actionCache copy];
    [_actionCache removeAllObjects];
    [_lock unlock];
    for (__QCloudSMHFenceActionBlock action in actions) {
        action(spaceInfo, nil);
    }
}

// if If authentationCreator is not nil ,check the validity of the Date
- (void)recive:(QCloudSMHSpaceInfo *)spaceInfo error:(NSError *)error {
    [self invalidTimeoutTimter];
    
    if (spaceInfo.spaceId && spaceInfo.libraryId) {
        [_lock lock];
        spaceInfo.beginDate = [NSDate date];
        [self.spaceInfoPool setObject:spaceInfo forKey:[self checkSpaceId:spaceInfo.spaceId libraryId:spaceInfo.libraryId]];
        [_lock unlock];
    }
    
    if (error) {
        [self postError:error];
    } else if (spaceInfo.accessToken) {
        [self postCreator:spaceInfo];
    }
}

-(NSString *)checkSpaceId:(NSString *)spaceId libraryId:(NSString *)libraryId{
    
    if (!spaceId || !libraryId) {
        return nil;
    }
    return [libraryId stringByAppendingString:spaceId];
}

-(void)cleanAllAccesstoken{
    [self.spaceInfoPool removeAllObjects];
}
@end
