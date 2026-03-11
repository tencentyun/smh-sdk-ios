//
//  QCloudSMHDemo01FileTests.m
//  QCloudSMHDemo01FileTests
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

static NSString * testDirName = @"iosunittestDir1";
static NSString * testTargetDirName = @"iosunittestTargetDir";
static NSString * testSimpleFile = @"testSimpleFile";
static NSString * testBigFile = @"testBigFile";

@interface QCloudSMHDemo01FileTests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHDemo01FileTests

- (void)setUp {

    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/",QCloudSMHTestTools.singleTool.getBaseUrlStrV1] targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    self.fenceQueue = [QCloudSMHAccessTokenFenceQueue new];
    self.fenceQueue.delegate = self;
    [QCloudSMHService defaultSMHService].accessTokenProvider = self;
    
}

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    
    QCloudSMHSpaceInfo * spaceinfo = [QCloudSMHSpaceInfo new];
    spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV1;
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    spaceinfo.spaceId =QCloudSMHTestTools.singleTool.getSpaceIdV1;
    continueBlock(spaceinfo,nil);
}

-(void)test01CreateDirectory{
    XCTestExpectation *expectation = [self expectationWithDescription:@"createDirectory"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = testDirName;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
        QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
        req.dirPath = testTargetDirName;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
            if (error) {
                XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"SameNameDirectoryOrFileExists"]);
            }else{
                XCTAssertNil(error);
                XCTAssertNotNil(contentInfo);
            }
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] putDirectory:req];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:req];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test02UploadSimpleFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:0.5 * 1024 *1024]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    uploadReq.uploadBodyIsCompleted = YES;

    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test02SimpleUploadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test03UploadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    uploadReq.body =[NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:0.5 * 1024 *1024]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test02BigUploadFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test03UploadFile"];
    
    __block NSString * _confirmKey;
    
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    NSInteger fileSize = 20 * 1024*1024 + arc4random_uniform(1000);
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:fileSize]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    uploadReq.uploadBodyIsCompleted = YES;
    
    [uploadReq setGetConfirmKey:^(NSString * _Nullable confirmKey) {
        _confirmKey = confirmKey;
    }];
    
    [uploadReq setPreviewSendProcessBlock:^(int64_t count, int64_t total, BOOL isStart) {
        
    }];
    
    [uploadReq setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (totalBytesSent > 5 * 1024*1024) {
            [uploadReq cancel];
            QCloudCOSSMHUploadObjectRequest *uploadReq1 = [QCloudCOSSMHUploadObjectRequest new];
            uploadReq1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
            uploadReq1.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
            uploadReq1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
            uploadReq1.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:fileSize]];
            uploadReq1.confirmKey = _confirmKey;
            uploadReq1.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
            uploadReq1.uploadBodyIsCompleted = YES;
            
            
            [uploadReq1 setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                [expectation fulfill];
            }];
            
            [[QCloudSMHService defaultSMHService] uploadObject:uploadReq1];
            
        }
    }];
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        NSLog(@"%@",error);
    }];
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}


