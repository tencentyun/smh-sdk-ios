//
//  QCloudSMHHlsV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHGetMediaFileInfoRequest.h"
#import "QCloudSMHCreateTranscodeTaskRequest.h"
#import "QCloudSMHPrepareM3u8UploadRequest.h"
#import "QCloudSMHConfirmM3u8UploadRequest.h"
#import "QCloudSMHRenewM3u8UploadRequest.h"
#import "QCloudSMHModifyM3u8SegmentsRequest.h"
#import "QCloudSMHLiveTranscodeMediaFileRequest.h"
#import "QCloudSMHPutDirectoryRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"
#import "QCloudSMHM3u8SegmentInfo.h"
#import "QCloudSMHM3u8UploadInfo.h"

/// 上传的真实视频文件路径
static NSString *const kHlsVideoPath = @"codegen_hls_test/test_video.mp4";
/// m3u8 测试文件上传路径
static NSString *const kM3u8UploadPath = @"codegen_hls_test/test.m3u8";
/// 动态生成的 ts 分片数量
static const NSUInteger kM3u8SegmentCount = 3;

@interface QCloudSMHHlsV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHHlsV2Tests

- (void)setUp {
    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/", QCloudSMHTestTools.singleTool.getBaseUrlStrV2] targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    self.fenceQueue = [QCloudSMHAccessTokenFenceQueue new];
    self.fenceQueue.delegate = self;
    [QCloudSMHService defaultSMHService].accessTokenProvider = self;
}

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    QCloudSMHSpaceInfo *spaceinfo = [QCloudSMHSpaceInfo new];
    spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    spaceinfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    continueBlock(spaceinfo, nil);
}

#pragma mark - 辅助方法：动态生成 m3u8 内容和模拟 ts 分片

/// 动态生成 ts 分片文件名列表
/// @return 包含所有 ts 分片文件名的数组（如 @[@"seg0.ts", @"seg1.ts", ...]）
- (NSArray<NSString *> *)generateSegmentNames {
    NSMutableArray<NSString *> *segments = [NSMutableArray arrayWithCapacity:kM3u8SegmentCount];
    for (NSUInteger i = 0; i < kM3u8SegmentCount; i++) {
        [segments addObject:[NSString stringWithFormat:@"seg%lu.ts", (unsigned long)i]];
    }
    return [segments copy];
}

/// 动态生成每个分片的时长（秒）
/// @return 包含每个分片时长的数组
- (NSArray<NSNumber *> *)generateSegmentDurations {
    // 模拟不同时长的分片（数量与 kM3u8SegmentCount 一致）
    return @[@(9.009), @(8.341), @(10.000)];
}

/// 动态生成 m3u8 播放列表内容
/// @return m3u8 文件内容字符串
- (NSString *)generateM3u8Content {
    NSArray<NSString *> *segmentNames = [self generateSegmentNames];
    NSArray<NSNumber *> *durations = [self generateSegmentDurations];
    
    NSMutableString *content = [NSMutableString string];
    [content appendString:@"#EXTM3U\n"];
    [content appendString:@"#EXT-X-VERSION:3\n"];
    [content appendString:@"#EXT-X-TARGETDURATION:10\n"];
    [content appendString:@"#EXT-X-MEDIA-SEQUENCE:0\n"];
    
    for (NSUInteger i = 0; i < segmentNames.count; i++) {
        [content appendFormat:@"#EXTINF:%.3f,\n", durations[i].doubleValue];
        [content appendFormat:@"%@\n", segmentNames[i]];
    }
    [content appendString:@"#EXT-X-ENDLIST\n"];
    
    return [content copy];
}

