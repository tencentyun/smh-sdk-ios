//
//  QCloudCOSSMHUploadObjectRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/23.
//
//

#import "QCloudCOSSMHUploadObjectRequest.h"
#import "QCloudCOSSMHPutObjectRequest.h"
#import "QCloudCOSSMHUploadPartRequest.h"
#import "QCloudSMHMultipartInfo.h"
#import <QCloudCore/QCloudUniversalPath.h>
#import <QCloudCore/QCloudSandboxPath.h>
#import <QCloudCore/QCloudMediaPath.h>
#import <QCloudCore/QCloudBundlePath.h>
#import <QCloudCore/QCloudNetworkingAPI.h>
#import <QCloudCore/QCloudUniversalPathFactory.h>
#import <QCloudCore/QCloudSupervisoryRecord.h>
#import <QCloudCore/QCloudHTTPRetryHanlder.h>
#import "QualityDataUploader.h"
#import "QCloudSMHUploadStateInfo.h"
#import "QCloudSMHGetUploadStateRequest.h"
#import "QCloudSMHService.h"
#import "QCloudSMHPutObjectRequest.h"
#import "QCloudSMHCompleteUploadRequest.h"
#import "QCloudSMHUploadPartRequest.h"
#import "QCloudSMHInitUploadInfo.h"
#import "QCloudSMHConfirmInfo.h"
#import "QCloudSMHAbortMultipfartUploadRequest.h"
#import "QCloudSMHGetDownloadInfoRequest.h"
#import "QCloudSMHDownloadInfoModel.h"
#import "QCloudSMHQuickPutObjectRequest.h"
#import "NSData+SHA256.h"
#import "QCloudSMHContentInfo.h"
#import "QCloudSMHPutObjectRenewRequest.h"

static NSUInteger kQCloudCOSXMLUploadLengthLimit = 1 * 1024 * 1024;
static NSUInteger kQCloudCOSXMLUploadSliceLength = 1 * 1024 * 1024;
static NSUInteger kQCloudCOSXMLMD5Length = 32;


@interface QCloudCOSSMHUploadObjectRequest () <QCloudHttpRetryHandlerProtocol> {
    NSRecursiveLock *_recursiveLock;
    NSRecursiveLock *_progressLock;
    NSRecursiveLock *_HeadersLock;
    NSUInteger uploadedSize;
    //标记下标，从0开始
    NSUInteger startPartNumber;
    BOOL isChange;
    
}
@property (nonatomic, assign) int64_t totalBytesSent;
@property (nonatomic, assign) NSUInteger dataContentLength;
@property (nonatomic, strong) dispatch_source_t queueSource;
//存储所有的分片
@property (nonatomic, strong) NSMutableArray<QCloudSMHMultipartInfo *> *uploadParts;
@property (nonatomic, strong) NSPointerArray *requestCacheArray;
@property (strong, nonatomic) NSMutableArray *requstMetricArray;

@property (nonatomic,strong)QCloudSMHUploadStateInfo *existParts;

@property (nonatomic,strong)QCloudSMHInitUploadInfo *uploadInitInfo;
/// 不用续期
@property (nonatomic,strong)QCloudSMHInitUploadInfo *putInitInfo;

@property (nonatomic,strong)NSMutableDictionary * uploadHeaders;

@property (nonatomic, assign) NSInteger serverTimeOffset;

@end

@implementation QCloudCOSSMHUploadObjectRequest