-(void)test02AbortUploadFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test03UploadFile"];
    
    __block NSString * _confirmKey;
    
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:20 * 1024*1024 + arc4random_uniform(1000)]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    uploadReq.uploadBodyIsCompleted = YES;
    
    [uploadReq setGetConfirmKey:^(NSString * _Nullable confirmKey) {
        _confirmKey = confirmKey;
        uploadReq.confirmKey = confirmKey;
    }];
    
    [uploadReq setPreviewSendProcessBlock:^(int64_t count, int64_t total, BOOL isStart) {
        
    }];
    
    [uploadReq setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (totalBytesSent > 5 * 1024*1024) {
            [uploadReq abort:^(id outputObject, NSError *error) {
                
            }];
        }
    }];
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test03CopyFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFile1"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"copy_file_source";
    uploadReq.uploadBodyIsCompleted = YES;

    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testCopyFile"];
    QCloudSMHCopyObjectRequest *req = [QCloudSMHCopyObjectRequest new];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    
    QCloudSMHBatchCopyInfo *info = [QCloudSMHBatchCopyInfo new];
    info.from = @"copy_file_source";
    info.to = @"copy_file_source_target";
    info.conflictStrategy = QCloudSMHConflictStrategyEnumAsk;
    req.batchInfos = @[info];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue(result.status == QCloudSMHBatchTaskStatusSucceed);
        
        QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        
        NSMutableArray *batchInfos = [NSMutableArray array];
        
        QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
        
        info.path = @"copy_file_source";
        [batchInfos addObject:info];
        QCloudSMHBatchDeleteInfo *info1 = [QCloudSMHBatchDeleteInfo new];
        
        info1.path = @"copy_file_source_target";
        [batchInfos addObject:info1];

        req.batchInfos = [batchInfos copy];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            QCloudSMHRestoreRecycleObjectReqeust * request = [QCloudSMHRestoreRecycleObjectReqeust new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
            request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
            request.recycledItemId = result.result.firstObject.recycledItemId;
            [request setFinishBlock:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                XCTAssertNil(error);
                [expectation1 fulfill];
            }];
            
            [[QCloudSMHService defaultSMHService] restoreRecyleObject:request];
        }];
        [[QCloudSMHService defaultSMHService] deleteObject:req];
    }];
    [[QCloudSMHService defaultSMHService] copyObject:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test04MoveFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test04MoveFile1"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"move_file_source";
    uploadReq.uploadBodyIsCompleted = YES;

    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testMoveFile"];
    QCloudSMHMoveObjectRequest *req = [QCloudSMHMoveObjectRequest new];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    
    QCloudSMHBatchMoveInfo *info = [QCloudSMHBatchMoveInfo new];
    info.from = @"move_file_source";
    info.to = @"move_file_source_target";
    info.moveAuthority = YES;
    info.conflictStrategy = QCloudSMHConflictStrategyEnumRename;

    req.batchInfos =@[info];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        
        NSMutableArray *batchInfos = [NSMutableArray array];
        
        QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
        
        info.path = @"move_file_source";
        [batchInfos addObject:info];
        QCloudSMHBatchDeleteInfo *info1 = [QCloudSMHBatchDeleteInfo new];
        
        info1.path = @"move_file_source_target";
        [batchInfos addObject:info1];

        req.batchInfos = [batchInfos copy];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation1 fulfill];
        }];
        [[QCloudSMHService defaultSMHService] deleteObject:req];
    }];
    [[QCloudSMHService defaultSMHService] moveObject:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test05RenameFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"rename_file_source";
    uploadReq.uploadBodyIsCompleted = YES;

    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHRenameFileRequest *req = [QCloudSMHRenameFileRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    req.from = @"/rename_file_source";
    req.filePath = @"/rename_file_source_target";
    req.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    [req setFinishBlock:^(QCloudSMHRenameResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        
        NSMutableArray *batchInfos = [NSMutableArray array];
        
        QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
        
        info.path = @"rename_file_source";
        [batchInfos addObject:info];
        QCloudSMHBatchDeleteInfo *info1 = [QCloudSMHBatchDeleteInfo new];
        
        info1.path = @"rename_file_source_target";
        [batchInfos addObject:info1];

        req.batchInfos = [batchInfos copy];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation1 fulfill];
        }];
        [[QCloudSMHService defaultSMHService] deleteObject:req];
    }];
    [[QCloudSMHService defaultSMHService] renameFile:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test06GetFileDetailURL{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"file_detail";
    uploadReq.uploadBodyIsCompleted = YES;

    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testGetFileDetailURL"];
    QCloudSMHGetDownloadInfoRequest * requeset = [[QCloudSMHGetDownloadInfoRequest alloc]init];
    requeset.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    requeset.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    requeset.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    requeset.filePath = @"file_detail";
    [requeset setFinishBlock:^(QCloudSMHDownloadInfoModel * outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue(outputObject.size.integerValue == 2 * 1024*1024);
        QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        
        NSMutableArray *batchInfos = [NSMutableArray array];
        
        QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
        
        info.path = @"file_detail";
        [batchInfos addObject:info];

        req.batchInfos = [batchInfos copy];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation1 fulfill];
        }];
        [[QCloudSMHService defaultSMHService] deleteObject:req];
    }];
    [[QCloudSMHService defaultSMHService] getDonwloadInfo:requeset];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