/// 将动态生成的 m3u8 内容写入临时文件
/// @return 临时 m3u8 文件路径
- (NSString *)generateM3u8TempFile {
    NSString *m3u8Content = [self generateM3u8Content];
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_generated.m3u8"];
    [m3u8Content writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return tempPath;
}

/// 生成模拟的 ts 分片临时文件（使用随机数据填充）
/// @param segName 分片文件名（如 seg0.ts）
/// @return 临时 ts 文件路径
- (NSString *)generateTsSegmentTempFile:(NSString *)segName {
    // 生成一个 10KB ~ 50KB 的模拟 ts 分片文件
    return [QCloudSMHTestTools tempFileWithRandomSizeFrom:10 * 1024 to:50 * 1024];
}

#pragma mark - 辅助方法：使用预签名信息上传文件到 COS

/// 使用 prepare/renew/modify 返回的预签名上传信息，将文件直接 PUT 到 COS
/// @param uploadInfo 预签名上传信息（包含 domain、path、headers）
/// @param fileData 要上传的文件数据
/// @param completion 上传完成回调
- (void)uploadFileToCosWithUploadInfo:(QCloudSMHM3u8UploadInfo *)uploadInfo
                             fileData:(NSData *)fileData
                           completion:(void (^)(NSError *_Nullable error))completion {
    // 拼接完整的 COS 上传 URL：https://{domain}{path}
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@", uploadInfo.domain, uploadInfo.path];
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        completion([NSError errorWithDomain:@"TestError" code:-1
                                   userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"无效的 COS 上传 URL: %@", urlString]}]);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = fileData;
    
    // 设置预签名 headers（包含授权信息）
    [uploadInfo.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    NSLog(@"📤 上传文件到 COS: %@ (大小: %lu bytes)", urlString, (unsigned long)fileData.length);
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"❌ COS 上传网络错误: %@", error);
            completion(error);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"📤 COS 上传响应: HTTP %ld", (long)httpResponse.statusCode);
        if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            NSLog(@"✅ COS 上传成功");
            completion(nil);
        } else {
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"(无响应体)";
            NSLog(@"❌ COS 上传失败: HTTP %ld, body=%@", (long)httpResponse.statusCode, responseBody);
            completion([NSError errorWithDomain:@"CosUploadError"
                                          code:httpResponse.statusCode
                                      userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"COS 上传失败 HTTP %ld: %@", (long)httpResponse.statusCode, responseBody]}]);
        }
    }];
    [task resume];
}

/// 使用 prepare 返回的预签名信息，将 m3u8 播放列表和所有 ts 分片文件上传到 COS
/// @param prepareResult prepare 接口返回的结果（包含 playlist 和 segments 上传信息）
/// @param m3u8Data m3u8 播放列表文件数据
/// @param segmentDataMap ts 分片文件数据字典（key 为分片路径如 "seg0.ts"，value 为文件数据）
/// @param completion 全部上传完成回调
- (void)uploadAllFilesToCosWithPrepareResult:(QCloudSMHM3u8PrepareResult *)prepareResult
                                    m3u8Data:(NSData *)m3u8Data
                              segmentDataMap:(NSDictionary<NSString *, NSData *> *)segmentDataMap
                                  completion:(void (^)(NSError *_Nullable error))completion {
    // 使用 dispatch_group 并发上传所有文件
    dispatch_group_t group = dispatch_group_create();
    __block NSError *firstError = nil;
    __block NSLock *errorLock = [NSLock new];
    
    // 1. 上传 m3u8 播放列表
    if (prepareResult.playlist) {
        dispatch_group_enter(group);
        NSLog(@"📤 开始上传 m3u8 播放列表...");
        [self uploadFileToCosWithUploadInfo:prepareResult.playlist
                                  fileData:m3u8Data
                                completion:^(NSError *error) {
            if (error) {
                [errorLock lock];
                if (!firstError) firstError = error;
                [errorLock unlock];
                NSLog(@"❌ m3u8 播放列表上传失败: %@", error);
            } else {
                NSLog(@"✅ m3u8 播放列表上传成功");
            }
            dispatch_group_leave(group);
        }];
    }
    
    // 2. 上传所有 ts 分片
    [prepareResult.segments enumerateKeysAndObjectsUsingBlock:^(NSString *segPath, QCloudSMHM3u8UploadInfo *segUploadInfo, BOOL *stop) {
        NSData *segData = segmentDataMap[segPath];
        if (!segData) {
            NSLog(@"⚠️ 未找到分片 %@ 的数据，跳过", segPath);
            return;
        }
        dispatch_group_enter(group);
        NSLog(@"📤 开始上传分片: %@", segPath);
        [self uploadFileToCosWithUploadInfo:segUploadInfo
                                  fileData:segData
                                completion:^(NSError *error) {
            if (error) {
                [errorLock lock];
                if (!firstError) firstError = error;
                [errorLock unlock];
                NSLog(@"❌ 分片 %@ 上传失败: %@", segPath, error);
            } else {
                NSLog(@"✅ 分片 %@ 上传成功", segPath);
            }
            dispatch_group_leave(group);
        }];
    }];
    
    // 3. 等待所有上传完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (firstError) {
            NSLog(@"❌ COS 文件上传存在失败: %@", firstError);
        } else {
            NSLog(@"✅ 所有文件上传到 COS 完成");
        }
        completion(firstError);
    });
}

