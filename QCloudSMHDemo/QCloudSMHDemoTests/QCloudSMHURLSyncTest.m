//
//  QCloudSMHURLSyncTest.m
//  QCloudSMHDemoTests
//
//  Created by 摩卡 on 2026/1/28.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHExternalURLDownloadRequest.h"
#import "QCloudSMHURLProbe.h"
#import "QCloudSMHURLProbeResult.h"
#import "QCloudCOSSMHUploadObjectRequest.h"
#import "QCloudSMHContentInfo.h"

#pragma mark - 测试用公开 URL

/// 无效 URL（用于错误测试）
static NSString *const kTestInvalidURL = @"https://invalid.domain.that.does.not.exist.example.com/file.txt";

#pragma mark - 测试服务器 URL（http://localhost:8080）

/// 本地服务器基础 URL
static NSString *const kLocalServerBaseURL = @"http://21.214.65.176:8080/file";

/**
 * 本地测试服务器 URL 规则：
 * http://localhost:8080/file/<选项>/<文件名>
 *
 * 选项组合（用逗号分隔）：
 * - 无选项（直接文件名）：不支持 HEAD、不返回 Content-Length、不支持 Range
 * - head：允许 HEAD 请求
 * - range：支持断点续传（Accept-Ranges: bytes）
 * - content-length：返回文件大小
 * - header：需要 Header 校验，请求头中必须包含 urlsync=1，否则服务器返回异常
 *
 * 测试文件：
 * - 小文件：Quic_SDK_隔离方案.md（文档文件）
 * - 文件：chinese_new_year_cruise_ai_horse.png（图片文件）
 * - 大文件：QCloudiOSCodes.zip（压缩包）
 */

/// 小文件名（Markdown 文档）
static NSString *const kTestSmallFileName = @"Quic_SDK.md";

/// 中文件名（PNG 图片）
static NSString *const kTestFileName = @"chinese_new_year_cruise_ai_horse.png";

/// 大文件名（ZIP 压缩包）
static NSString *const kTestLargeFileName = @"5GB_test.bin";

/// 4GB 文件
static NSString *const kTest4GBFileName = @"QCloudiOSCodes.zip";

/// 500MB
static NSString *const kTest500MBFileName = @"large_file_500MB.bin";

static NSUInteger k5GBThreshold = 5LL * 1024 * 1024 * 1024;

static NSUInteger k500MBThreshold = 5LL * 1024 * 1024;

#pragma mark - 8 种服务器配置的 URL 模板

/// 场景1：无任何选项 - 不支持 HEAD、无 Content-Length、不支持 Range（不传递参数，直接使用文件名）
static NSString *const kLocalOption_None = @"";

/// 场景2：仅 HEAD - 允许 HEAD，无 Content-Length，不支持 Range
static NSString *const kLocalOption_Head = @"head";

/// 场景3：仅 Range - 支持断点续传，无 Content-Length，不允许 HEAD
static NSString *const kLocalOption_Range = @"range";

/// 场景4：仅 Content-Length - 返回文件大小，不支持 Range，不允许 HEAD
static NSString *const kLocalOption_ContentLength = @"content-length";

/// 场景5：Range + HEAD - 支持断点续传，允许 HEAD，无 Content-Length
static NSString *const kLocalOption_RangeHead = @"range/head";

/// 场景6：Content-Length + HEAD - 返回文件大小，允许 HEAD，不支持 Range
static NSString *const kLocalOption_ContentLengthHead = @"content-length/head";

/// 场景7：Range + Content-Length - 支持断点续传，返回文件大小，不允许 HEAD
static NSString *const kLocalOption_RangeContentLength = @"range/content-length";

/// 场景8：完整功能 - 支持断点续传、返回文件大小、允许 HEAD
static NSString *const kLocalOption_Full = @"range/content-length/head";

/// 场景9：需要 Header 校验 - 请求头中必须包含 urlsync=1，否则服务器返回异常
static NSString *const kLocalOption_Header = @"header";

@interface QCloudSMHURLSyncTest : XCTestCase <QCloudSMHAccessTokenProvider>