//-(void)test07DeleteFile{
//    XCTestExpectation *expectation = [self expectationWithDescription:@"deleteFile1"];
//    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
//    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
//    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
//    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
//    uploadReq.body =[NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
//    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:@"deleteFile"]];
//    
//    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(result);
//        [expectation fulfill];
//    }];
//    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//    
//    XCTestExpectation *expectation1 = [self expectationWithDescription:@"deleteFile2"];
//    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
//    QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
//    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
//    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
//    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
//    
//    NSMutableArray *batchInfos = [NSMutableArray array];
//    
//    QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
//    
//    info.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:@"deleteFile"]];
//    [batchInfos addObject:info];
//
//    req.batchInfos = [batchInfos copy];
//    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(result);
//        [expectation1 fulfill];
//    }];
//    [[QCloudSMHService defaultSMHService] deleteObject:req];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}

-(void)test08DownloadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDownloadFile"];
    QCloudSMHDownloadFileRequest *req = [QCloudSMHDownloadFileRequest new];

    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    __block NSInteger contentlength = 0;
    [req setResponseHeader:^(NSDictionary *_Nonnull header) {
        contentlength = [header[@"Content-Length"] integerValue];
    }];

    [req setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue([outputObject[@"Content-Length"] integerValue] == contentlength);
        [expectation fulfill];
    }];

    [[QCloudSMHService defaultSMHService] downloadFile:req];
    [self waitForExpectationsWithTimeout:200 handler:nil];
}

-(void)test08DownloadBigFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test08DownloadBigFile"];
    QCloudSMHDownloadFileRequest *req = [QCloudSMHDownloadFileRequest new];

    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.downloadingURL = [NSURL URLWithString:[QCloudDocumentsPath() stringByAppendingString:[NSString stringWithFormat:@"%@_test_1",NSDate.now]]];
    __block NSInteger contentlength = 0;
    [req setResponseHeader:^(NSDictionary *_Nonnull header) {
        contentlength = [header[@"Content-Length"] integerValue];
    }];

    [req setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue([outputObject[@"Content-Length"] integerValue] == contentlength);
        [expectation fulfill];
    }];

    [[QCloudSMHService defaultSMHService] downloadFile:req];
    [self waitForExpectationsWithTimeout:200 handler:nil];
}

-(void)test08ResumeDownloadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test08ResumeDownloadFile"];
    QCloudSMHDownloadFileRequest *req = [QCloudSMHDownloadFileRequest new];
    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    __block NSInteger contentlength = 0;
    [req setResponseHeader:^(NSDictionary *_Nonnull header) {
        contentlength = [header[@"Content-Length"] integerValue];
    }];
    
    [req setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        if (totalBytesDownload > 1 * 1024 * 1024) {
            [req cancel];
            [expectation fulfill];
        }
    }];

    [req setFinishBlock:^(id outputObject, NSError *error) {
    }];

    [[QCloudSMHService defaultSMHService] downloadFile:req];
    [self waitForExpectationsWithTimeout:200 handler:nil];
    
    QCloudSMHDownloadFileRequest *req1 = [QCloudSMHDownloadFileRequest new];

    XCTestExpectation *expectation1 = [self expectationWithDescription:@"test08ResumeDownloadFile1"];
    req1.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    req1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    [req1 setResponseHeader:^(NSDictionary *_Nonnull header) {
        contentlength = [header[@"Content-Length"] integerValue];
    }];

    [req1 setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue([outputObject[@"Content-Length"] integerValue] == contentlength);
        [expectation1 fulfill];
    }];

    [[QCloudSMHService defaultSMHService] downloadFile:req1];
    [self waitForExpectationsWithTimeout:200 handler:nil];
}