#pragma mark - 辅助方法：上传真实视频文件

- (void)uploadRealVideoFileWithCompletion:(void (^)(NSError *error))completion {
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_hls_test";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        // 使用项目中的测试视频文件（相对路径）
        NSString *videoPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test_video" ofType:@"mp4"];
        if (!videoPath || ![[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            completion([NSError errorWithDomain:@"TestError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"找不到测试视频文件 test_video.mp4"}]);
            return;
        }
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
        uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        uploadReq.uploadPath = kHlsVideoPath;
        uploadReq.body = videoURL;
        uploadReq.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
        [uploadReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            completion(error);
        }];
        [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
}

#pragma mark - 媒体信息（先上传真实视频文件）

- (void)testQCloudSMHGetMediaFileInfoRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetMediaFileInfoRequest"];
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        QCloudSMHGetMediaFileInfoRequest *request = [QCloudSMHGetMediaFileInfoRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = kHlsVideoPath;
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] getMediaFileInfo:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

- (void)testQCloudSMHCreateTranscodeTaskRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CreateTranscodeTaskRequest"];
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        QCloudSMHCreateTranscodeTaskRequest *request = [QCloudSMHCreateTranscodeTaskRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = kHlsVideoPath;
        request.transcodingTemplateId = @"h264_1080p";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            if (result == nil) {
                   // HTTP 204：转码已完成，无需等待
               } else {
                   // HTTP 200：转码未完成，可获取 taskId 查询进度
                   XCTAssertNotNil(result[@"taskId"]);
               }
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] createTranscodeTask:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

#pragma mark - 实时转码（先上传真实视频文件）

- (void)testQCloudSMHLiveTranscodeMediaFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"LiveTranscodeMediaFileRequest"];
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        QCloudSMHLiveTranscodeMediaFileRequest *request = [QCloudSMHLiveTranscodeMediaFileRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = kHlsVideoPath;
        request.transcodingTemplateId = @"h264_720p";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] liveTranscodeMediaFile:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

#pragma mark - M3u8 上传（链式调用：prepare → 上传到 COS → confirm）

/// 测试 m3u8 上传准备 — 先上传视频文件，再动态生成 m3u8 内容进行测试
/// @discussion 先上传 test_video.mp4 作为前置条件，然后动态生成 m3u8 播放列表和 ts 分片信息，
/// 构建 segments 参数发起 prepare 请求。
/// PrepareM3u8Upload 接口存在两种不同的响应数据模型：
/// - HTTP 201（未命中秒传）：返回 QCloudSMHM3u8PrepareResult（包含 confirmKey + playlist + segments 上传信息）
/// - HTTP 200（命中秒传）：返回 QCloudSMHM3u8QuickUploadResult（包含 path + name + type 最终文件信息）
/// 本测试用例同时展示两种响应的解析方式。
- (void)testQCloudSMHPrepareM3u8UploadRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"PrepareM3u8UploadRequest"];
    
    // 0. 先上传视频文件作为前置条件
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        
        // 1. 动态生成 ts 分片信息
        NSArray<NSString *> *tsSegments = [self generateSegmentNames];
        NSArray<NSNumber *> *tsDurations = [self generateSegmentDurations];
        XCTAssertGreaterThan(tsSegments.count, 0, @"应至少包含一个 ts 分片");
        XCTAssertEqual(tsSegments.count, tsDurations.count, @"分片数量与时长数量应一致");
        
        NSLog(@"📋 动态生成 %lu 个 ts 分片:", (unsigned long)tsSegments.count);
        for (NSUInteger i = 0; i < tsSegments.count; i++) {
            NSLog(@"  分片[%lu]: %@ (时长: %.3f 秒)", (unsigned long)i, tsSegments[i], tsDurations[i].doubleValue);
        }
        
        // 2. 构建 segments 参数
        NSMutableArray<QCloudSMHM3u8SegmentInfo *> *segmentInfos = [NSMutableArray arrayWithCapacity:tsSegments.count];
        for (NSString *tsName in tsSegments) {
            QCloudSMHM3u8SegmentInfo *seg = [QCloudSMHM3u8SegmentInfo new];
            seg.path = tsName;
            seg.uploadMethod = @"simple";
            [segmentInfos addObject:seg];
        }
        
        // 3. 发起 prepare 请求
        QCloudSMHPrepareM3u8UploadRequest *prepareReq = [QCloudSMHPrepareM3u8UploadRequest new];
        prepareReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        prepareReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        prepareReq.filePath = kM3u8UploadPath;
        prepareReq.conflictResolutionStrategy = @"rename";
        prepareReq.includePlaylist = YES;
        prepareReq.segments = segmentInfos;
        
        [prepareReq setFinishBlock:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            
            // 4. 根据响应内容判断是哪种数据模型
            if (result[@"confirmKey"]) {
                // ========== 场景一：HTTP 201 未命中秒传 ==========
                NSLog(@"✅ 未命中秒传（201），使用 QCloudSMHM3u8PrepareResult 解析");
                QCloudSMHM3u8PrepareResult *prepareResult = [QCloudSMHM3u8PrepareResult qcloud_modelWithDictionary:result];
                XCTAssertNotNil(prepareResult, @"QCloudSMHM3u8PrepareResult 解析不应为 nil");
                XCTAssertNotNil(prepareResult.confirmKey, @"confirmKey 不应为 nil");
                NSLog(@"  confirmKey: %@", prepareResult.confirmKey);
                
                // 验证 playlist 上传信息
                if (prepareResult.playlist) {
                    NSLog(@"  playlist.domain: %@", prepareResult.playlist.domain);
                    NSLog(@"  playlist.path: %@", prepareResult.playlist.path);
                    NSLog(@"  playlist.expiration: %@", prepareResult.playlist.expiration);
                    XCTAssertNotNil(prepareResult.playlist.domain, @"playlist.domain 不应为 nil");
                    XCTAssertNotNil(prepareResult.playlist.path, @"playlist.path 不应为 nil");
                }
                
                // 验证 segments 上传信息（key 为分片路径，value 为上传信息）
                if (prepareResult.segments) {
                    NSLog(@"  segments 数量: %lu", (unsigned long)prepareResult.segments.count);
                    [prepareResult.segments enumerateKeysAndObjectsUsingBlock:^(NSString *key, QCloudSMHM3u8UploadInfo *info, BOOL *stop) {
                        NSLog(@"  segment[%@]: domain=%@, path=%@, uploadId=%@", key, info.domain, info.path, info.uploadId ?: @"(无，简单上传)");
                        XCTAssertNotNil(info.domain, @"segment.domain 不应为 nil");
                        XCTAssertNotNil(info.path, @"segment.path 不应为 nil");
                    }];
                }
            } else if (result[@"path"] || result[@"name"]) {
                // ========== 场景二：HTTP 200 命中秒传 ==========
                NSLog(@"⚡ 命中秒传（200），使用 QCloudSMHM3u8QuickUploadResult 解析");
                QCloudSMHM3u8QuickUploadResult *quickResult = [QCloudSMHM3u8QuickUploadResult qcloud_modelWithDictionary:result];
                XCTAssertNotNil(quickResult, @"QCloudSMHM3u8QuickUploadResult 解析不应为 nil");
                NSLog(@"  path: %@", quickResult.path);
                NSLog(@"  name: %@", quickResult.name);
                NSLog(@"  type: %@", quickResult.type);
                XCTAssertNotNil(quickResult.name, @"命中秒传时 name 不应为 nil");
                XCTAssertNotNil(quickResult.type, @"命中秒传时 type 不应为 nil");
            } else {
                NSLog(@"⚠️ 未知的响应格式: %@", result);
            }
            
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] prepareM3u8Upload:prepareReq];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/// 完整的 m3u8 上传流程测试：prepare → 上传文件到 COS → confirm
/// @discussion 完全模拟线上环境：
/// 1. 上传视频文件作为前置条件
/// 2. 调用 prepare 获取预签名上传信息
/// 3. 使用预签名信息将 m3u8 播放列表和 ts 分片文件真正上传到 COS
/// 4. 调用 confirm 完成上传确认
- (void)testQCloudSMHConfirmM3u8UploadRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ConfirmM3u8UploadRequest"];
    
    // 0. 先上传视频文件作为前置条件
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        
        // 1. 动态生成 m3u8 内容和 ts 分片数据
        NSArray<NSString *> *tsSegments = [self generateSegmentNames];
        NSString *m3u8Content = [self generateM3u8Content];
        NSData *m3u8Data = [m3u8Content dataUsingEncoding:NSUTF8StringEncoding];
        XCTAssertNotNil(m3u8Data, @"m3u8 内容不应为空");
        NSLog(@"📋 动态生成 m3u8 播放列表 (%lu bytes):\n%@", (unsigned long)m3u8Data.length, m3u8Content);
        
        // 生成模拟的 ts 分片文件数据
        NSMutableDictionary<NSString *, NSData *> *segmentDataMap = [NSMutableDictionary dictionary];
        for (NSString *tsName in tsSegments) {
            NSString *tempPath = [self generateTsSegmentTempFile:tsName];
            NSData *segData = [NSData dataWithContentsOfFile:tempPath];
            segmentDataMap[tsName] = segData;
            NSLog(@"📋 生成模拟分片: %@ (%lu bytes)", tsName, (unsigned long)segData.length);
        }
        
        // 2. 构建 segments 参数
        NSMutableArray<QCloudSMHM3u8SegmentInfo *> *segmentInfos = [NSMutableArray arrayWithCapacity:tsSegments.count];
        for (NSString *tsName in tsSegments) {
            QCloudSMHM3u8SegmentInfo *seg = [QCloudSMHM3u8SegmentInfo new];
            seg.path = tsName;
            seg.uploadMethod = @"simple";
            [segmentInfos addObject:seg];
        }
        
        // 3. 发起 prepare 请求
        QCloudSMHPrepareM3u8UploadRequest *prepareReq = [QCloudSMHPrepareM3u8UploadRequest new];
        prepareReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        prepareReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        prepareReq.filePath = kM3u8UploadPath;
        prepareReq.conflictResolutionStrategy = @"rename";
        prepareReq.includePlaylist = YES;
        prepareReq.segments = segmentInfos;
        
        [prepareReq setFinishBlock:^(NSDictionary *_Nullable prepareDict, NSError *_Nullable prepareError) {
            XCTAssertNil(prepareError, @"prepare 请求失败: %@", prepareError);
            XCTAssertNotNil(prepareDict, @"prepare 响应不应为 nil");
            
            NSString *confirmKey = prepareDict[@"confirmKey"];
            if (!confirmKey) {
                // 命中秒传（200），无需上传和 confirm
                NSLog(@"⚡ prepare 命中秒传，无需上传文件到 COS");
                [expectation fulfill];
                return;
            }
            
            // 4. 解析 prepare 结果
            QCloudSMHM3u8PrepareResult *prepareResult = [QCloudSMHM3u8PrepareResult qcloud_modelWithDictionary:prepareDict];
            XCTAssertNotNil(prepareResult.confirmKey, @"confirmKey 不应为 nil");
            NSLog(@"✅ prepare 成功，confirmKey: %@", prepareResult.confirmKey);
            
            // 5. 使用预签名信息将文件真正上传到 COS
            NSLog(@"📤 开始上传文件到 COS...");
            [self uploadAllFilesToCosWithPrepareResult:prepareResult
                                             m3u8Data:m3u8Data
                                       segmentDataMap:segmentDataMap
                                           completion:^(NSError *cosError) {
                XCTAssertNil(cosError, @"上传文件到 COS 失败: %@", cosError);
                
                // 6. 调用 confirm 完成上传确认
                NSLog(@"📤 所有文件已上传到 COS，开始 confirm...");
                NSMutableArray<QCloudSMHM3u8ConfirmSegmentInfo *> *confirmSegments = [NSMutableArray array];
                for (NSString *tsName in tsSegments) {
                    QCloudSMHM3u8ConfirmSegmentInfo *confirmSeg = [QCloudSMHM3u8ConfirmSegmentInfo new];
                    confirmSeg.path = tsName;
                    [confirmSegments addObject:confirmSeg];
                }
                
                QCloudSMHConfirmM3u8UploadRequest *confirmReq = [QCloudSMHConfirmM3u8UploadRequest new];
                confirmReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
                confirmReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
                confirmReq.confirmKey = confirmKey;
                confirmReq.segments = confirmSegments;
                [confirmReq setFinishBlock:^(QCloudSMHM3u8ConfirmResult *_Nullable confirmResult, NSError *_Nullable confirmError) {
                    XCTAssertNil(confirmError, @"confirm 请求失败: %@", confirmError);
                    XCTAssertNotNil(confirmResult, @"confirm 结果不应为 nil");
                    if (confirmResult.playlist) {
                        NSLog(@"✅ confirm 成功，playlist.path: %@", confirmResult.playlist.path);
                    }
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] confirmM3u8Upload:confirmReq];
            }];
        }];
        [[QCloudSMHService defaultSMHService] prepareM3u8Upload:prepareReq];
    }];
    [self waitForExpectationsWithTimeout:180 handler:nil];
}

