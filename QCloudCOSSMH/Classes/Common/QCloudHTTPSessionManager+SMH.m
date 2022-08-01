//
//  QCloudHTTPSessionManager+SMH.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/4/19.
//

#import "QCloudHTTPSessionManager+SMH.h"

@implementation QCloudHTTPSessionManager (SMH)

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(request);//取消重定向的请求
}

@end