-(void)test09RestoreRecycleObjectList{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRecycleObjectList"];
    QCloudSMHGetRecycleObjectListReqeust *req = [QCloudSMHGetRecycleObjectListReqeust new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    
    req.limit = 200;
    req.sortType = QCloudSMHSortTypeCTimeReverse;
    [req setFinishBlock:^(QCloudSMHRecycleObjectListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if (result.contents.count == 0) {
            [expectation fulfill];
    
        }else{
            
            NSInteger recycledItemId = result.contents.firstObject.recycledItemId;
            
            QCloudSMHRestoreObjectRequest *req = [QCloudSMHRestoreObjectRequest new];
            req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
            req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
            
            req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
            
            req.batchInfos = @[@(recycledItemId)];
            [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] restoreObject:req];
        }
    }];
    [[QCloudSMHService defaultSMHService] getRecycleList:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test10MyAuthorizedDirectory{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testMyAuthorizedDirectory"];
    QCloudSMHGetMyAuthorizedDirectoryRequest *req = [QCloudSMHGetMyAuthorizedDirectoryRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    
    req.dirPath = @"/";
    req.limit = 200;
    [req setFinishBlock:^(QCloudSMHContentListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getMyAuthorizedDirectory:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void)test11GetRoleListTeamInfo {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testMyAuthorizedDirectory"];
    QCloudSMHGetRoleListRequest *request = [[QCloudSMHGetRoleListRequest alloc] init];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    [request setFinishBlock:^(NSArray<QCloudSMHRoleInfo *> * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result isKindOfClass:[NSArray class]]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRoleList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)test12GetlistContents {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetlistContents"];
    __block QCloudSMHListContentsRequest *req = [QCloudSMHListContentsRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    [req setFinishBlock:^(QCloudSMHContentListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listContents:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test13GetPreginURLFileObject{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetPreginURLFileObject"];
    QCloudSMHGetPresignedURLRequest *req = [QCloudSMHGetPresignedURLRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.priority = QCloudAbstractRequestPriorityHigh;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testSimpleFile stringByAppendingString:@"_move"]]];
    req.historyId = @"1";
    req.scale = 0.5;
    req.widthSize = 100;
    req.heightSize = 100;
    req.frameNumber = 100;
    [req setFinishBlock:^(NSString *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result isKindOfClass:[NSString class]] && result.length > 0);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getPresignedURL:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test14QuickUpload{
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"test03UploadFile"];
    
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    NSInteger fileSize = 20 * 1024*1024;
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:fileSize]];
    uploadReq.uploadPath = @"QuickUploadFile";
    uploadReq.uploadBodyIsCompleted = YES;
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        [expectation1 fulfill];
    }];
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQuickUpload"];
    
    NSInteger size = 1*1024 *1024;
    NSInteger datalenght = 20*1024 *1024;
    NSURL * bodyURL = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:20*1024*1024]];
    
    NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:bodyURL.path];
    NSData *data = [handler readDataOfLength:size];
    uint8_t * beginningHash = [data qcloudSha256Bytes];
    NSString *beginningHashString = [NSData qcloudSha256BytesTostring:beginningHash];
    
    QCloudSMHQuickPutObjectRequest * request = [QCloudSMHQuickPutObjectRequest new];
    request.createionDate = [self createDate];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    request.filePath = @"QuickUploadFile_2";
    request.beginningHash = beginningHashString;
    request.fileSize = @(20 * 1024 *1024).stringValue;
    request.finishBlock = ^(id outputObject, NSError *error) {
        
        NSHTTPURLResponse * response = [outputObject __originHTTPURLResponse__];
        
        XCTAssertNil(error);
        XCTAssertTrue(response.statusCode == 202);
        
        NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:bodyURL.path];
        uint8_t * fullHash = beginningHash;
        for (NSInteger i = size; i < datalenght; i += size) {
            [handler seekToFileOffset:i];
            NSData *data = [handler readDataOfLength:MIN(size, datalenght - i)];
            NSMutableData * mdata = [NSMutableData dataWithBytes:fullHash length:32];
            [mdata appendData:data];
            fullHash = [mdata qcloudSha256Bytes];
        }
        QCloudSMHQuickPutObjectRequest * request1 = [QCloudSMHQuickPutObjectRequest new];
        request1.createionDate = [self createDate];
        request1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        request1.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
        request1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        request1.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        request1.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testSimpleFile stringByAppendingString:@"_quick"]]];
        
        request1.beginningHash = beginningHashString;
        request1.fullHash = [NSData qcloudSha256BytesTostring:fullHash];
        request1.fileSize = @(datalenght).stringValue;
        request1.finishBlock = ^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(outputObject);
            NSHTTPURLResponse * response = [outputObject __originHTTPURLResponse__];
            XCTAssertTrue(response.statusCode == 200 && outputObject[@"data"]);
            [expectation fulfill];
        };
        [[QCloudSMHService defaultSMHService ] smhQuickPutObject:request1];
    };
    [[QCloudSMHService defaultSMHService ] smhQuickPutObject:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(NSString *)createDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'T' HH:mm:ss Z"];
    return [dateFormatter stringFromDate:NSDate.new];
}

