//
//  QCloudSMHFileNewApiV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHConvertFileRequest.h"
#import "QCloudSMHPreviewFileRequest.h"
#import "QCloudSMHDownloadTranscodedVideoRequest.h"
#import "QCloudSMHGetDeltaCursorRequest.h"
#import "QCloudSMHQueryDeltaLogRequest.h"
#import "QCloudSMHEmptyHistoryRequest.h"
#import "QCloudSMHGetDirectoryStatsRequest.h"
#import "QCloudSMHCalibrateDirectoryStatsRequest.h"
#import "QCloudSMHPutDirectoryRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"

/// 上传的真实视频文件路径
static NSString *const kUploadedVideoPath = @"codegen_video_test/test_video.mp4";
/// 上传的 PDF 文件路径（用于 convert/preview 测试）
static NSString *const kUploadedPdfPath = @"codegen_video_test/testpdf.pdf";
/// 上传的 txt 文件路径（用于 convert 测试，源文件必须是 .txt/.doc/.docx）
static NSString *const kUploadedTxtPath = @"codegen_video_test/test_convert.txt";

@interface QCloudSMHFileNewApiV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHFileNewApiV2Tests

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

#pragma mark - 辅助方法：上传真实视频文件

- (void)uploadRealVideoFileWithCompletion:(void (^)(NSError *error))completion {
    // 先创建目录
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_video_test";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        // 使用项目中的测试视频文件（相对路径）
        NSString *videoPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test_video" ofType:@"mp4"];
        if (!videoPath || ![[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            completion([NSError errorWithDomain:@"TestError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"找不到测试视频文件 test_video.mp4"}]);
            return;
        }
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        // 上传视频文件
        QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
        uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        uploadReq.uploadPath = kUploadedVideoPath;
        uploadReq.body = videoURL;
        uploadReq.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
        [uploadReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            completion(error);
        }];
        [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
}

#pragma mark - 辅助方法：上传 PDF 文件（用于 convert/preview 测试）

- (void)uploadPdfFileWithCompletion:(void (^)(NSError *error))completion {
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_video_test";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        NSString *textPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testpdf" ofType:@"pdf"];
        if (!textPath || ![[NSFileManager defaultManager] fileExistsAtPath:textPath]) {
            completion([NSError errorWithDomain:@"TestError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"找不到测试文件 testpdf.pdf"}]);
            return;
        }
        NSURL *textURL = [NSURL fileURLWithPath:textPath];
        QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
        uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        uploadReq.uploadPath = kUploadedPdfPath;
        uploadReq.body = textURL;
        uploadReq.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
        [uploadReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            completion(error);
        }];
        [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
}

#pragma mark - 辅助方法：上传 txt 文件（用于 convert 测试）

- (void)uploadTxtFileWithCompletion:(void (^)(NSError *error))completion {
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_video_test";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
        uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        uploadReq.uploadPath = kUploadedTxtPath;
        uploadReq.body = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"test_word" ofType:@"txt"]];
        uploadReq.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
        [uploadReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            completion(error);
        }];
        [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
}

#pragma mark - File 转换/预览（先上传真实视频文件）

- (void)testQCloudSMHConvertFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ConvertFileRequest"];
    [self uploadTxtFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传 txt 文件失败: %@", uploadError);
        QCloudSMHConvertFileRequest *request = [QCloudSMHConvertFileRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = @"codegen_video_test/converted.pdf";
        request.convertFrom = kUploadedTxtPath;
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] convertFile:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

- (void)testQCloudSMHPreviewFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"PreviewFileRequest"];
    [self uploadPdfFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传 PDF 文件失败: %@", uploadError);
        QCloudSMHPreviewFileRequest *request = [QCloudSMHPreviewFileRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = kUploadedPdfPath;
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] previewFile:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

- (void)testQCloudSMHDownloadTranscodedVideoRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DownloadTranscodedVideoRequest"];
    [self uploadRealVideoFileWithCompletion:^(NSError *uploadError) {
        XCTAssertNil(uploadError, @"上传视频文件失败: %@", uploadError);
        QCloudSMHDownloadTranscodedVideoRequest *request = [QCloudSMHDownloadTranscodedVideoRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = kUploadedVideoPath;
        request.transcodingTemplateId = @"h264_720p";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] downloadTranscodedVideo:request];
    }];
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

#pragma mark - Delta 增量

- (void)testQCloudSMHGetDeltaCursorRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetDeltaCursorRequest"];
    QCloudSMHGetDeltaCursorRequest *request = [QCloudSMHGetDeltaCursorRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(QCloudSMHDeltaCursorInfo *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getDeltaCursor:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHQueryDeltaLogRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"QueryDeltaLogRequest"];
    QCloudSMHGetDeltaCursorRequest *cursorRequest = [QCloudSMHGetDeltaCursorRequest new];
    cursorRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    cursorRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [cursorRequest setFinishBlock:^(id _Nullable cursorResult, NSError *_Nullable cursorError) {
        XCTAssertNil(cursorError);
        XCTAssertNotNil(cursorResult);
        NSString *cursor = [cursorResult valueForKey:@"cursor"];
        if (!cursor) {
            XCTFail(@"获取 cursor 失败");
            [expectation fulfill];
            return;
        }
        QCloudSMHQueryDeltaLogRequest *request = [QCloudSMHQueryDeltaLogRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.cursor = cursor;
        [request setFinishBlock:^(QCloudSMHDeltaLogResult *_Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] queryDeltaLog:request];
    }];
    [[QCloudSMHService defaultSMHService] getDeltaCursor:cursorRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - History

- (void)testQCloudSMHEmptyHistoryRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"EmptyHistoryRequest"];
    QCloudSMHEmptyHistoryRequest *request = [QCloudSMHEmptyHistoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] emptyHistory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - Directory Stats（先创建真实目录）

- (void)testQCloudSMHGetDirectoryStatsRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetDirectoryStatsRequest"];
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_test_dir";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        QCloudSMHGetDirectoryStatsRequest *request = [QCloudSMHGetDirectoryStatsRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = @"codegen_test_dir";
        request.statsType = @"normal";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] getDirectoryStats:request];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHCalibrateDirectoryStatsRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CalibrateDirectoryStatsRequest"];
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_test_dir";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        QCloudSMHCalibrateDirectoryStatsRequest *request = [QCloudSMHCalibrateDirectoryStatsRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.filePath = @"codegen_test_dir";
        request.statsType = @"normal";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] calibrateDirectoryStats:request];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