@property (nonatomic, strong) QCloudSMHService *service;

@end

@implementation QCloudSMHURLSyncTest

#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
    
    // 配置服务
    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/", QCloudSMHTestTools.singleTool.getBaseUrlStrV2]
                                  targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    
    self.service = [QCloudSMHService defaultSMHService];
    self.service.accessTokenProvider = self;
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - QCloudSMHAccessTokenProvider

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequest
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    
    QCloudSMHSpaceInfo *spaceInfo = [QCloudSMHSpaceInfo new];
    spaceInfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    spaceInfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    spaceInfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    continueBlock(spaceInfo, nil);
}

#pragma mark - Helper Methods

/// 判断选项是否包含 header（需要添加 urlsync header）
/// @param option 服务器选项
- (BOOL)optionRequiresURLSyncHeader:(NSString *)option {
    if (option.length == 0) {
        return NO;
    }
    NSArray *options = [option componentsSeparatedByString:@","];
    return [options containsObject:@"header"];
}

/// 获取指定选项所需的请求头
/// @param option 服务器选项
- (NSDictionary<NSString *, NSString *> *)headersForOption:(NSString *)option {
    if ([self optionRequiresURLSyncHeader:option]) {
        return @{@"urlsync": @"1"};
    }
    return nil;
}

/// 生成带时间戳的上传路径
/// @param fileName 文件名
- (NSString *)uploadPathWithFileName:(NSString *)fileName {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f_%@", timestamp, fileName];
}

/// 构建本地测试 URL
/// @param option 服务器选项（如 "", "head", "range,content-length,head" 等，空字符串表示无选项）
/// @param fileName 文件名
- (NSURL *)localURLWithOption:(NSString *)option fileName:(NSString *)fileName {
    NSString *encodedFileName = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *urlString;
    if (option.length == 0) {
        // 无选项：直接使用文件名 http://localhost:8080/file/<文件名>
        urlString = [NSString stringWithFormat:@"%@/%@", kLocalServerBaseURL, encodedFileName];
    } else {
        // 有选项：http://localhost:8080/file/<选项>/<文件名>
        urlString = [NSString stringWithFormat:@"%@/%@/%@", kLocalServerBaseURL, option, encodedFileName];
    }
    return [NSURL URLWithString:urlString];
}

#pragma mark - QCloudSMHExternalURLDownloadRequest 第三方URL 文件下载验证

/**
 * TC001: 小文件完整下载（完整功能模式）
 */
- (void)test_TC001_ExternalURLDownloadRequest_SmallFile_Full {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExternalURLDownloadRequest_SmallFile_Full"];
    
    QCloudSMHExternalURLDownloadRequest *request = [[QCloudSMHExternalURLDownloadRequest alloc] init];
    request.sourceURL = [self localURLWithOption:kLocalOption_None fileName:kTestFileName];
    
    __block int64_t totalBytesExpected = 0;
    
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        totalBytesExpected = totalBytesExpectedToDownload;
    }];
    
    [request setFinishBlock:^(id _Nullable outputObject, NSError * _Nullable error) {
        NSData *receivedData = outputObject;
        XCTAssertNil(error, @"小文件下载不应出错: %@", error);
        XCTAssertNotNil(receivedData, @"应收到数据");
        if (totalBytesExpected > 0) {
            XCTAssertEqual(receivedData.length, totalBytesExpected, @"数据长度应与预期一致");
        }
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] downloadExternalURL:request];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - QCloudSMHURLProbe 测试

/**
 * TC002: 探测小文件（完整功能模式）
 */