- (void)dealloc {
    QCloudLogInfo(@"QCloudCOSSMHUploadObjectRequest = %@ dealloc", self);
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    self.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    _uploadBodyIsCompleted = YES;
    _requestCacheArray = [NSPointerArray weakObjectsPointerArray];
    _customHeaders = [NSMutableDictionary dictionary];
    _aborted = NO;
    _recursiveLock = [NSRecursiveLock new];
    _progressLock = [NSRecursiveLock new];
    _HeadersLock = [NSRecursiveLock new];
    _requstMetricArray = [NSMutableArray array];
    _mutilThreshold = kQCloudCOSXMLUploadLengthLimit;
    _retryHandler = [QCloudHTTPRetryHanlder defaultRetryHandler];
    startPartNumber = -1;
    self.uploadHeaders = [NSMutableDictionary new];
    self.priority = QCloudAbstractRequestPriorityNormal;
    return self;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *dict = [dictionary mutableCopy];
    if ([dictionary valueForKey:@"body"]) {
        NSDictionary *universalPathDict = [dictionary valueForKey:@"body"];
        QCloudUniversalPathType type = [[universalPathDict valueForKey:@"type"] integerValue];
        NSString *originURL = [universalPathDict valueForKey:@"originURL"];
        QCloudUniversalPath *path;
        switch (type) {
            case QCLOUD_UNIVERSAL_PATH_TYPE_FIXED:
                path = [[QCloudUniversalFixedPath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_ADJUSTABLE:
                path = [[QCloudUniversalAdjustablePath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_SANDBOX:
                path = [[QCloudSandboxPath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_BUNDLE:
                path = [[QCloudBundlePath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_MEDIA:
                path = [[QCloudMediaPath alloc] initWithStrippedURL:originURL];
                break;
            default:
                break;
        }
        [dict setValue:path forKey:@"body"];
    }

    return [dict copy];
}

- (void)continueMultiUpload:(QCloudSMHUploadStateInfo *)existParts {
    self.existParts = existParts;
    _uploadParts = [NSMutableArray new];
    NSArray *allParts = [self getFileLocalUploadParts];
    NSMutableDictionary *existMap = [NSMutableDictionary new];
    for (QCloudSMHUploadStatePartsInfo *part in existParts.parts) {
        [existMap setObject:part forKey:part.PartNumber];
    }
    QCloudLogDebug(@"SERVER EXIST PARTS %@", [existParts qcloud_modelToJSONString]);

    NSMutableArray *restParts = [NSMutableArray new];
    for (QCloudFileOffsetBody *offsetBody in allParts) {
        NSString *key = [@(offsetBody.index + 1) stringValue];
        QCloudSMHUploadStatePartsInfo *part = [existMap objectForKey:key];

        if (!part) {
            [restParts addObject:offsetBody];
        } else {
            if ([part.Size integerValue] != offsetBody.sliceLength) {
                isChange = YES;
                break;
            }
            QCloudSMHMultipartInfo *info = [QCloudSMHMultipartInfo new];
            info.eTag = part.ETag;
            info.partNumber = part.PartNumber;
            [_uploadParts addObject:info];
        }
    }

    if (!isChange) {
        if (restParts.count == 0) {
            [self finishUpload];
        } else {
            [self uploadOffsetBodys:restParts];
        }
    } else {
        //重新分片
        [self getContinueInfo:existParts.parts];
        if (uploadedSize == self.dataContentLength) {
            [self finishUpload];
        } else {
            //开始分片
            [self uploadOffsetBodys:[self getFileLocalUploadParts]];
        }
    }
}

- (void)getContinueInfo:(NSArray *)existParts {
    _uploadParts = [NSMutableArray new];
    QCloudSMHUploadStatePartsInfo *part = existParts[0];
    if ([part.PartNumber integerValue] != 1) {
        return;
    }

    for (int i = 0; i < existParts.count; i++) {
        QCloudSMHUploadStatePartsInfo *part1 = existParts[i];
        QCloudSMHMultipartInfo *info1 = [QCloudSMHMultipartInfo new];
        info1.eTag = part1.ETag;
        info1.partNumber = part1.PartNumber;
        uploadedSize += [part1.Size integerValue];
        [_uploadParts addObject:info1];
        if (i == existParts.count - 1) {
            break;
        }
        QCloudSMHUploadStatePartsInfo *part2 = existParts[i + 1];
        if (([part1.PartNumber integerValue] + 1) != [part2.PartNumber integerValue]) {
            break;
        }
    }
    startPartNumber = _uploadParts.count;

    QCloudLogDebug(@"resume startPartNumber =   offset =  %ld %ld", startPartNumber, uploadedSize);
}

- (void)resumeUpload {
    QCloudSMHGetUploadStateRequest *request = [QCloudSMHGetUploadStateRequest new];
    request.timeoutInterval = self.timeoutInterval;
    request.enableQuic = self.enableQuic;
    request.userId = self.userId;
    request.libraryId = self.libraryId;
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.spaceOrgId = self.spaceOrgId;
    request.spaceId = self.spaceId;
    request.confirmKey = self.confirmKey;
    request.retryPolicy.delegate = self;
    request.priority = self.priority;
    __weak typeof(request) weakRequest = request;
    __weak typeof(self) weakSelf = self;
    
    [request setFinishBlock:^(QCloudSMHUploadStateInfo * _Nullable result, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf onError:error];
            return;
        }
        self.serverTimeOffset = [self getServerTimeOffsetWithLocal:[result __originHTTPURLResponse__]];
        if (result.parts.count == 0 || ([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPublicCloud && result.uploadPartInfo == nil)) {
            
            [self startMultiUpload];
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakRequest) strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject:@ { [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];
        [self syncGetUploadHeaderIndex:result.parts.lastObject.PartNumber.integerValue + 1];
        [weakSelf continueMultiUpload:result];
    }];
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(request)];
    [[QCloudSMHService defaultSMHService] getUploadStateInfo:request];

}
- (void)fakeStart {
    [self.benchMarkMan benginWithKey:kTaskTookTime];

    self.totalBytesSent = 0;

    if ([self.body isKindOfClass:[NSData class]]) {
        [self startSimpleUpload];
    } else if ([self.body isKindOfClass:[NSURL class]]) {
        NSURL *url = (NSURL *)self.body;
        if (!QCloudFileExist(url.relativePath)) {
            NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"指定的上传路径不存在"];
            [self onError:error];
            [self cancel];
            return;
        }
        self.dataContentLength = QCloudFileSize(url.path);
        if(_mutilThreshold<kQCloudCOSXMLUploadLengthLimit){

            NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"分块接口的阈值不能小于 1MB ，当前阈值为 %ld"];
            [self onError:error];
            [self cancel];
            return;
        }
        if (self.dataContentLength >= _mutilThreshold) {
            //开始分片上传的时候，上传的起始位置是0
            uploadedSize = 0;
            startPartNumber = 0;
            [self startQuickUpload];
        } else {
            [self startSimpleUpload];
        }
    } else {

        NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"不支持设置该类型的body，支持的类型为NSData、QCloudFileOffsetBody"];
        [self onError:error];
        [self cancel];
        return;
    }
}
- (void)startSimpleUpload {
    
    QCloudSMHPutObjectRequest * putRequest = [[QCloudSMHPutObjectRequest alloc]init];
    putRequest.libraryId = self.libraryId;
    putRequest.priority = self.priority;
    putRequest.spaceId = self.spaceId;
    putRequest.spaceOrgId = self.spaceOrgId;
    putRequest.userId = self.userId;
    putRequest.filePath = self.uploadPath;
    putRequest.conflictStrategy = self.conflictStrategy;
    putRequest.fileSize = @([self getFileSize]).stringValue;
    __weak typeof(putRequest) weakRequest = putRequest;
    __weak typeof(self) weakSelf = self;
    [putRequest setFinishBlock:^(QCloudSMHInitUploadInfo * _Nullable info, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakRequest) strongRequst = weakRequest;
        [weakSelf.requstMetricArray addObject:@{ [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];
        if (error) {
            [weakSelf onError:error];
            return;
        }
        
        if (self.getConfirmKey) {
            self.getConfirmKey(info.confirmKey);
        }
        [strongSelf startSimpleCOSUpload:info];
    }];
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(putRequest)];
    [[QCloudSMHService defaultSMHService] smhPutObject:putRequest];
}

-(void)startSimpleCOSUpload:(QCloudSMHInitUploadInfo *)info{
    
    self.putInitInfo = info;
    QCloudCOSSMHPutObjectRequest *request = [QCloudCOSSMHPutObjectRequest new];
    request.priority = self.priority;
    request.enableQuic = self.enableQuic;
    request.domain = [NSString stringWithFormat:@"%@://%@",QCloudSMHBaseRequest.isHttps?@"https":@"http",info.domain];
    request.customHeaders = info.headers.mutableCopy;
    request.path = [self encodeSuffix:info.path];
    __weak typeof(self) weakSelf = self;
    __weak typeof(request) weakRequest = request;
    request.retryPolicy.delegate = self;
    request.timeoutInterval = self.timeoutInterval;
    request.finishBlock = ^(id outputObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakRequest) strongRequst = weakRequest;
        [weakSelf.requstMetricArray addObject:@{ [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];
        if (strongSelf.requstsMetricArrayBlock) {
            strongSelf.requstsMetricArrayBlock(weakSelf.requstMetricArray);
        }
        if (error) {
            [weakSelf onError:error];
            [strongSelf cancel];
        } else {
            
            QCloudSMHCompleteUploadRequest * complete = [QCloudSMHCompleteUploadRequest new];
            complete.libraryId = strongSelf.libraryId;
            complete.spaceId = strongSelf.spaceId;
            complete.userId = strongSelf.userId;
            complete.spaceOrgId = self.spaceOrgId;
            complete.conflictStrategy = self.conflictStrategy;
            if (self.putInitInfo) {
                complete.confirmKey = strongSelf.putInitInfo.confirmKey;
            }
            
            __weak typeof(complete) weakRequest = complete;
            __weak typeof(self) weakSelf = self;
            [complete setFinishBlock:^(QCloudSMHContentInfo * _Nullable info, NSError * _Nullable error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                __strong typeof(weakRequest) strongRequst = weakRequest;
                [strongSelf.requstMetricArray addObject:@ { [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];

                if (self.requstsMetricArrayBlock) {
                    self.requstsMetricArrayBlock(weakSelf.requstMetricArray);
                }
                
                
                
                if (error) {
                    [weakSelf onError:error];
                } else {

                    [weakSelf onSuccess:info];
                }
            }];
            [[QCloudSMHService defaultSMHService] complelteUploadPartObject:complete];
            
            
            [strongSelf.requestCacheArray addPointer:(__bridge void *_Nullable)(complete)];
        }
    };
    
    request.body = self.body;
    request.sendProcessBlock = self.sendProcessBlock;
    request.delegate = self.delegate;
    request.retryPolicy.delegate = self;
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
    [[QCloudSMHService defaultSMHService] putObject:request];
}

-(void)startQuickUpload{
    
    NSURL * bodyURL = (NSURL *)self.body;
    
    NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:bodyURL.path];
    NSData *data = [handler readDataOfLength:kQCloudCOSXMLUploadSliceLength];
    uint8_t * beginningHash = [data qcloudSha256Bytes];
    NSString *beginningHashString = [NSData qcloudSha256BytesTostring:beginningHash];
    if(self.previewSendProcessBlock != nil){
        self.previewSendProcessBlock(kQCloudCOSXMLUploadSliceLength, self.dataContentLength,YES);
    }
    QCloudSMHQuickPutObjectRequest * request = [QCloudSMHQuickPutObjectRequest new];
    request.createionDate = [self createDate];
    request.libraryId = self.libraryId;
    request.priority = self.priority;
    request.conflictStrategy = self.conflictStrategy;
    request.spaceId = self.spaceId;
    request.spaceOrgId = self.spaceOrgId;
    request.userId = self.userId;
    request.filePath = self.uploadPath;
    request.beginningHash = beginningHashString;
    request.size = @(self.dataContentLength).stringValue;
    request.finishBlock = ^(id outputObject, NSError *error) {
        [handler closeFile];
        if (error) {
            if(self.finishBlock){
                self.finishBlock(outputObject, error);
            }
            return;
        }
        // 上传过，开始秒传
        NSInteger code = [outputObject __originHTTPURLResponse__].statusCode;
        if (code == 202) {
            [self continueQuickUpload:beginningHash beginString:beginningHashString];
        }else{
            if (self.confirmKey) {
                [self resumeUpload];
            }else{
                /// 普通分块上传
                [self startMultiUpload];
            }
        }
    };
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
    [[QCloudSMHService defaultSMHService] smhQuickPutObject:request];
}

-(void)continueQuickUpload:(uint8_t *)beginningHash beginString:(NSString *)beginningHashString{
    
    NSURL * bodyURL = (NSURL *)self.body;
    NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:bodyURL.path];
    uint8_t * fullHash = beginningHash;
    for (NSInteger i = kQCloudCOSXMLUploadSliceLength; i < self.dataContentLength; i += kQCloudCOSXMLUploadSliceLength) {
        if(self.canceled){
            break;
        }
        @autoreleasepool {
            [handler seekToFileOffset:i];
            NSData *data = [handler readDataOfLength:MIN(kQCloudCOSXMLUploadSliceLength, self.dataContentLength - i)];
            NSMutableData * mdata = [NSMutableData dataWithBytes:fullHash length:32];
            [mdata appendData:data];
            fullHash = [mdata qcloudSha256Bytes];
        }
        if(self.previewSendProcessBlock != nil){
            self.previewSendProcessBlock(MIN(i,self.dataContentLength ), self.dataContentLength,NO);
        }
    }
    QCloudSMHQuickPutObjectRequest * request = [QCloudSMHQuickPutObjectRequest new];
    request.createionDate = [self createDate];
    request.libraryId = self.libraryId;
    request.priority = self.priority;
    request.conflictStrategy = self.conflictStrategy;
    request.spaceId = self.spaceId;
    request.spaceOrgId = self.spaceOrgId;
    request.userId = self.userId;
    request.filePath = self.uploadPath;
    request.beginningHash = beginningHashString;
    request.fullHash = [NSData qcloudSha256BytesTostring:fullHash];
    request.size = @(self.dataContentLength).stringValue;
    request.finishBlock = ^(id outputObject, NSError *error) {
        [handler closeFile];
        if (error) {
            if(self.finishBlock){
                self.finishBlock(outputObject, error);
            }
            return;
        }
        // 秒传成功
        NSInteger code = [outputObject __originHTTPURLResponse__].statusCode;
        if (code == 200 && outputObject[@"data"]) {
            
            NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:outputObject[@"data"] options:NSJSONReadingFragmentsAllowed error:nil];
            QCloudSMHContentInfo * info = QCloudSMHContentInfo.new;
            [info qcloud_modelSetWithDictionary:infoDic];
            info.isQuickUpload = YES;
            if (self.finishBlock) {
                self.finishBlock(info, error);
            }
        }else{
            [self startMultiUpload];
        }
    };
    [[QCloudSMHService defaultSMHService ] smhQuickPutObject:request];
}

-(NSString *)createDate{
    NSISO8601DateFormatter *isoFormatter = [[NSISO8601DateFormatter alloc] init];
    isoFormatter.formatOptions = NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithFractionalSeconds;
    NSDate *currentDate = [NSDate date];
    NSString *iso8601String = [isoFormatter stringFromDate:currentDate];
    return iso8601String;
}

-(NSInteger)getFileSize{
    if ([self.body isKindOfClass:[NSData class]]) {
        return ((NSData *)self.body).length;
    }else if ([self.body isKindOfClass:[NSURL class]]){
        NSURL *url = (NSURL *)self.body;
        return QCloudFileSize(url.relativePath);
    }
    return 0;
}

- (void)startMultiUpload {
    _uploadParts = [NSMutableArray new];
    QCloudSMHUploadPartRequest *uploadRequet = [QCloudSMHUploadPartRequest new];
    uploadRequet.libraryId = self.libraryId;
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        uploadRequet.partNumberRange = @"1-100";
    }
    uploadRequet.fileSize = @([self getFileSize]).stringValue;
    uploadRequet.spaceId = self.spaceId;
    uploadRequet.filePath = self.uploadPath;
    uploadRequet.spaceOrgId = self.spaceOrgId;
    uploadRequet.conflictStrategy = self.conflictStrategy;
    uploadRequet.priority = QCloudAbstractRequestPriorityNormal;
    uploadRequet.retryPolicy.delegate = self;
    __weak typeof(uploadRequet) weakRequest = uploadRequet;
    __weak typeof(self) weakSelf = self;
    [uploadRequet setFinishBlock:^(QCloudSMHInitUploadInfo * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakRequest) strongRequst = weakRequest;
        
        @synchronized (self) {
            [strongSelf.requstMetricArray addObject:@ { [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];
        }
        
        if (error) {
            [weakSelf onError:error];
        } else {
            self.serverTimeOffset = [self getServerTimeOffsetWithLocal:[result __originHTTPURLResponse__]];
            if (self.getConfirmKey) {
                self.getConfirmKey(result.confirmKey);
            }
            if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
                [self.uploadHeaders setObject:result forKey:@"1-100"];
            }else{
                self.uploadInitInfo = result;
            }
            
            [weakSelf uploadMultiParts];
        }
    }];


    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(uploadRequet)];
    [[QCloudSMHService defaultSMHService] smhStartPartUpload:uploadRequet];
}

- (NSArray<QCloudFileOffsetBody *> *)getFileLocalUploadParts {
    NSMutableArray *allParts = [NSMutableArray new];
    if (self.canceled) {
        return nil;
    }
    NSURL *url = (NSURL *)self.body;
    if([self.body isKindOfClass:NSURL.class]){
        self.dataContentLength = QCloudFileSize(url.relativePath);
    }
    int64_t restContentLength = self.dataContentLength - uploadedSize;
    //便宜的起始位置
    int64_t offset = uploadedSize;
    for (NSInteger i = startPartNumber;; i++) {
        int64_t slice = 0;
        NSUInteger maxSlice = ceil(self.dataContentLength * 1.0 / (10000));
        NSUInteger uploadSliceLength = self.sliceSize > 10 ? self.sliceSize : kQCloudCOSXMLUploadSliceLength;
        uploadSliceLength = self.dataContentLength * 1.0 / uploadSliceLength > 10000 ? maxSlice : uploadSliceLength;
        if (restContentLength >= uploadSliceLength) {
            slice = uploadSliceLength;
        } else {
            slice = restContentLength;
        }
        if (!_uploadBodyIsCompleted && slice < kQCloudCOSXMLUploadSliceLength) {
            break;
        }
        QCloudFileOffsetBody *body = [[QCloudFileOffsetBody alloc] initWithFile:url offset:offset slice:slice];
        [allParts addObject:body];
        offset += slice;
        body.index = i;
        restContentLength -= slice;
        if (restContentLength <= 0) {
            break;
        }
    }

    return allParts;
}

- (void)appendUploadBytesSent:(int64_t)bytesSent {
    [_progressLock lock];
    _totalBytesSent += bytesSent;
    [self notifySendProgressBytesSend:bytesSent totalBytesSend:_totalBytesSent totalBytesExpectedToSend:_dataContentLength];
    [_progressLock unlock];
}

- (void)uploadOffsetBodys:(NSArray<QCloudFileOffsetBody *> *)allParts {
    // rest already upload size
    int64_t totalTempBytesSend = 0;
    for (QCloudFileOffsetBody *body in allParts) {
        totalTempBytesSend += body.sliceLength;
    }
    _totalBytesSent = _dataContentLength - totalTempBytesSend;
    [self.benchMarkMan directSetValue:@(totalTempBytesSend) forKey:kTotalSize];
    //
    __weak typeof(self) weakSelf = self;
    _queueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    __block int totalComplete = 0;
    dispatch_source_set_event_handler(_queueSource, ^{
        NSUInteger value = dispatch_source_get_data(weakSelf.queueSource);
        @synchronized(weakSelf) {
            totalComplete += value;
        }
        if (totalComplete == allParts.count) {
            if (NULL != weakSelf.queueSource) {
                dispatch_source_cancel(weakSelf.queueSource);
            }
            [weakSelf finishUpload];
        }
    });
    dispatch_resume(_queueSource);
    for (int i = 0; i < allParts.count; i++) {
        __block QCloudFileOffsetBody *body = allParts[i];

        //如果自身被取消，终止c创建新的uploadPartRequest
        if (self.canceled) {
            QCloudLogDebug(@"请求被取消，终止创建新的uploadPartRequest");
            break;
        }
        QCloudCOSSMHUploadPartRequest *request = [QCloudCOSSMHUploadPartRequest new];
        request.enableQuic = self.enableQuic;
        request.priority = QCloudAbstractRequestPriorityNormal;
        request.timeoutInterval = self.timeoutInterval;
        request.partNumber = (int)body.index + 1;
        request.uploadId = [self uploadIdWithIndex:body.index + 1];
        request.body = body;
        request.domain = [self getUploadDomain];
        request.path = [self encodeSuffix:[self getSMHUploadPath]];
        __weak typeof(request) weakRequest = request;
        request.renewUploadInfo = ^NSMutableDictionary * _Nullable{
            return [self getHeaderWithIndex:weakRequest.partNumber].mutableCopy;
        };
        request.retryPolicy.delegate = self;
        
        __block int64_t partBytesSent = 0;
        int64_t partSize = body.sliceLength;
        [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            int64_t restSize = totalBytesExpectedToSend - partSize;
            if (restSize - partBytesSent <= 0) {
                [weakSelf appendUploadBytesSent:bytesSent];
            } else {
                partBytesSent += bytesSent;
                if (restSize - partBytesSent <= 0) {
                    [weakSelf appendUploadBytesSent:partBytesSent - restSize];
                }
            }
        }];
        [request setFinishBlock:^(QCloudSMHUploadPartResult *outputObject, NSError *error) {
            QCloudLogInfo(@"收到一个part  %d的响应 %@", (i + 1), outputObject.eTag);
            if (!weakSelf) {
                return;
            }
            
            if (outputObject) {
                self.serverTimeOffset = [self getServerTimeOffsetWithLocal:outputObject.__originHTTPURLResponse__];
            }
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakRequest) strongRequst = weakRequest;
            @synchronized (self) {
                [weakSelf.requstMetricArray addObject:@{ [NSString stringWithFormat:@"%@", weakRequest] : weakRequest.benchMarkMan.tastMetrics }];
            }
            if (error && error.code != QCloudNetworkErrorCodeCanceled) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [weakSelf onError:error];
                if (!self.canceled) {
                    [strongSelf cancel];
                }
            } else {
                if (self.enableVerification) {
                    if (outputObject.eTag.length == (kQCloudCOSXMLMD5Length + 2)) {
                        NSString *MD5FromeETag = [outputObject.eTag substringWithRange:NSMakeRange(1, outputObject.eTag.length - 2)];
                        NSString *localMD5String = [QCloudEncrytFileOffsetMD5(body.fileURL.path, body.offset, body.sliceLength) lowercaseString];
                        if (![MD5FromeETag isEqualToString:localMD5String]) {
                            NSMutableString *errorMessageString = [[NSMutableString alloc] init];
                            [errorMessageString
                                appendFormat:@"DataIntegrityError分片:上传过程中MD5校验与本地不一致，请检查本地文件在上传过程中是否发生了变化,"
                                             @"建议调用删除接口将COS上的文件删除并重新上传,本地计算的 MD5 值:%@, 返回的 ETag值:%@",
                                             localMD5String, MD5FromeETag];
                            if ([outputObject __originHTTPURLResponse__] &&
                                [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"] != nil) {
                                NSString *requestID = [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"];
                                [errorMessageString appendFormat:@", Request id:%@", requestID];
                            }
                            NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeNotMatch message:errorMessageString];
                    
                            [weakSelf onError:error];
                            [weakSelf cancel];
                            return;
                        }
                    }
                }

                QCloudSMHMultipartInfo *info = [QCloudSMHMultipartInfo new];
                info.eTag = outputObject.eTag;
                info.partNumber = [@(body.index + 1) stringValue];
                [weakSelf markPartFinish:info];
                dispatch_source_merge_data(weakSelf.queueSource, 1);
            }
        }];

        [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
        [[QCloudSMHService defaultSMHService] uploadPartObject:request];
    }
}

- (void)uploadMultiParts{
    NSArray *allParts = [self getFileLocalUploadParts];
  
    [self uploadOffsetBodys:allParts];
    
}

- (void)markPartFinish:(QCloudSMHMultipartInfo *)info {
    if (!info) {
        return;
    }
    [_recursiveLock lock];
    [_uploadParts addObject:info];
    [_recursiveLock unlock];
}

- (void)onError:(NSError *)error {
    [super onError:error];
}

- (void)finishUpload{
    
    if(self.canceled){
        return;
    }
    if(!self.uploadBodyIsCompleted){
        NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeImCompleteData
                                               message:@"DataIntegrityError分片:文件大小与原始文件大小不一致，请检查文件在上传的过程中是否发生改变"];
        [self onError:error];
        return;
    }
    
    QCloudSMHCompleteUploadRequest * complete = [QCloudSMHCompleteUploadRequest new];
    complete.libraryId = self.libraryId;
    complete.spaceId = self.spaceId;
    complete.spaceOrgId = self.spaceOrgId;
    complete.userId = self.userId;
    complete.priority = QCloudAbstractRequestPriorityHigh;
    complete.conflictStrategy = self.conflictStrategy;
    
    if (self.confirmKey) {
        complete.confirmKey = self.confirmKey;
    }else{
        if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
            QCloudSMHInitUploadInfo * partInfo = self.uploadHeaders.allValues.lastObject;
            complete.confirmKey = partInfo.confirmKey;
        }else{
            complete.confirmKey = self.uploadInitInfo.confirmKey;
        }
        
    }
    
    __weak typeof(complete) weakRequest = complete;
    __weak typeof(self) weakSelf = self;
    [complete setFinishBlock:^(QCloudSMHContentInfo * _Nullable info, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakRequest) strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject:@ { [NSString stringWithFormat:@"%@", strongRequst] : weakRequest.benchMarkMan.tastMetrics }];

        if (self.requstsMetricArrayBlock) {
            self.requstsMetricArrayBlock(weakSelf.requstMetricArray);
        }

        if (error) {
            [weakSelf onError:error];
        } else {
            [weakSelf onSuccess:info];
        }
    }];
    [[QCloudSMHService defaultSMHService] complelteUploadPartObject:complete];
    
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(complete)];
}