/// prepare → 获取真实 confirmKey → renew（先上传视频文件，动态生成 m3u8 分片）
- (void)testQCloudSMHRenewM3u8UploadRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"RenewM3u8UploadRequest"];
    
    // 0. 先上传视频文件作为前置条件
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        
        // 动态生成 ts 分片信息
        NSArray<NSString *> *tsSegments = [self generateSegmentNames];
        XCTAssertGreaterThan(tsSegments.count, 0, @"应至少包含一个 ts 分片");
        
        // 构建 prepare 请求的 segments
        NSMutableArray<QCloudSMHM3u8SegmentInfo *> *prepareSegments = [NSMutableArray array];
        for (NSString *tsName in tsSegments) {
            QCloudSMHM3u8SegmentInfo *seg = [QCloudSMHM3u8SegmentInfo new];
            seg.path = tsName;
            seg.uploadMethod = @"simple";
            [prepareSegments addObject:seg];
        }
        
        QCloudSMHPrepareM3u8UploadRequest *prepareReq = [QCloudSMHPrepareM3u8UploadRequest new];
        prepareReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        prepareReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        prepareReq.filePath = kM3u8UploadPath;
        prepareReq.conflictResolutionStrategy = @"rename";
        prepareReq.includePlaylist = YES;
        prepareReq.segments = prepareSegments;
        [prepareReq setFinishBlock:^(NSDictionary *_Nullable prepareResult, NSError *_Nullable prepareError) {
            XCTAssertNil(prepareError);
            NSString *confirmKey = [prepareResult valueForKey:@"confirmKey"];
            if (!confirmKey) {
                NSLog(@"⚡ prepare 命中秒传，无需 renew");
                [expectation fulfill];
                return;
            }
            // 构建 renew 请求的 segments（使用 QCloudSMHM3u8RenewSegmentInfo 数据模型）
            NSMutableArray<QCloudSMHM3u8RenewSegmentInfo *> *renewSegments = [NSMutableArray array];
            for (NSString *tsName in tsSegments) {
                QCloudSMHM3u8RenewSegmentInfo *renewSeg = [QCloudSMHM3u8RenewSegmentInfo new];
                renewSeg.path = tsName;
                [renewSegments addObject:renewSeg];
            }
            
            QCloudSMHRenewM3u8UploadRequest *renewReq = [QCloudSMHRenewM3u8UploadRequest new];
            renewReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            renewReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            renewReq.confirmKey = confirmKey;
            // renew 接口的 segments：使用 QCloudSMHM3u8RenewSegmentInfo 数据模型封装，
            // API 层面为纯字符串数组，序列化时自动提取 path 字段
            renewReq.segments = renewSegments;
            [renewReq setFinishBlock:^(QCloudSMHM3u8RenewResult *_Nullable renewResult, NSError *_Nullable renewError) {
                XCTAssertNil(renewError);
                XCTAssertNotNil(renewResult);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] renewM3u8Upload:renewReq];
        }];
        [[QCloudSMHService defaultSMHService] prepareM3u8Upload:prepareReq];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/// prepare → 获取真实 confirmKey → modify segments（先上传视频文件，动态生成 m3u8 分片 + 追加新分片）
