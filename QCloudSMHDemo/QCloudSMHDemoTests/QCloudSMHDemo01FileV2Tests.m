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

static NSString * testDirName = @"iosunittestDir";
static NSString * testFileName = @"testFile";

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
@end
