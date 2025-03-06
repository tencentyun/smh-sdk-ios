//
//  QCloudSMHGetRecyclePresignedURLRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudSMHGetRecyclePresignedURLRequest.h"
#import "QCloudURLHelper.h"
@implementation QCloudSMHGetRecyclePresignedURLRequest

-(NSURLRequest *)buildURLRequest:(NSError * _Nullable __autoreleasing *)error{
    __block NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] init];
    [mutableURLRequest setHTTPMethod:@"get"];

    NSString *URLString = [[NSMutableString alloc] initWithString:_serverDomain];
    
    NSString *api = @"api/v1/recycled";
    
    NSString *uriMethod = @"preview";
    
    URLString = [URLString stringByAppendingFormat:@"%@/%@/%@/%@?%@",api,self.libraryId,self.spaceId,self.recycledItemId,uriMethod];
    
    if(self.size){
        URLString=  [URLString stringByAppendingFormat:@"&size=%ld", self.size];
    }
    
    if(self.scale){
        URLString=  [URLString stringByAppendingFormat:@"&scale=%ld", self.scale];
    }
    
    if(self.heightSize){
        URLString=  [URLString stringByAppendingFormat:@"&height_size=%ld", self.heightSize];
    }
    
    if(self.widthSize){
        URLString=  [URLString stringByAppendingFormat:@"&width_size=%ld", self.widthSize];
    }
    
    if (self.frameNumber > 0) {
        URLString=  [URLString stringByAppendingFormat:@"&frame_number=%ld", self.frameNumber];
    }
    
    if (self.userId) {
        URLString =[URLString stringByAppendingFormat:@"&user_id=%@", self.userId];
    }
    
    if (self.historyId > 0) {
        URLString =[URLString stringByAppendingFormat:@"&history_id=%ld", self.historyId];
    }

    
    [mutableURLRequest setURL:[NSURL URLWithString:URLString]];
    if(!mutableURLRequest.URL){
        if (NULL != error) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"NSURLRequest:URL is invalid (nil), it must have some value. please check it"]];
        }
        return nil;
    }
    return mutableURLRequest;
}

- (void)setFinishBlock:(void (^ _Nullable)(NSString * _Nullable result , NSError * _Nullable error ))finishBlock{
    [super setFinishBlock:finishBlock];
}

@end