- (void)cancel {
    
    if (self.ownerQueue) {
        [self.ownerQueue cancelByRequestID:self.requestID];
    }
    @synchronized (self) {
        [self.requestCacheArray addPointer:(__bridge void *_Nullable)([NSObject new])];
        [self.requestCacheArray compact];
    }
    
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }

    NSMutableArray *cancelledRequestIDs = [NSMutableArray array];
    NSPointerArray *tmpRequestCacheArray = [self.requestCacheArray copy];
    for (QCloudHTTPRequest *request in tmpRequestCacheArray) {
        if (request != nil) {
            [cancelledRequestIDs addObject:[NSNumber numberWithLongLong:request.requestID]];
        }
    }

    [[QCloudHTTPSessionManager shareClient] cancelRequestsWithID:cancelledRequestIDs];
    
    [super cancel];
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[ @"delegate" ];
}

- (void)abort:(QCloudRequestFinishBlock _Nullable)finishBlock {
    if (self.finished && !self.canceled) {
        NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorUnsupportOperationError message:@"取消失败，任务已经完成"];
        if (finishBlock) {
            finishBlock(nil, error);
        }
    } else {
        if (self.confirmKey) {
            
            QCloudSMHAbortMultipfartUploadRequest * deleteRequest = [QCloudSMHAbortMultipfartUploadRequest new];
            deleteRequest.priority = QCloudAbstractRequestPriorityHigh;
            deleteRequest.libraryId = self.libraryId;
            deleteRequest.userId = self.userId;
            deleteRequest.spaceId = self.spaceId;
            deleteRequest.spaceOrgId = self.spaceOrgId;
            deleteRequest.confirmKey = self.confirmKey;
            deleteRequest.finishBlock = finishBlock;
            deleteRequest.timeoutInterval = self.timeoutInterval;
            [[QCloudSMHService defaultSMHService] deleteUploadPartObject:deleteRequest];
            self.existParts = nil;
        } else {
            if (finishBlock) {
                finishBlock(@{}, nil);
            }
        }
    }
    _aborted = YES;
    [self cancel];
}

