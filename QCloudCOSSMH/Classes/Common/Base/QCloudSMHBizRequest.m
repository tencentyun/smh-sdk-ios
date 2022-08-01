//
//  QCloudSMHBizRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSpaceInfo.h"
@interface QCloudSMHBizRequest ()
@property(nonatomic,assign)NSInteger smh_semp_flag;
@property (nonatomic,strong,nullable)dispatch_semaphore_t smh_semaphore;
@end

@implementation QCloudSMHBizRequest

- (instancetype)init {
    self = [super initWithApiType:QCloudECDTargetAPIFile];
    if (!self) {
        return self;
        
    }
    return self;
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error{
    BOOL ret = [super buildRequestData:error];
    if (!ret) {
        return ret;
    }
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.libraryId) {
        [__pathComponents addObject:self.libraryId];
    }else{
        [__pathComponents addObject:@"emptyLibraryId"];
    }
    
    if (self.spaceId){
        [__pathComponents addObject:self.spaceId];
    }
    self.requestData.URIComponents = __pathComponents;
    if(self.userId){
        [self.requestData setQueryStringParamter:self.userId withKey:@"user_id"];
    }
   
    return YES;
}

-(BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    self.smh_semaphore = dispatch_semaphore_create(0);
    self.smh_semp_flag = 1;
    __block NSError *localError;
    __block BOOL isSigned;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.accessTokenProvider accessTokenWithRequest:self urlRequest:urlRequest compelete:^(QCloudSMHSpaceInfo *spaceInfo, NSError *error) {
            if (error) {
                localError = error;
            } else {
                if(spaceInfo.accessToken){
                    NSString *requestURLString = urlRequest.URL.absoluteString;
                    NSString *lastCh = [requestURLString substringFromIndex:requestURLString.length-1];
                    if([requestURLString containsString:@"?"]){
                        if([lastCh isEqualToString:@"?"]){
                            requestURLString = [requestURLString stringByAppendingFormat:@"access_token=%@", spaceInfo.accessToken];
                        }else{
                            requestURLString = [requestURLString stringByAppendingFormat:@"&access_token=%@", spaceInfo.accessToken];
                        }
                    }else{
                        requestURLString = [requestURLString stringByAppendingFormat:@"?access_token=%@", spaceInfo.accessToken];
                    }

                    if (spaceInfo.libraryId != nil) {
                        if (self.libraryId) {
                            requestURLString = [requestURLString stringByReplacingOccurrencesOfString:self.libraryId withString:spaceInfo.libraryId];
                        }else{
                            requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"emptyLibraryId" withString:spaceInfo.libraryId];
                        }
                    }
                    
                    urlRequest.URL = [NSURL URLWithString:requestURLString];
                    //重新生成url
                    isSigned = YES;
                    
                } else {
                    // null authorization
                }
            }
            dispatch_semaphore_signal(self.smh_semaphore);
            self.smh_semp_flag = 2;
        }];
    });
    
    if (self.smh_semp_flag == 1) {
        dispatch_semaphore_wait(self.smh_semaphore, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    }
    
    if (localError) {
        if (NULL != error) {
            *error = localError;
        }
        return NO;
    } else if (!isSigned) {
        if (NULL != error) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeCredentialNotReady
                      message:nil
                      infos:@{
                          @"Description" :
                              @"InvalidCredentials：获取令牌超时，请检查是否实现令牌回调，签名回调是否有调用,并且在最后是否有调用 ContinueBlock 传入签名"
                      }];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc{
    if (self.smh_semp_flag == 1) {
        dispatch_semaphore_signal(self.smh_semaphore);
    }
}
@end
