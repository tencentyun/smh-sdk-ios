//
//  QCloudCOSSMHDownloadObjectRequest.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/23.
//

#import "QCloudCOSSMHDownloadObjectRequest.h"
#import "QCloudSMHGetDownloadInfoRequest.h"
#import "QCloudSMHService.h"
#import <QCloudCore/NSMutableData+QCloud_CRC.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
@interface  QCloudCOSSMHDownloadObjectRequest()
//存储所有的下载请求
@property (nonatomic, strong) NSPointerArray *requestCacheArray;
@property (nonatomic, strong) dispatch_source_t queueSource;

@property (strong, nonatomic) NSString *resumableTaskFile;
@property (nonatomic, assign) int64_t localCacheDownloadOffset;

@property (nonatomic, assign) BOOL isRemove;
@end
  
@implementation QCloudCOSSMHDownloadObjectRequest
#pragma clang diagnostic pop
- (void)dealloc {
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.resumableDownload = YES;
    self.isRemove = NO;
    _requestCacheArray = [NSPointerArray weakObjectsPointerArray];
    return self;
}
- (void)fakeStart {
    
    if (!self.resumableDownload) {
        [self startGetObject];
        return;
    }
    
    if(!self.downloadingURL){
        NSError *error =  [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                                            message:@"InvalidArgument:您输入的downloadingURL不合法，请检查后使用！！"];
        if(self.finishBlock){
            self.finishBlock(nil, error);
            return;
        }
    }
    self.resumableTaskFile = [NSString stringWithFormat:@"%@.cosresumabletask",self.downloadingURL.relativePath];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.resumableTaskFile];
    if(jsonData){
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        NSArray *tasks = dic[@"downloadedBlocks"];
        self.localCacheDownloadOffset = [(NSString *)tasks.lastObject[@"to"] integerValue];
    }
    [self startGetObject];
}

    
- (void)startGetObject {
    QCloudSMHDownloadFileRequest *request = [QCloudSMHDownloadFileRequest new];
    request.libraryId = self.libraryId;
    request.spaceId = self.spaceId;
    request.spaceOrgId = self.spaceOrgId;
    request.filePath = self.filePath;
    request.historVersionId = self.historVersionId;
    request.localCacheDownloadOffset = self.localCacheDownloadOffset;
    request.downloadingURL = self.downloadingURL;
    request.userId = self.userId;
    __block int64_t currentTotalBytesDownload = self.localCacheDownloadOffset;
    __weak typeof(self) weakSelf = self;
    
    [request setResponseHeader:^(NSDictionary * _Nonnull header) {
        if (self.responseHeader) {
            self.responseHeader(header);
        }
        if (self.localCacheDownloadOffset > 0) {
            return;
        }
        
        if (!self.resumableDownload) {
            return;
        }
        
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.resumableTaskFile];
        if (!exist) {
           [[NSFileManager defaultManager] createFileAtPath:self.resumableTaskFile contents:[NSData data] attributes:nil];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:header[@"Content-Length"] forKey:@"size"];
            if (header[@"x-cos-hash-crc64ecma"]) {
                [dic setValue:header[@"x-cos-hash-crc64ecma"] forKey:@"crc64"];
            }
            NSError *parseError;
            if(dic){
                NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
                NSError *writeDataError;
                [info writeToFile:self.resumableTaskFile options:0 error:&writeDataError];
            }
           
        }else{
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.resumableTaskFile];
            if(jsonData){
                NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                
                //如果文件发生改变
                if(![dic[@"size"] isEqualToString:header[@"Content-Length"]] ||
                   (!header[@"x-cos-hash-crc64ecma"]||(header[@"x-cos-hash-crc64ecma"] && ![dic[@"crc64"] isEqualToString:header[@"x-cos-hash-crc64ecma"]]))){
                    QCloudRemoveFileByPath(self.resumableTaskFile);
                    [[NSFileManager defaultManager] createFileAtPath:self.resumableTaskFile contents:[NSData data] attributes:nil];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:header[@"Content-Length"] forKey:@"size"];
                    if (header[@"x-cos-hash-crc64ecma"]) {
                        [dic setValue:header[@"x-cos-hash-crc64ecma"] forKey:@"crc64"];
                    }
                     NSError *parseError;
                     NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
                     NSError *writeDataError;
                     [info writeToFile:self.resumableTaskFile options:0 error:&writeDataError];
                }
            }
        }
    }];
    
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        __strong typeof(weakSelf) strongSelf = self;
        currentTotalBytesDownload = totalBytesDownload + self.localCacheDownloadOffset;
        QCloudLogInfo(@"%@ downProcess %lld %lld %ld",self.filePath,bytesDownload,totalBytesDownload + self.localCacheDownloadOffset,totalBytesExpectedToDownload + self.localCacheDownloadOffset);
        if(strongSelf.downProcessBlock){
            strongSelf.downProcessBlock(bytesDownload, totalBytesDownload + self.localCacheDownloadOffset, totalBytesExpectedToDownload + self.localCacheDownloadOffset);
        }
    }];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = self;
        //如果下载失败了：保存当前的下载长度，便于下次续传
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.resumableTaskFile];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if(jsonData){
            dic = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] mutableCopy];
        }
      
        if (!strongSelf.resumableDownload) {
            if(strongSelf.finishBlock){
                strongSelf.finishBlock(outputObject, error);
            }
            return;
        }
        
        if(error){
            NSMutableArray *tasks = [dic[@"downloadedBlocks"] mutableCopy];
            if(!tasks){
                tasks = [NSMutableArray array];
            }
            NSString *fromStr = [NSString stringWithFormat:@"%lld",strongSelf.localCacheDownloadOffset];
            NSString *toStr = [NSString stringWithFormat:@"%lld",currentTotalBytesDownload];
            if (![fromStr isEqualToString:toStr]) {
                [tasks addObject:@{@"from":fromStr,@"to":toStr}];
            }
            [dic setValue: [tasks copy] forKey:@"downloadedBlocks"];
            NSError *parseError;
            NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
            NSError *writeDataError;
            if(info && !parseError){
                [info writeToFile:strongSelf.resumableTaskFile options:0 error:&writeDataError];
            }
            
            if(writeDataError){
                error = writeDataError;
            }
            if (error.code == QCloudNetworkErrorCodeCanceled && self.isRemove) {
                [self removeTempDownloadFile];
            }
            if(strongSelf.finishBlock && error.code != QCloudNetworkErrorCodeCanceled){
                strongSelf.finishBlock(outputObject, error);
            }
        }else{
            //下载完成之后如果没有crc64，删除记录文件
            if(!dic[@"crc64"]){
                QCloudRemoveFileByPath(strongSelf.resumableTaskFile);
                if(strongSelf.finishBlock){
                    strongSelf.finishBlock(outputObject, error);
                }
                return;
            }

            QCloudRemoveFileByPath(strongSelf.resumableTaskFile);
            if(strongSelf.enableCRC64Verification){
                //计算文件的CRC64
                NSInteger slice = 8 * 1024;
                uint64_t localCrc64 = 0;
                NSInteger fileSize = QCloudFileSize(strongSelf.downloadingURL.path);
                NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:strongSelf.downloadingURL.path];
                for (NSInteger offset = 0; offset < fileSize; offset += MIN(fileSize - offset, slice)) {
                    @autoreleasepool {
                        [handler seekToFileOffset:offset];
                        NSMutableData *data = [handler readDataOfLength:MIN(fileSize - offset, slice)].mutableCopy;
                        localCrc64 = [data qcloud_crc64ForCombineCRC1:localCrc64 CRC2:data.qcloud_crc64 length:data.length];
                    }
                }
                [handler closeFile];
                NSString *localCrc64Str = [NSString stringWithFormat:@"%llu",localCrc64];
                if (![localCrc64Str isEqualToString:dic[@"crc64"]]) {
                    //下载完成之后如果crc64不一致，删除记录文件和已经下载的文件，重新开始下载
                    QCloudRemoveFileByPath(strongSelf.downloadingURL.relativePath);
                    [strongSelf fakeStart];
                }else{
                    if(strongSelf.finishBlock){
                        strongSelf.finishBlock(outputObject, error);
                    }
                    
                }
            }else if(strongSelf.finishBlock){
                strongSelf.finishBlock(outputObject, error);
            }
        }
    }];
    request.enableQuic = self.enableQuic;
    
    [[QCloudSMHService defaultSMHService] downloadFile:request];
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
}