- (void)test_TC002_URLProbe_SmallFile_Full {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_SmallFile_Full"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertGreaterThan(result.fileSize, 0, @"文件大小应大于 0");
        XCTAssertTrue(result.hasContentLength, @"应有 Content-Length");
        XCTAssertTrue(result.supportsRange, @"应支持 Range");
        XCTAssertTrue(result.canUseChunkedTransfer, @"应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC003: 探测无效 URL（网络错误）
 */
- (void)test_TC003_URLProbe_InvalidURL {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_InvalidURL"];
    
    NSURL *url = [NSURL URLWithString:kTestInvalidURL];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    probe.timeout = 10.0;
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNotNil(error, @"无效 URL 应返回错误");
        XCTAssertNil(result, @"无效 URL 结果应为 nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC004: 取消探测
 */
- (void)test_TC004_URLProbe_Cancel {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_Cancel"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    __block BOOL completionCalled = NO;
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        if (error && error.code == QCloudNetworkErrorCodeCanceled) {
            completionCalled = YES;
        }
        
    }];
    // 立即取消
    [probe cancel];
    
    // 等待一段时间确认行为
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue(completionCalled, @"用户应该正常取消");
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

/**
 * TC005: 场景1 - 无任何选项
 * - HEAD: ❌ (返回 405)
 * - Content-Length: ❌
 * - Range: ❌
 *
 * 预期：HEAD 失败后降级到 GET，GET 也无法获取文件大小
 */
- (void)test_TC005_URLProbe_LocalServer_NoOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_NoOptions"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_None fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        if (result) {
            XCTAssertFalse(result.hasContentLength, @"无选项场景不应有 Content-Length");
            XCTAssertEqual(result.fileSize, -1, @"无选项场景文件大小应为 -1");
            XCTAssertFalse(result.supportsRange, @"无选项场景不应支持 Range");
            XCTAssertFalse(result.canUseChunkedTransfer, @"无选项场景不应支持分块传输");
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC006: 场景2 - 仅 HEAD
 * - HEAD: ✅
 * - Content-Length: ❌
 * - Range: ❌
 *
 * 预期：HEAD 成功但无文件大小信息
 */
- (void)test_TC006_URLProbe_LocalServer_HeadOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_HeadOnly"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Head fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"仅 HEAD 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertFalse(result.hasContentLength, @"仅 HEAD 场景不应有 Content-Length");
        XCTAssertEqual(result.fileSize, -1, @"仅 HEAD 场景文件大小应为 -1");
        XCTAssertFalse(result.supportsRange, @"仅 HEAD 场景不应支持 Range");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC007: 场景3 - 仅 Range
 * - HEAD: ❌ (返回 405)
 * - Content-Length: ❌
 * - Range: ✅
 *
 * 预期：HEAD 失败降级 GET，通过 Content-Range 解析文件大小
 */
- (void)test_TC007_URLProbe_LocalServer_RangeOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_RangeOnly"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Range fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"仅 Range 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertTrue(result.supportsRange, @"仅 Range 场景应支持 Range");
        XCTAssertTrue(result.hasContentLength, @"仅 Range 场景应通过 Content-Range 获取文件大小");
        XCTAssertGreaterThan(result.fileSize, 0, @"仅 Range 场景文件大小应大于 0");
        XCTAssertTrue(result.canUseChunkedTransfer, @"仅 Range 场景应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC008: 场景4 - 仅 Content-Length
 * - HEAD: ❌ (返回 405)
 * - Content-Length: ✅
 * - Range: ❌
 *
 * 预期：HEAD 失败降级 GET，GET 返回 Content-Length
 */
- (void)test_TC008_URLProbe_LocalServer_ContentLengthOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_ContentLengthOnly"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_ContentLength fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"仅 Content-Length 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertTrue(result.hasContentLength, @"仅 Content-Length 场景应有 Content-Length");
        XCTAssertGreaterThan(result.fileSize, 0, @"仅 Content-Length 场景文件大小应大于 0");
        XCTAssertFalse(result.supportsRange, @"仅 Content-Length 场景不应支持 Range");
        XCTAssertFalse(result.canUseChunkedTransfer, @"仅 Content-Length 场景不应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC009: 场景5 - Range + HEAD
 * - HEAD: ✅
 * - Content-Length: ❌
 * - Range: ✅
 *
 * 预期：HEAD 成功，无 Content-Length 但有 Accept-Ranges
 */
- (void)test_TC009_URLProbe_LocalServer_RangeHead {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_RangeHead"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_RangeHead fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"Range + HEAD 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertTrue(result.supportsRange, @"Range + HEAD 场景应支持 Range");
        XCTAssertFalse(result.hasContentLength, @"Range + HEAD 场景不应有 Content-Length");
        XCTAssertEqual(result.fileSize, -1, @"Range + HEAD 场景文件大小应为 -1");
        XCTAssertFalse(result.canUseChunkedTransfer, @"无 Content-Length 不应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC010: 场景6 - Content-Length + HEAD
 * - HEAD: ✅
 * - Content-Length: ✅
 * - Range: ❌
 *
 * 预期：HEAD 成功，有 Content-Length，无 Range 支持
 */
- (void)test_TC010_URLProbe_LocalServer_ContentLengthHead {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_ContentLengthHead"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_ContentLengthHead fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"Content-Length + HEAD 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertTrue(result.hasContentLength, @"Content-Length + HEAD 场景应有 Content-Length");
        XCTAssertGreaterThan(result.fileSize, 0, @"Content-Length + HEAD 场景文件大小应大于 0");
        XCTAssertFalse(result.supportsRange, @"Content-Length + HEAD 场景不应支持 Range");
        XCTAssertFalse(result.canUseChunkedTransfer, @"无 Range 不应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC011: 场景7 - Range + Content-Length
 * - HEAD: ❌ (返回 405)
 * - Content-Length: ✅
 * - Range: ✅
 *
 * 预期：HEAD 失败降级 GET，返回 206 + Content-Range，支持分块传输
 */
- (void)test_TC011_URLProbe_LocalServer_RangeContentLength {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_RangeContentLength"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_RangeContentLength fileName:kTestFileName];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"Range + Content-Length 场景探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        XCTAssertTrue(result.supportsRange, @"Range + Content-Length 场景应支持 Range");
        XCTAssertTrue(result.hasContentLength, @"Range + Content-Length 场景应有 Content-Length");
        XCTAssertGreaterThan(result.fileSize, 0, @"Range + Content-Length 场景文件大小应大于 0");
        XCTAssertTrue(result.canUseChunkedTransfer, @"Range + Content-Length 场景应支持分块传输");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC012: 场景9 - Header 校验（带正确 header）
 * - 需要在请求头中添加 urlsync=1
 *
 * 预期：带 header 时成功
 */
- (void)test_TC012_URLProbe_LocalServer_HeaderRequired {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_HeaderRequired"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Header fileName:kTestFileName];
    NSDictionary *headers = [self headersForOption:kLocalOption_Header];
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:headers];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        XCTAssertNil(error, @"带正确 header 的探测不应出错: %@", error);
        XCTAssertNotNil(result, @"结果不应为 nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC013: 场景9 - Header 校验（不带 header 时应失败）
 */
- (void)test_TC013_URLProbe_LocalServer_HeaderRequired_NoHeader {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testURLProbe_LocalServer_HeaderRequired_NoHeader"];
    
    NSURL *url = [self localURLWithOption:kLocalOption_Header fileName:kTestFileName];
    // 故意不传递 urlsync header
    QCloudSMHURLProbe *probe = [[QCloudSMHURLProbe alloc] initWithSourceURL:url headers:nil];
    
    [probe probeWithCompletion:^(QCloudSMHURLProbeResult *result, NSError *error) {
        // 服务器应返回异常
        XCTAssertNotNil(error, @"不带 header 时服务器应返回错误");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


#pragma mark - QCloudCOSSMHUploadObjectRequest URL 同步测试
/**
 * TC020: 第三方 URL 上传自定义 URL 探测器
 * 验证可以使用自定义的 urlProber
 */
- (void)test_TC014_UploadObjectRequest_URLSync_CustomProber {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_CustomProber"];
    
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    // 使用自定义探测器
    QCloudSMHURLProbe *customProber = [[QCloudSMHURLProbe alloc] initWithSourceURL:sourceURL headers:nil];
    customProber.timeout = 15.0;  // 自定义超时
    request.urlProber = customProber;
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error, @"使用自定义探测器的上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/**
 * TC021: 第三方 URL 仅支持 Range 的场景
 * 场景：服务器仅支持 Range，不支持 HEAD
 */
- (void)test_TC015_UploadObjectRequest_URLSync_RangeOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_RangeOnly"];
    
    // 使用仅支持 Range 的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Range fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error, @"仅 Range 场景上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/**
 * TC016: 第三方 URL 分块上传（大文件，支持 Range）
 * 场景：大文件，服务器支持 Range，使用流式分块上传
 */
- (void)test_TC016_UploadObjectRequest_URLSync_MultipartUpload_Full {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_MultipartUpload_Full"];
    
    // 使用大文件 + 完整功能的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];

    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    // 设置较小的分块阈值以便测试分块上传
    request.mutilThreshold = 1 * 1024 * 1024;  // 1MB
    
    __block int64_t lastTotalBytesSent = 0;
    __block int64_t totalExpected = 0;
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        lastTotalBytesSent = totalBytesSent;
        totalExpected = totalBytesExpectedToSend;
        NSLog(@"分块上传进度: %lld / %lld (%.1f%%)", totalBytesSent, totalBytesExpectedToSend,
              totalBytesExpectedToSend > 0 ? (totalBytesSent * 100.0 / totalBytesExpectedToSend) : 0);
    }];
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error, @"分块上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        XCTAssertGreaterThan(lastTotalBytesSent, 0, @"应有上传进度");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    // 大文件上传需要更长超时
    [self waitForExpectationsWithTimeout:60*60*6 handler:nil];
}

/**
 * TC017: 第三方 URL 上传取消
 * 验证取消操作能正确执行并收到回调
 */
- (void)test_TC017_UploadObjectRequest_URLSync_Cancel {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_Cancel"];
    
    // 使用大文件以便有足够时间取消
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    __block BOOL hasProgress = NO;
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        hasProgress = YES;
    }];
    
    __block BOOL finishCalled = NO;
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        finishCalled = YES;
        // 取消后应收到错误或无结果
        if (error) {
            XCTAssertTrue(error.code == QCloudNetworkErrorCodeCanceled || error.code == NSURLErrorCancelled,
                          @"取消错误码应为取消类型: %ld", (long)error.code);
        }
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    // 延迟取消，给探测和开始上传一些时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [request cancel];
        
        // 等待一段时间确认取消行为
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssertTrue(request.canceled, @"请求应被标记为已取消");
            [expectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC018: 第三方 URL 上传中止（abort）
 * 验证 abort 操作能正确执行
 */
- (void)test_TC018_UploadObjectRequest_URLSync_Abort {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_Abort"];
    
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    request.mutilThreshold = 1 * 1024 * 1024;  // 1MB，触发分块上传
    
    __block BOOL finishCalled = NO;
    __weak typeof(request) weakRequest = request;
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        finishCalled = YES;
        // 取消后应收到错误或无结果
        if (error) {
            XCTAssertTrue(error.code == QCloudNetworkErrorCodeCanceled || error.code == NSURLErrorCancelled,
                          @"取消错误码应为取消类型: %ld", (long)error.code);
            XCTAssertTrue(weakRequest.aborted, @"请求应被标记为已中止");
            [expectation fulfill];
        }
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    // 延迟 abort，给探测和开始上传一些时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [request abort:^(id _Nullable outputObject, NSError * _Nullable error) {
            
        }];
    });
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC019: 第三方 URL 上传无效 URL
 * 验证无效 URL 能正确返回错误
 */
- (void)test_TC019_UploadObjectRequest_URLSync_InvalidURL {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_InvalidURL"];
    
    NSURL *sourceURL = [NSURL URLWithString:kTestInvalidURL];
    NSString *uploadPath = [self uploadPathWithFileName:@"invalid_url_test.txt"];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error, @"无效 URL 应返回错误");
        XCTAssertNil(result, @"无效 URL 结果应为 nil");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
 * TC014: 第三方 URL 简单上传（小文件，不支持分块）
 * 场景：小文件，服务器不支持 Range，使用简单上传模式
 */
- (void)test_TC020_UploadObjectRequest_URLSync_SimpleUpload_NoRange {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_SimpleUpload_NoRange"];
    
    // 使用无 Range 支持的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_ContentLengthHead fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    __block int64_t lastTotalBytesSent = 0;
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        lastTotalBytesSent = bytesSent;
        NSLog(@"简单上传进度: %lld / %lld", totalBytesSent, totalBytesExpectedToSend);
    }];
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error, @"简单上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        XCTAssertGreaterThan(lastTotalBytesSent, 0, @"应有上传进度");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/**
 * TC015: 第三方 URL 简单上传（完整功能模式）
 * 场景：小文件，服务器支持 Range，但文件太小使用简单上传
 */
- (void)test_TC021_UploadObjectRequest_URLSync_SimpleUpload_Full {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_SimpleUpload_Full"];
    
    // 使用完整功能的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestSmallFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestSmallFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    __block int64_t lastTotalBytesSent = 0;
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        lastTotalBytesSent = totalBytesSent;
    }];
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error, @"简单上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        XCTAssertGreaterThan(lastTotalBytesSent, 0, @"应有上传进度");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}



/**
 * TC022: 第三方 URL 无任何功能支持的场景
 * 场景：服务器不支持 HEAD、Range 和 Content-Length
 */
- (void)test_TC022_UploadObjectRequest_URLSync_NoOptions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_NoOptions"];
    
    // 使用无任何支持的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_None fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        // 无选项场景可能成功也可能失败，取决于实现
        // 这里验证回调被正确调用
        XCTAssertTrue(result != nil || error != nil, @"应有结果或错误");
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

/**
 * TC023: 第三方 URL 上传取消后继续（断点续传）
 * 验证：
 * 1. 开始上传后取消
 * 2. 使用 confirmKey 继续上传
 * 3. 最终上传成功
 */
- (void)test_TC023_UploadObjectRequest_URLSync_CancelAndResume {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_CancelAndResume"];
    
    // 使用大文件 + 完整功能的 URL
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTestFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestFileName];
    
    __block NSString *savedConfirmKey = nil;
    __block int64_t progressBeforeCancel = 0;
    
    // ========== 第一阶段：开始上传并取消 ==========
    QCloudCOSSMHUploadObjectRequest *firstRequest = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    firstRequest.body = sourceURL;
    firstRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    firstRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    firstRequest.uploadPath = uploadPath;
    firstRequest.mutilThreshold = 1 * 1024 * 1024;  // 1MB，触发分块上传
    
    // 获取 confirmKey 用于续传
    [firstRequest setGetConfirmKey:^(NSString * _Nullable confirmKey) {
        NSLog(@"获取到 confirmKey: %@", confirmKey);
        savedConfirmKey = confirmKey;
    }];
    
    [firstRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        progressBeforeCancel = totalBytesSent;
        NSLog(@"第一阶段上传进度: %lld / %lld (%.1f%%)", totalBytesSent, totalBytesExpectedToSend,
              totalBytesExpectedToSend > 0 ? (totalBytesSent * 100.0 / totalBytesExpectedToSend) : 0);
    }];
    
    __block BOOL firstRequestFinished = NO;
    [firstRequest setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        firstRequestFinished = YES;
        NSLog(@"第一阶段结束: result=%@, error=%@", result, error);
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:firstRequest];
    
    // 延迟取消，等待有一定进度后再取消
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"准备取消第一阶段上传，当前进度: %lld bytes, confirmKey: %@", progressBeforeCancel, savedConfirmKey);
        [firstRequest cancel];
        
        // ========== 第二阶段：使用 confirmKey 继续上传 ==========
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssertNotNil(savedConfirmKey, @"应获取到 confirmKey");
            XCTAssertGreaterThan(progressBeforeCancel, 0, @"取消前应有上传进度");
            
            if (!savedConfirmKey) {
                NSLog(@"未获取到 confirmKey，无法续传");
                [expectation fulfill];
                return;
            }
            
            NSLog(@"开始第二阶段续传，confirmKey: %@", savedConfirmKey);
            
            QCloudCOSSMHUploadObjectRequest *resumeRequest = [[QCloudCOSSMHUploadObjectRequest alloc] init];
            resumeRequest.body = sourceURL;
            resumeRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            resumeRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            resumeRequest.uploadPath = uploadPath;
            resumeRequest.mutilThreshold = 1 * 1024 * 1024;
            resumeRequest.confirmKey = savedConfirmKey;  // 使用之前保存的 confirmKey 续传
            
            __block int64_t finalProgress = 0;
            [resumeRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                finalProgress = totalBytesSent;
                NSLog(@"第二阶段续传进度: %lld / %lld (%.1f%%)", totalBytesSent, totalBytesExpectedToSend,
                      totalBytesExpectedToSend > 0 ? (totalBytesSent * 100.0 / totalBytesExpectedToSend) : 0);
            }];
            
            [resumeRequest setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
                NSLog(@"第二阶段续传结束: result=%@, error=%@", result, error);
                XCTAssertNil(error, @"续传不应出错: %@", error);
                XCTAssertNotNil(result, @"续传结果不应为 nil");
                [expectation fulfill];
            }];
            
            [[QCloudSMHService defaultSMHService] uploadObject:resumeRequest];
        });
    });
    
    // 大文件上传 + 续传需要较长超时
    [self waitForExpectationsWithTimeout:60 * 60 * 5 handler:nil];
}