- (void)testQCloudSMHModifyM3u8SegmentsRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ModifyM3u8SegmentsRequest"];
    
    // 0. 先上传视频文件作为前置条件
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        
        // 动态生成 ts 分片信息（只取前 2 个用于 prepare）
        NSArray<NSString *> *tsSegments = [self generateSegmentNames];
        XCTAssertGreaterThan(tsSegments.count, 0, @"应至少包含一个 ts 分片");
        
        NSUInteger prepareCount = MIN(2, tsSegments.count);
        NSArray<NSString *> *initialSegments = [tsSegments subarrayWithRange:NSMakeRange(0, prepareCount)];
        
        NSMutableArray<QCloudSMHM3u8SegmentInfo *> *prepareSegments = [NSMutableArray array];
        for (NSString *tsName in initialSegments) {
            QCloudSMHM3u8SegmentInfo *seg = [QCloudSMHM3u8SegmentInfo new];
            seg.path = tsName;
            seg.uploadMethod = @"simple";
            [prepareSegments addObject:seg];
        }
        
        QCloudSMHPrepareM3u8UploadRequest *prepareReq = [QCloudSMHPrepareM3u8UploadRequest new];
        prepareReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        prepareReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        prepareReq.filePath = kM3u8UploadPath;
        prepareReq.conflictResolutionStrategy = @"rename";
        prepareReq.includePlaylist = YES;
        prepareReq.segments = prepareSegments;
        [prepareReq setFinishBlock:^(NSDictionary *_Nullable prepareResult, NSError *_Nullable prepareError) {
            XCTAssertNil(prepareError);
            NSString *confirmKey = [prepareResult valueForKey:@"confirmKey"];
            if (!confirmKey) {
                NSLog(@"⚡ prepare 命中秒传，无需 modify");
                [expectation fulfill];
                return;
            }
            
            // 使用 modify 接口追加剩余的分片（模拟分批上传场景）
            NSMutableArray<QCloudSMHM3u8SegmentInfo *> *modifySegments = [NSMutableArray array];
            if (tsSegments.count > prepareCount) {
                NSArray<NSString *> *remainingSegments = [tsSegments subarrayWithRange:NSMakeRange(prepareCount, tsSegments.count - prepareCount)];
                for (NSString *tsName in remainingSegments) {
                    QCloudSMHM3u8SegmentInfo *seg = [QCloudSMHM3u8SegmentInfo new];
                    seg.path = tsName;
                    seg.uploadMethod = @"simple";
                    [modifySegments addObject:seg];
                }
            } else {
                // 如果分片不够，追加一个新的分片
                QCloudSMHM3u8SegmentInfo *newSeg = [QCloudSMHM3u8SegmentInfo new];
                newSeg.path = @"seg_extra.ts";
                newSeg.uploadMethod = @"simple";
                [modifySegments addObject:newSeg];
            }
            
            NSLog(@"📋 modify 追加 %lu 个分片", (unsigned long)modifySegments.count);
            
            QCloudSMHModifyM3u8SegmentsRequest *modifyReq = [QCloudSMHModifyM3u8SegmentsRequest new];
            modifyReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            modifyReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            modifyReq.confirmKey = confirmKey;
            modifyReq.segments = modifySegments;
            [modifyReq setFinishBlock:^(QCloudSMHM3u8ModifyResult *_Nullable modifyResult, NSError *_Nullable modifyError) {
                XCTAssertNil(modifyError);
                XCTAssertNotNil(modifyResult);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] modifyM3u8Segments:modifyReq];
        }];
        [[QCloudSMHService defaultSMHService] prepareM3u8Upload:prepareReq];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

@end