-(void)test15DeleteDir{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = @"deleteDir";
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
        QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        
        req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        
        NSMutableArray *batchInfos = [NSMutableArray array];
        
        QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
        
        info.path = @"deleteDir";
        [batchInfos addObject:info];

        req.batchInfos = [batchInfos copy];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService]deleteObject:req];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:req];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test16DeleteRecycleObject{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRecycleObjectList"];
    QCloudSMHGetRecycleObjectListReqeust *req = [QCloudSMHGetRecycleObjectListReqeust new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    
    req.limit = 200;
    req.sortType = QCloudSMHSortTypeCTimeReverse;
    [req setFinishBlock:^(QCloudSMHRecycleObjectListInfo *_Nullable result, NSError *_Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if (result.contents.count == 0) {
            [expectation fulfill];
            return;
        }

        NSInteger recycledItemId = result.contents.firstObject.recycledItemId;
        
        QCloudSMHBatchDeleteRecycleObjectReqeust *req1 = [QCloudSMHBatchDeleteRecycleObjectReqeust new];
        req1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        req1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
        req1.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        req1.recycledItemIds = @[@(recycledItemId)];
        [req1 setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(outputObject);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] batchDeleteRecycleObject:req1];
    }];
    [[QCloudSMHService defaultSMHService] getRecycleList:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test17CrossCopy{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCrossCopy"];
    QCloudSMHCrossSpaceAsyncCopyDirectoryRequest *req = [QCloudSMHCrossSpaceAsyncCopyDirectoryRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    req.dirPath = testDirName;
    req.from = testDirName;
    req.fromSpaceId = @"space1d18pweh1rw2u";
    req.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"SourceDirectoryNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] crossSpaceAsyncCopyDirectory:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
}

-(void)testExitFileAuthorize{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExitFileAuthorize"];
    QCloudSMHExitFileAuthorizeRequest * request = [QCloudSMHExitFileAuthorizeRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    QCloudSMHExitFileAuthorize * info = [QCloudSMHExitFileAuthorize new];
    info.name = @"观察者";
    info.userId = @"1";
    info.roleId = 1;
    request.authorizeTo = @[info];
    request.dirPath = @"/";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"]isEqualToString:@"RoleNotFound"]);
        }else{
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] exitFileAuthorize:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testHeadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHeadFile"];
    QCloudSMHHeadFileRequest * request = [QCloudSMHHeadFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] headFile:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test10QCloudSMHDeleteFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHeadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"test10QCloudSMHDeleteFileRequest";
    uploadReq.uploadBodyIsCompleted = YES;

    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        QCloudSMHDeleteFileRequest * request = [QCloudSMHDeleteFileRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
        request.filePath = @"test10QCloudSMHDeleteFileRequest";
        [request setFinishBlock:^(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNil(error);
            QCloudSMHDeleteRecycleObjectReqeust * request = [QCloudSMHDeleteRecycleObjectReqeust new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
            request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
            request.recycledItemId = result.recycledItemId;
            [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] deleteRecycleObject:request];
        }];
        [[QCloudSMHService defaultSMHService] deleteFile:request];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudSMHGetAlbumRequest{
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testExitFileAuthorize"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = @"testQCloudSMHGetAlbumRequest";
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"SameNameDirectoryOrFileExists"]);
        }else{
            XCTAssertNil(error);
            XCTAssertNotNil(contentInfo);
        }
        [expectation1 fulfill];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExitFileAuthorize"];
    QCloudSMHGetAlbumRequest * request = [QCloudSMHGetAlbumRequest new];
    request.size = @"100";
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    request.albumName = @"testQCloudSMHGetAlbumRequest";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getAlbum:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudSMHEditFileOnlineRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHEditFileOnlineRequest"];
    QCloudSMHEditFileOnlineRequest * request = [QCloudSMHEditFileOnlineRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getEditFileOnlineUrl:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHCreateFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCreateFileRequest"];
    QCloudSMHCreateFileRequest * request = [QCloudSMHCreateFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    request.fromTemplate = QCloudSMHFileTemplateWord;
    request.filePath = @"test.doc";
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
            [expectation fulfill];
        }];
    
    [[QCloudSMHService defaultSMHService] createFileRequest:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHCheckHostRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCheckHostRequest"];
    QCloudSMHCheckHostRequest * request = [QCloudSMHCheckHostRequest new];
    request.host = @"https://api.test.tencentsmh.cn";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] checkHost:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHDeleteAuthorizeRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteAuthorizeRequest"];
    QCloudSMHDeleteAuthorizeRequest * request = [QCloudSMHDeleteAuthorizeRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.dirPath = @"/";
    
    QCloudSMHSelectRoleInfo * role = [[QCloudSMHSelectRoleInfo alloc]initWithType:QCloudSMHRoleMember targetId:@"1" roleId:1 name:@"观察者"];
    
    request.selectRoles = @[role];
    
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"]isEqualToString:@"RoleNotFound"]);
        }else{
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] deleteAuthorizedDirectoryFromSomeone:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetINodeDetailRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetRecentlyUsedFileRequest"];
    QCloudSMHGetINodeDetailRequest * request = [QCloudSMHGetINodeDetailRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.iNode = @"v1_XACMAKUAkwD0CrwZDMqLTSg";
    [request setFinishBlock:^(QCloudSMHINodeDetailInfo * _Nullable result, NSError * _Nullable error) {
            [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getINodeDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetRecentlyUsedFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetRecentlyUsedFileRequest"];
    QCloudSMHGetRecentlyUsedFileRequest * request = [QCloudSMHGetRecentlyUsedFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.type = @[@"all"];
    [request setFinishBlock:^(QCloudSMHRecentlyUsedFileInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result.contents.firstObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecentlyUsedFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetFileCountRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetFileCountRequest"];
    QCloudSMHGetFileCountRequest * request = [QCloudSMHGetFileCountRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    [request setFinishBlock:^(QCloudSMHFileCountInfo *  _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getCloudFileCount:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHRenameDirectoryRequest{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"createDirectory"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = @"rename_dir";
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    req.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    [req setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *_Nullable error) {
        [expectation1 fulfill];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:req];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHRenameDirectoryRequest"];
    QCloudSMHRenameDirectoryRequest * request = [QCloudSMHRenameDirectoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.dirPath = @"rename_dir_target";
    request.from = @"rename_dir";
    [request setFinishBlock:^(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService]renameDirecotry:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"QCloudSMHDeleteDirectoryRequest"];
    QCloudSMHDeleteDirectoryRequest * request1 = [QCloudSMHDeleteDirectoryRequest new];
    request1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request1.dirPath = @"rename_dir_target";
    [request1 setFinishBlock:^(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation2 fulfill];
    }];
    [[QCloudSMHService defaultSMHService]deleteDirectory :request1];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

-(void)testQCloudSMHPutTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHPutTagRequest"];
    QCloudSMHPutTagRequest * request = [QCloudSMHPutTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.tagName = @"tagname";
    request.tagType = @"1";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        QCloudSMHGetTagListRequest * request2 = [QCloudSMHGetTagListRequest new];
        request2.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        request2.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        [request2 setFinishBlock:^(NSArray<QCloudTagModel *> * _Nullable result, NSError * _Nullable error) {
            QCloudSMHDeleteTagRequest * request1 = QCloudSMHDeleteTagRequest.new;
            request1.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
            request1.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
            request1.tagId = @"1";
            [request1 setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] deleteTag:request1];
            XCTAssertNil(error);
        }];
        [[QCloudSMHService defaultSMHService] getTagList:request2];
        
    }];
    [[QCloudSMHService defaultSMHService] putTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteDirectoryRequest"];
    QCloudSMHDeleteDirectoryRequest * request = [QCloudSMHDeleteDirectoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.dirPath = testDirName;
    [request setFinishBlock:^(QCloudSMHDeleteResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService]deleteDirectory :request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDetailDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDetailDirectoryRequest"];
    QCloudSMHDetailDirectoryRequest * request = [QCloudSMHDetailDirectoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = @"";
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] detailDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHPostAuthorizeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHPostAuthorizeRequest"];
    QCloudSMHPostAuthorizeRequest * request = [QCloudSMHPostAuthorizeRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.dirPath = @"/";
    QCloudSMHSelectRoleInfo * role = QCloudSMHSelectRoleInfo.new;
    role.type = QCloudSMHRoleGrop;
    role.targetId = @"1";
    role.roleId = 1;
    role.name = @"观察者";
    request.selectRoles = @[role];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"]isEqualToString:@"RoleNotFound"]);
        }else{
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] authorizedDirectoryToSomeone:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetFileListByTagsRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetFileListByTagsRequest"];
    QCloudSMHGetFileListByTagsRequest * request = [QCloudSMHGetFileListByTagsRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    QCloudFileQueryTagModel * tag = [QCloudFileQueryTagModel new];
    tag.tagId = @"1";

    request.tagList = @[tag];
    [request setFinishBlock:^(QCloudQueryTagFilesInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getFileListByTags:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHCopyFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCopyFileRequest"];
    QCloudSMHCopyFileRequest * request = [QCloudSMHCopyFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testSimpleFile stringByAppendingString:@"_copy"]]];
    request.from = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    [request setFinishBlock:^(QCloudSMHRenameResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService]copyFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHPutHisotryVersionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHPutHisotryVersionRequest"];
    QCloudSMHPutHisotryVersionRequest * request = [QCloudSMHPutHisotryVersionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.enableFileHistory = YES;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService]putHisotryVersion :request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteAllRecycleObjectReqeust{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteAllRecycleObjectReqeust"];
    QCloudSMHDeleteAllRecycleObjectReqeust * request = [QCloudSMHDeleteAllRecycleObjectReqeust new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] deleteAllRecyleObject:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudGetTaskStatusRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetTaskStatusRequest"];
    QCloudGetTaskStatusRequest * request = [QCloudGetTaskStatusRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.taskIdList = @[@1];
    [request setFinishBlock:^(NSArray<QCloudSMHBatchResult *> * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getTaskStatus:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHPutFileTagRequest{
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testQCloudSMHPutFileTagRequest"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    uploadReq.body =[NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"put_file_tag";
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation1 fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHPutFileTagRequest_1"];
    QCloudSMHPutFileTagRequest * request = [QCloudSMHPutFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = @"put_file_tag";
    QCloudSMHTagModel * tag = [QCloudSMHTagModel new];
    tag.tagId = @"id";
    tag.tagValue = @"value";
    request.kvTags = @[tag];
    
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] putFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"testQCloudSMHPutFileTagRequest_2"];
    request = [QCloudSMHPutFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = @"put_file_tag";
    
    request.tags = @[@"test"];
    
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation2 fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] putFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHPutObjectLinkRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHPutObjectLinkRequest"];
    QCloudSMHPutObjectLinkRequest * request = [QCloudSMHPutObjectLinkRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = testDirName;
    request.linkTo = @"test.com";
    [request setFinishBlock:^(QCloudSMHPutObjectLinkInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] putObjectLink:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHHeadDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHHeadDirectoryRequest"];
    QCloudSMHHeadDirectoryRequest * request = [QCloudSMHHeadDirectoryRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.dirPath = @"/";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] headDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetHistoryInfoRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetHistoryInfoRequest"];
    QCloudSMHGetHistoryInfoRequest * request = [QCloudSMHGetHistoryInfoRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;

    [request setFinishBlock:^(QCloudSMHHistoryStateInfo * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getHistoryDetailInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHInitiateSearchRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHInitiateSearchRequest"];
    QCloudSMHInitiateSearchRequest * request = [QCloudSMHInitiateSearchRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.keyword = @"test";
    request.scope = @"/";
    request.searchTypes = @[@(QCloudSMHSearchTypeAll)];
    request.searchMode = QCloudSMHSearchModeNormal;
    request.minFileSize = 0;
    request.maxFileSize = 1024 * 1024 * 1024 * 1024;
    [request setFinishBlock:^(QCloudSMHSearchListInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        QCloudSMHResumeSearchRequest * rRequest = [QCloudSMHResumeSearchRequest new];
        rRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
        rRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
        rRequest.searchId = result.searchId;
        rRequest.nextMarker = result.nextMarker;
        [rRequest setFinishBlock:^(QCloudSMHSearchListInfo * _Nullable result, NSError * _Nullable error) {
            if (!result.searchId) {
                [expectation fulfill];
            }else{
                QCloudSMHAbortSearchRequest * abortRequest = [QCloudSMHAbortSearchRequest new];
                abortRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
                abortRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
                abortRequest.searchId = result.searchId;
                [abortRequest setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] abortSearch:abortRequest];
            }
           
        }];
        [[QCloudSMHService defaultSMHService] resumeSearch:rRequest];
    }];
    
    [[QCloudSMHService defaultSMHService] initSearch:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHDeleteHistoryVersionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteHistoryVersionRequest"];
    QCloudSMHDeleteHistoryVersionRequest * request = [QCloudSMHDeleteHistoryVersionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.historyIds = @[@"1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"DirectoryHistoryNotFound"]);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] deleteHisotryVersion:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHAPIListHistoryVersionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHAPIListHistoryVersionRequest"];
    QCloudSMHAPIListHistoryVersionRequest * request = [QCloudSMHAPIListHistoryVersionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    
    [request setFinishBlock:^(QCloudSMHListHistoryVersionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listHistoryVersion:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHAPIListHistoryVersionRequest2{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHAPIListHistoryVersionRequest"];
    QCloudSMHAPIListHistoryVersionRequest * request = [QCloudSMHAPIListHistoryVersionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    request.page = 1;
    request.pageSize = 100;
    request.sortType = QCloudSMHSortTypeName;
    [request setFinishBlock:^(QCloudSMHListHistoryVersionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listHistoryVersion:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCOSSMHDownloadObjectRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCOSSMHDownloadObjectRequest"];
    QCloudCOSSMHDownloadObjectRequest * request = [QCloudCOSSMHDownloadObjectRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testSimpleFile]];
    request.downloadingURL = [NSURL URLWithString:[QCloudDocumentsPath() stringByAppendingString:[NSString stringWithFormat:@"%@_test",NSDate.now]]];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] smhDownload:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCOSSMHDownloadObjectRequest2{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCOSSMHDownloadObjectRequest"];
    QCloudCOSSMHDownloadObjectRequest * request = [QCloudCOSSMHDownloadObjectRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    request.downloadingURL = [NSURL URLWithString:[QCloudDocumentsPath() stringByAppendingString:@"/test"]];
    
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        if (totalBytesDownload > 1024 * 1024) {
            [request cancel];
            [expectation fulfill];
        }
    }];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
    
    }];
    
    [[QCloudSMHService defaultSMHService] smhDownload:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteFileTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteFileTagRequest"];
    QCloudSMHDeleteFileTagRequest * request = [QCloudSMHDeleteFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.fileTagId = @"1";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetFileTagRequest{
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testQCloudSMHGetFileTagRequest"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserIdV1;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    uploadReq.body =[NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:2 * 1024 *1024]];
    uploadReq.uploadPath = @"get_file_tag";
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation1 fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetFileTagRequest_1"];
    QCloudSMHGetFileTagRequest * request = [QCloudSMHGetFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = @"get_file_tag";
    [request setFinishBlock:^(NSArray<QCloudFileTagItemModel *> * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] getFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHSetLatestVersionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHSetLatestVersionRequest"];
    QCloudSMHSetLatestVersionRequest * request = [QCloudSMHSetLatestVersionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.historyId = 123;
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"DirectoryHistoryNotFound"]);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] setLatestVersion:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudDeleteLocalSyncRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudDeleteLocalSyncRequest"];
    QCloudDeleteLocalSyncRequest * request = [QCloudDeleteLocalSyncRequest new];
    request.syncId = @"1";
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteLocalSync:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetUploadStateRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetUploadStateRequest"];
    QCloudSMHGetUploadStateRequest * request = [QCloudSMHGetUploadStateRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.confirmKey = @"test";
    [request setFinishBlock:^(QCloudSMHUploadStateInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"UploadNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getUploadStateInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHSpaceAuthorizeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHSpaceAuthorizeRequest"];
    QCloudSMHSpaceAuthorizeRequest * request = [QCloudSMHSpaceAuthorizeRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.authorizeSpaceId =  QCloudSMHTestTools.singleTool.getSpaceIdV1;

    request.roleId = 1;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"RoleNotFound"]);
        }else{
            XCTAssertNil(error);
        }
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] spaceAuthorize:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetFileThumbnailRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetFileThumbnailRequest"];
    QCloudGetFileThumbnailRequest * request = [QCloudGetFileThumbnailRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testBigFile]];
    request.size = 100;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getThumbnail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHAbortSearchRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHAbortSearchRequest"];

    QCloudSMHAbortSearchRequest * abortRequest = [QCloudSMHAbortSearchRequest new];
    abortRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV1;
    abortRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV1;
    abortRequest.searchId = @"test";
    [abortRequest setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        if (error) {
            XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"SearchIdInvalid"]);
        }else{
            XCTAssertNil(error);
        }
        
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] abortSearch:abortRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
@end