- (BOOL)shouldRetry:(QCloudURLSessionTaskData *)task error:(NSError *)error {
    if ([self.retryHandler.delegate respondsToSelector:@selector(shouldRetry:error:)]) {
        return [self.retryHandler.delegate shouldRetry:task error:error];
    }
    return YES;
}

-(NSString *)getUploadDomain{
    
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        QCloudSMHInitUploadInfo * partInfo = self.uploadHeaders.allValues.firstObject;
        return [NSString stringWithFormat:@"%@://%@",QCloudSMHBaseRequest.isHttps?@"https":@"http",partInfo.domain];
    }else{
        if (self.existParts != nil) {
            return [NSString stringWithFormat:@"https://%@",self.existParts.uploadPartInfo.domain];
        }else if(self.uploadInitInfo != nil){
            return [NSString stringWithFormat:@"https://%@",self.uploadInitInfo.domain];
        }else{
            return nil;
        }
    }
}

-(NSString *)getSMHUploadPath{
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        QCloudSMHInitUploadInfo * partInfo = self.uploadHeaders.allValues.firstObject;
        return partInfo.path;
    }else{
        if (self.existParts != nil) {
            return self.existParts.uploadPartInfo.path;
        }else if(self.uploadInitInfo != nil){
            return self.uploadInitInfo.path;
        }else{
            return nil;
        }
    }
}

