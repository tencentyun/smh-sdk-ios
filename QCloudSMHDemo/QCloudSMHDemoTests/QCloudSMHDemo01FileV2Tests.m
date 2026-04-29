//
//  QCloudSMHDemo01FileV2Tests.m
//  QCloudSMHDemo01FileV2Tests
//
//  Created by garenwang on 2022/5/12.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "NSData+SHA256.h"
#import "NSObject+Equal.h"
#import "QCloudSMHCheckHostRequest.h"
#import "QCloudSMHGetINodeDetailRequest.h"
#import "QCloudSMHGetRecentlyUsedFileRequest.h"
#import "QCloudSMHDeleteFileRequest.h"
#import "QCloudSMHCopyFileRequest.h"
#import "QCloudSMHRenameFileRequest.h"
#import "QCloudSMHDetailDirectoryRequest.h"
#import "QCloudSMHListContentsRequest.h"
#import "QCloudSMHCompleteUploadRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"
#import "QCloudSMHGetDownloadInfoRequest.h"
#import "QCloudSMHFileDeletionCheckRequest.h"
#import "QCloudSMHFileDeletionCheckResult.h"
#import "QCloudSMHErrorCode.h"
#import "NSObject+QCloudModel.h"

static NSString * testDirName = @"iosunittestDir";
static NSString * testFileName = @"testFile";
static NSString * testContentCasFile = @"testContentCasFile";

@interface QCloudSMHDemo01FileV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHDemo01FileV2Tests

- (void)setUp {
    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/",QCloudSMHTestTools.singleTool.getBaseUrlStrV2] targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    self.fenceQueue = [QCloudSMHAccessTokenFenceQueue new];
    self.fenceQueue.delegate = self;
    [QCloudSMHService defaultSMHService].accessTokenProvider = self;
    
}

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    
    QCloudSMHSpaceInfo * spaceinfo = [QCloudSMHSpaceInfo new];
    spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    spaceinfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    continueBlock(spaceinfo,nil);
}