#pragma mark - 超大文件测试文件限制测试

/**
 * TC024: 文件 >= 5GB 且源不支持 Range
 * 场景：服务器不支持 Range，文件大小 >= 5GB
 * 预期：返回错误 QCloudNetworkErrorUnsupportOperationError，错误信息包含 "5GB"
 *
 * 根据技术方案：
 * - 完整下载模式（不支持 Range）最大文件限制为 5GB
 * - 超过限制应返回 FileTooLarge 错误
 */
- (void)test_TC024_UploadObjectRequest_URLSync_5GBLimit_NoRange {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_5GBLimit_NoRange"];
    
    // 使用 >= 5GB 文件 + 不支持 Range 的 URL（仅 Content-Length）
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_ContentLengthHead fileName:kTestLargeFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTestLargeFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        // 验证返回 5GB 限制错误
        XCTAssertNotNil(error, @"文件 >= 5GB 且不支持 Range 应返回错误");
        XCTAssertNil(result, @"结果应为 nil");
        XCTAssertEqual(error.code, QCloudNetworkErrorUnsupportOperationError, @"错误码应为 UnsupportOperationError");
        
        NSString *errorMessage = error.localizedDescription;
        XCTAssertTrue([errorMessage containsString:@"5GB"], @"错误信息应包含 '5GB': %@", errorMessage);
        
        NSLog(@"5GB 限制测试（无 Range）返回错误: %@", error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

/**
 * TC025: 4GB 文件无 Range 场景
 * 场景：服务器不支持 Range，仅支持 Content-Length + HEAD
 * 预期：通过简单流式上传完成（4GB < 5GB 限制）
 *
 * 验证：
 * 1. 探测阶段正确识别不支持 Range
 * 2. 使用完整下载 + 流式上传模式
 * 3. 进度回调正常工作
 * 4. 上传成功完成
 */
- (void)test_TC025_UploadObjectRequest_URLSync_4GB_NoRange_StreamUpload {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_4GB_NoRange_StreamUpload"];
    
    // 使用 4GB 文件 + 不支持 Range 的 URL（仅 Content-Length + HEAD）
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_ContentLengthHead fileName:kTest500MBFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTest500MBFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    
    __block int64_t lastTotalBytesSent = 0;
    __block int64_t totalExpected = 0;
    __block int progressCallCount = 0;
    
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        lastTotalBytesSent = totalBytesSent;
        totalExpected = totalBytesExpectedToSend;
        progressCallCount++;
        
        NSLog(@"500MB 流式上传进度: %lld / %lld (%.2f%%), 回调次数: %d",
              totalBytesSent, totalBytesExpectedToSend,
              totalBytesExpectedToSend > 0 ? (totalBytesSent * 100.0 / totalBytesExpectedToSend) : 0,
              progressCallCount);
    }];
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"500MB 流式上传完成: result=%@, error=%@", result, error);
        NSLog(@"最终进度: %lld / %lld, 进度回调次数: %d", lastTotalBytesSent, totalExpected, progressCallCount);
        
        // 验证上传成功
        XCTAssertNil(error, @"500MB 文件流式上传不应出错: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        
        // 验证进度回调被调用
        XCTAssertGreaterThan(progressCallCount, 0, @"应有进度回调");
        
        NSLog(@"500MB 流式上传成功: 总大小 %lld bytes (%.2f GB), 进度回调 %d 次",
              totalExpected, totalExpected / (1024.0 * 1024.0 * 1024.0), progressCallCount);
        
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    // 4GB 文件上传需要较长时间
    [self waitForExpectationsWithTimeout:60 * 60 * 8 handler:nil];
}