-(void)cancel{
    if (self.ownerQueue) {
        [self.ownerQueue cancelByRequestID:self.requestID];
    }
    
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)([NSObject new])];
    [self.requestCacheArray compact];
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }

    NSMutableArray *cancelledRequestIDs = [NSMutableArray array];
    NSPointerArray *tmpRequestCacheArray = [self.requestCacheArray copy];
    for (QCloudHTTPRequest *request in tmpRequestCacheArray) {
        if (request != nil) {
            [cancelledRequestIDs addObject:[NSNumber numberWithLongLong:request.requestID]];
            [request cancel];
        }
    }

    [[QCloudHTTPSessionManager shareClient] cancelRequestsWithID:cancelledRequestIDs];
    [super cancel];
}

- (void)remove{
    self.isRemove = YES;
    [self cancel];
}

/**
 * 移除下载的临时文件
 * 清理断点续传文件和已下载的文件
 */
- (void)removeTempDownloadFile {
    if(self.downloadingURL){
        self.resumableTaskFile = [NSString stringWithFormat:@"%@.cosresumabletask",self.downloadingURL.relativePath];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.resumableTaskFile];
        if (exist) {
            QCloudRemoveFileByPath(self.resumableTaskFile);
        }
            
    }
    QCloudRemoveFileByPath(self.downloadingURL.relativePath);
    
}

@end