-(NSString *)uploadIdWithIndex:(NSInteger)index{
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        QCloudSMHInitUploadInfo * partInfo = self.uploadHeaders.allValues.firstObject;
        return partInfo.uploadId;
    }else{
        if (self.existParts != nil) {
            return self.existParts.uploadPartInfo.uploadId;
        }else if(self.uploadInitInfo != nil){
            return self.uploadInitInfo.uploadId;
        }else{
            return nil;
        }

    }
    
}

-(NSDictionary *)getHeaderWithIndex:(NSInteger)index{
    
    QCloudSMHInitUploadInfo * partInfo;
    NSDictionary * header;
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        for (NSString * key in self.uploadHeaders.allKeys) {
            NSArray * num = [key componentsSeparatedByString:@"-"];
            if([num.firstObject integerValue] <= index && [num.lastObject integerValue] >= index){
                partInfo = self.uploadHeaders[key];
                header = [partInfo.parts objectForKey:@(index).stringValue];
            }
        }
    }else{
        if(self.existParts){
            header = self.existParts.uploadPartInfo.headers;
            partInfo = self.existParts.uploadPartInfo;
        }else if(self.uploadInitInfo){
            header = self.uploadInitInfo.headers;
            partInfo = self.uploadInitInfo;
        }
        
    }
    
    if(header != nil){
        [self refeshUploadInfo:partInfo withIndex:index];
    }else{
        if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
            header = [self syncGetUploadHeaderIndex:index];
        }
    }
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        if(header[@"headers"]){
            return header[@"headers"];
        }
    }else{
        return header;
    }
    return nil;
}