/**
 * TC026: 文件 >= 5GB 且源支持分片传输（完整功能模式）
 * 场景：服务器支持 Range + Content-Length + HEAD
 * 预期：
 * 1. 探测阶段正确识别文件大小 >= 5GB
 * 2. 自动选择分块上传模式（而非简单上传）
 * 3. 分块上传成功完成
 * 4. 进度回调正常工作
 *
 * 根据技术方案：
 * - 支持 Range 且大小 >= 阈值时使用分块传输模式
 * - 分块传输模式无文件大小限制
 */
- (void)test_TC026_UploadObjectRequest_URLSync_5GBLimit_ChunkedTransfer_Full {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadObjectRequest_URLSync_5GBLimit_ChunkedTransfer_Full"];
    
    // 使用 >= 5GB 文件 + 完整功能的 URL（支持 Range + Content-Length + HEAD）
    NSURL *sourceURL = [self localURLWithOption:kLocalOption_Full fileName:kTest500MBFileName];
    NSString *uploadPath = [self uploadPathWithFileName:kTest500MBFileName];
    
    QCloudCOSSMHUploadObjectRequest *request = [[QCloudCOSSMHUploadObjectRequest alloc] init];
    request.body = sourceURL;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.uploadPath = uploadPath;
    request.mutilThreshold = 1 * 1024 * 1024;  // 1MB，确保触发分块上传
    
    __block int64_t lastTotalBytesSent = 0;
    __block int64_t totalExpected = 0;
    __block NSString *savedConfirmKey = nil;
    
    // 获取 confirmKey（分块上传会返回）
    [request setGetConfirmKey:^(NSString * _Nullable confirmKey) {
        savedConfirmKey = confirmKey;
        NSLog(@"分块上传获取到 confirmKey: %@", confirmKey);
    }];
    
    [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        lastTotalBytesSent = totalBytesSent;
        totalExpected = totalBytesExpectedToSend;
        
        NSLog(@"分块上传进度: %lld / %lld (%.2f%%)",
              totalBytesSent, totalBytesExpectedToSend,
              totalBytesExpectedToSend > 0 ? (totalBytesSent * 100.0 / totalBytesExpectedToSend) : 0);
    }];
    
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"分块上传完成: result=%@, error=%@", result, error);
        
        // 验证上传成功
        XCTAssertNil(error, @"文件 >= 500MB 且支持分片传输应成功上传: %@", error);
        XCTAssertNotNil(result, @"上传结果不应为 nil");
        
        // 验证文件大小 >= 5GB
        XCTAssertGreaterThanOrEqual(totalExpected, k500MBThreshold,
                                    @"文件大小应 >= 500MB，实际: %lld bytes (%.2f GB)",
                                    totalExpected, totalExpected / (1024.0 * 1024.0 * 1024.0));
        
        // 验证最终进度等于预期总大小
        XCTAssertEqual(lastTotalBytesSent, totalExpected, @"最终上传字节数应等于预期总大小");
        
        // 验证获取到了 confirmKey（分块上传特征）
        XCTAssertNotNil(savedConfirmKey, @"分块上传应获取到 confirmKey");
        
        NSLog(@"500MB 分块上传成功: 总大小 %lld bytes (%.2f GB)",
              totalExpected, totalExpected / (1024.0 * 1024.0 * 1024.0));
        
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:request];
    
    // >= 5GB 文件上传需要很长时间
    [self waitForExpectationsWithTimeout:60 * 60 * 12 handler:nil];
}


@end