-(void)test01CreateDirectory1{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test01CreateDirectory1"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = testDirName;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"SameNameDirectoryOrFileExists"]);
        }else{
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test02UploadSimpleFile1{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test02UploadSimpleFile_1"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];

    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

-(void)testQCloudUpdateDirectoryTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateDirectoryTagRequest"];
    QCloudUpdateDirectoryTagRequest * request = [QCloudUpdateDirectoryTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.dirPath = testDirName;
    request.labels = @[@"label1",@"label1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] updateDirectoryTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetSpaceHomeFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetSpaceHomeFileRequest"];
    QCloudSMHGetSpaceHomeFileRequest * request = [QCloudSMHGetSpaceHomeFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.directoryFilter = QCloudSMHDirectoryOnlyDir;
    [request setFinishBlock:^(QCloudSMHSpaceHomeFileInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getSpaceHomeFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudUpdateFileTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateFileTagRequest"];
    QCloudUpdateFileTagRequest * request = [QCloudUpdateFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    request.labels = @[@"label1",@"label1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] updateFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testQCloudSMHGetRecyclePresignedURLRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetRecyclePresignedURLRequest"];
    QCloudSMHGetRecyclePresignedURLRequest * request = [QCloudSMHGetRecyclePresignedURLRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.recycledItemId = 723074;
    request.size = 100;
    request.historyId = 1;
    request.type = @"pic";
    request.scale = 0.5;
    request.widthSize = 100;
    request.heightSize = 100;
    request.frameNumber = 100;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecyclePresignedURL:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetRecycleFileDetailReqeust{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetRecycleFileDetailReqeust"];
    QCloudSMHGetRecycleFileDetailReqeust * request = [QCloudSMHGetRecycleFileDetailReqeust new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.recycledItemId = 0;
    [request setFinishBlock:^(QCloudSMHRecycleObjectItemInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecycleFileDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSetSpaceTrafficLimitRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSetSpaceTrafficLimitRequest"];
    QCloudSetSpaceTrafficLimitRequest * request = [QCloudSetSpaceTrafficLimitRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.downloadTrafficLimit = 1 * 1024 * 1024;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] setSpaceTrafficLimit:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHFavoriteSpaceFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHFavoriteSpaceFileRequest"];
    QCloudSMHFavoriteSpaceFileRequest * request = [QCloudSMHFavoriteSpaceFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];

    [request setFinishBlock:^(QCloudSMHFavoriteSpaceFileResult * _Nullable result, NSError * _Nullable error) {
        QCloudSMHDeleteFavoriteSpaceFileRequest * request = [QCloudSMHDeleteFavoriteSpaceFileRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
        
        [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
            NSLog(@"%@",outputObject);
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] deleteFavoriteSpaceFile:request];
    }];
    [[QCloudSMHService defaultSMHService] favoriteSpaceFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testQCloudSMHListFavoriteSpaceFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHListFavoriteSpaceFileRequest"];
    QCloudSMHListFavoriteSpaceFileRequest * request = [QCloudSMHListFavoriteSpaceFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listFavoriteSpaceFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudGetSpaceUsageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudGetSpaceUsageRequest"];
    QCloudGetSpaceUsageRequest * request = [QCloudGetSpaceUsageRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceIds = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(NSArray<QCloudSMHSpaceUsageInfo *> * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getSpaceUsage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - withContentCas 和 contentCas 字段测试

- (void)testUploadAndDeleteFileWithContentCas {
    // 文件上传接口：设置 contentCas 和 withContentCas
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    __block NSString *contentCas = @"";
    __block NSString *innode = @"";
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    uploadReq.withInode = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        innode = result.inode;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 删除文件请求：设置 contentCas
    XCTestExpectation *deleteExpectation = [self expectationWithDescription:@"testDeleteFileWithContentCas"];
    QCloudSMHDeleteFileRequest *request = [QCloudSMHDeleteFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = path;
    request.contentCas = contentCas;
    [request setFinishBlock:^(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [deleteExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTestExpectation *getDeleteExpectation = [self expectationWithDescription:@"FileDeletionCheckRequest"];
    QCloudSMHFileDeletionCheckRequest *checkRequest = [QCloudSMHFileDeletionCheckRequest new];
    checkRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    checkRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    checkRequest.inode = innode;
    [checkRequest setFinishBlock:^(QCloudSMHFileDeletionCheckResult * _Nullable result, NSError * _Nullable error) {
        // 使用不存在的 inode，预期返回错误或 Unknown
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [getDeleteExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] fileDeletionCheck:checkRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testUploadAndCopyFileWithContentCas {
    // 文件上传接口：设置 contentCas 和 withContentCas
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    __block NSString *contentCas = @"";
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 复制文件请求：设置 contentCas 和 withContentCas
    XCTestExpectation *copyExpectation = [self expectationWithDescription:@"testCopyFileWithContentCas"];
    QCloudSMHCopyFileRequest *request = [QCloudSMHCopyFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = [@"/" stringByAppendingString:[NSString stringWithFormat:@"copy_%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    request.from = path;
    request.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    request.contentCas = contentCas;
    request.withContentCas = YES;
    [request setFinishBlock:^(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        [copyExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] copyFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testUploadAndRenameFileWithContentCas {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    __block NSString *contentCas = @"";
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 重命名文件请求：设置 contentCas 和 withContentCas
    XCTestExpectation *renameExpectation = [self expectationWithDescription:@"testRenameFileWithContentCas"];
    QCloudSMHRenameFileRequest *request = [QCloudSMHRenameFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = [@"/" stringByAppendingString:[NSString stringWithFormat:@"rename_%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    request.from = path;
    request.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    request.moveAuthority = YES;
    request.withContentCas = YES;
    request.contentCas = contentCas;
    [request setFinishBlock:^(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        [renameExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] renameFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testUploadAndGetINodeDetailWithContentCas {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    __block NSString *contentCas = @"";
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    __block NSString *innode = @"";
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    uploadReq.withInode = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        innode = result.inode;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 根据文件 ID 查看文件详情请求：设置 contentCas 和 withContentCas
    XCTestExpectation *getExpectation = [self expectationWithDescription:@"testGetINodeDetailWithContentCas"];
    QCloudSMHGetINodeDetailRequest *request = [QCloudSMHGetINodeDetailRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.iNode = innode;
    request.contentCas = contentCas;
    request.withContentCas = YES;
    [request setFinishBlock:^(QCloudSMHINodeDetailInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        [getExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getINodeDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testUploadAndDetailDirectoryWithContentCas {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    __block NSString *contentCas = @"";
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 查看文件详情请求（目录详情）：设置 withContentCas
    XCTestExpectation *detailExpectation = [self expectationWithDescription:@"testDetailDirectoryWithContentCas"];
    QCloudSMHDetailDirectoryRequest *request = [QCloudSMHDetailDirectoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = path;
    request.withInode = YES;
    request.withFavoriteStatus = YES;
    request.withContentCas = YES;
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        [detailExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] detailDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testListContentsWithContentCas {
    // 列出目录内容请求：设置 withContentCas
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListContentsWithContentCas"];
    QCloudSMHListContentsRequest *request = [QCloudSMHListContentsRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.dirPath = @"/";
    request.limit = 100;
    request.withInode = YES;
    request.withFavoriteStatus = YES;
    request.withContentCas = YES;
    __block BOOL isContentCas = NO;
    [request setFinishBlock:^(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        for (QCloudSMHContentInfo *info in result.contents) {
            if (info.contentCas.length > 0) {
                isContentCas = YES;
                break;
            }
        }
        XCTAssertTrue(isContentCas, @"contentCas 不能为空");
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listContents:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testUploadAndGetDownloadInfoWithContentCas {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFileWithContentCas"];
    NSString *path = [@"/" stringByAppendingString:[NSString stringWithFormat:@"%@_%@", @([NSDate.date timeIntervalSince1970]), testContentCasFile]];
    __block NSString *contentCas = @"";
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithRandomSizeFrom:1 * 1024 * 1024 to:5 * 1024 * 1024]];
    uploadReq.uploadPath = path;
    uploadReq.uploadBodyIsCompleted = YES;
    uploadReq.withContentCas = YES;
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertNotNil(result.contentCas, @"contentCas 不能为空");
        contentCas = result.contentCas;
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    // 获取下载信息请求：设置 contentCas 和 withContentCas
    XCTestExpectation *infoExpectation = [self expectationWithDescription:@"testGetDownloadInfoWithContentCas"];
    QCloudSMHGetDownloadInfoRequest *request = [QCloudSMHGetDownloadInfoRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.filePath = path;
    request.purpose = QCloudSMHPurposeDownload;
    request.historyId = 0;
    request.contentCas = contentCas;
    request.withContentCas = YES;
    [request setFinishBlock:^(QCloudSMHDownloadInfoModel * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [infoExpectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getDonwloadInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


@end
