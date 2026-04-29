//
//  QCloudHTTPSessionManager+SMH.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/19.
//

#import "QCloudHTTPSessionManager+SMH.h"
#import "QCloudSMHBaseRequest.h"
#import <QCloudCore/QCloudCore.h>

// 声明私有方法，用于获取 task 对应的请求数据
@interface QCloudHTTPSessionManager (SMHPrivate)
- (id)taskDataForTask:(NSURLSessionTask *)task;
@end

@implementation QCloudHTTPSessionManager (SMH)

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    // 获取当前请求对象，判断是否需要禁止重定向跟随
    id taskData = [self taskDataForTask:task];
    QCloudHTTPRequest *httpRequest = [taskData valueForKey:@"httpRequest"];
    if ([httpRequest isKindOfClass:[QCloudSMHBaseRequest class]]) {
        QCloudSMHBaseRequest *smhRequest = (QCloudSMHBaseRequest *)httpRequest;
        if (smhRequest.disableRedirect) {
            // 禁止重定向跟随，将 302 响应直接返回给 response serializer 处理
            completionHandler(nil);
            return;
        }
    }
    // 默认跟随重定向（保持历史接口行为不变）
    completionHandler(request);
}

@end