- (NSDictionary *)syncGetUploadHeaderIndex:(NSInteger)index{
    NSString * partRange = [NSString stringWithFormat:@"%ld-%ld",100 * ((index - 1) / 100) + 1,100 * (((index - 1) / 100) + 1)] ;
    __block QCloudSMHInitUploadInfo * uploadInfo;
    
    if(![self.uploadHeaders objectForKey:partRange]){
        
        dispatch_semaphore_t semp = dispatch_semaphore_create(0);
        
        QCloudSMHPutObjectRenewRequest *request = [[QCloudSMHPutObjectRenewRequest alloc] init];
        if (self.confirmKey) {
            request.confirmKey = self.confirmKey;
        }else{
            QCloudSMHInitUploadInfo * partInfo = self.uploadHeaders.allValues.lastObject;
            request.confirmKey = partInfo.confirmKey;
        }
        request.partNumberRange = partRange;
        request.priority = QCloudAbstractRequestPriorityHigh;
        request.libraryId = self.libraryId;
        request.spaceId = self.spaceId;
        request.userId = self.userId;
        __weak typeof(self) weakSelf = self;
        [request setFinishBlock:^(QCloudSMHInitUploadInfo *_Nullable result, NSError *_Nullable error) {
            if (error) {
                [weakSelf onError:error];
            } else {
                weakSelf.serverTimeOffset = [self getServerTimeOffsetWithLocal:[result __originHTTPURLResponse__]];
                uploadInfo = result;
            }
            dispatch_semaphore_signal(semp);
        }];
        [[QCloudSMHService defaultSMHService] renewUploadInfo:request];
        
        dispatch_semaphore_wait(semp, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    }

    if(uploadInfo){
        if(![self.uploadHeaders objectForKey:partRange]){
            [_HeadersLock tryLock];
            [self.uploadHeaders setObject:uploadInfo forKey:partRange];
            [_HeadersLock unlock];
        }
    }
    uploadInfo = [self.uploadHeaders objectForKey:partRange];
    return uploadInfo.parts[@(index).stringValue];
}

- (void)refeshUploadInfo:(QCloudSMHInitUploadInfo *)partInfo withIndex:(NSInteger)index{

    if (![partInfo shouldRefreshWithOffest:self.serverTimeOffset]) {
        return;
    }
    NSString * partRange = [NSString stringWithFormat:@"%ld-%ld",100 * ((index - 1) / 100) + 1,100 * (((index - 1) / 100) + 1)];
    QCloudSMHPutObjectRenewRequest *request = [[QCloudSMHPutObjectRenewRequest alloc] init];
    request.confirmKey = partInfo.confirmKey;
    if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
        request.partNumberRange = partRange;
    }
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.libraryId = self.libraryId;
    request.spaceId = self.spaceId;
    request.userId = self.userId;
    [request setFinishBlock:^(QCloudSMHInitUploadInfo *_Nullable result, NSError *_Nullable error) {
        if([QCloudSMHBaseRequest getServerType] == QCloudSMHServerPrivateCloud){
            if(result){
                [self.uploadHeaders setObject:result forKey:partRange];
            }
        }else{
            if (self.existParts) {
                self.existParts.uploadPartInfo = result;
            }
            self.uploadInitInfo = result;

        }
        
    }];
    [[QCloudSMHService defaultSMHService] renewUploadInfo:request];
}

-(NSString * )encodeSuffix:(NSString *)str{
    
    NSMutableArray * names = [[str componentsSeparatedByString:@"."] mutableCopy];
    
    NSCharacterSet * charSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "];
    NSString * type = [names.lastObject stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    [names removeLastObject];
    [names addObject:type];
    return [names componentsJoinedByString:@"."];
}

-(NSInteger)getServerTimeOffsetWithLocal:(NSHTTPURLResponse *)result{
    if (!result) {
        return 0;
    }
    NSString * date = result.allHeaderFields[@"Date"];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss 'GMT'";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *serverTime = [dateFormatter dateFromString:date];
    NSInteger offset = [serverTime timeIntervalSince1970] - [NSDate.date timeIntervalSince1970];
    return offset;
}

@end
