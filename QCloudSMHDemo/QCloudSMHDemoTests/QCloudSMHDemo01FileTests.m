//
//  QCloudSMHDemo01FileTests.m
//  QCloudSMHDemo01FileTests
//
//  Created by garenwang on 2022/5/12.
//

#import <XCTest/XCTest.h>
#import "QCloudCOSSMH.h"
#import "QCloudSMHTestTools.h"
#import "NSData+SHA256.h"
#import "NSObject+Equal.h"
#import "QCloudSMHCheckHostRequest.h"
#import "QCloudSMHGetINodeDetailRequest.h"
#import "QCloudSMHGetRecentlyUsedFileRequest.h"
static NSString * testDirName = @"iosunittestDir";
static NSString * testFileName = @"testFile";

@interface QCloudSMHDemo01FileTests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHDemo01FileTests

- (void)setUp {
    
    [QCloudSMHBaseRequest setBaseRequestHost:@"https://apiv2.test.tencentsmh.cn/" targetType:QCloudECDTargetTest];
    [QCloudSMHBaseRequest setBaseRequestHost:@"https://apiv2.test.tencentsmh.cn/" targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    self.fenceQueue = [QCloudSMHAccessTokenFenceQueue new];
    self.fenceQueue.delegate = self;
    [QCloudSMHService defaultSMHService].accessTokenProvider = self;
    
}

- (void)fenceQueue:(QCloudSMHAccessTokenFenceQueue *)queue
           request:(QCloudSMHBizRequest *)request
requestCreatorWithContinue:(QCloudAccessTokenFenceQueueContinue)continueBlock {
    
    if (request.spaceId) {
        QCloudSMHGetSpaceAccessTokenRequest * getAccessToken = [QCloudSMHGetSpaceAccessTokenRequest new];
        getAccessToken.organizationId= QCloudSMHTestTools.singleTool.getOrgnizationId;
        getAccessToken.spaceId = request.spaceId;
        getAccessToken.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo * _Nonnull outputObject, NSError * _Nullable error) {
            continueBlock(outputObject, error);
        }];
        [[QCloudSMHUserService defaultSMHUserService] getSpaceAccessToken:getAccessToken];
    }else{
        
        QCloudSMHGetAccessTokenRequest *getAccessToken = [QCloudSMHGetAccessTokenRequest new];
        getAccessToken.priority = QCloudAbstractRequestPriorityHigh;
        getAccessToken.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        getAccessToken.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
            continueBlock(outputObject, error);
        }];
        [[QCloudSMHUserService defaultSMHUserService] getAccessToken:getAccessToken];
    }
  
}

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    
    QCloudSMHSpaceInfo * spaceinfo = [QCloudSMHSpaceInfo new];
    spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessToken;
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    spaceinfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    continueBlock(spaceinfo,nil);
//    [self.fenceQueue performRequest:request
//                         withAction:^(QCloudSMHSpaceInfo *_Nonnull accessToken, NSError *_Nonnull error) {
//        if (error) {
//            continueBlock(nil, error);
//        } else {
//            continueBlock(accessToken, nil);
//        }
//    }];
    
}

-(void)test01CreateDirectory{
    XCTestExpectation *expectation = [self expectationWithDescription:@"createDirectory"];
    QCloudSMHPutDirectoryRequest *req = [QCloudSMHPutDirectoryRequest new];
    req.dirPath = testDirName;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
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
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test02UploadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadFile"];
    QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
    uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    uploadReq.userId = QCloudSMHTestTools.singleTool.getUserId;
    uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
    uploadReq.body = [NSURL fileURLWithPath:[QCloudSMHTestTools tempFileWithSize:20*1024*1024]];
    uploadReq.uploadPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    uploadReq.uploadBodyIsCompleted = YES;
    
    
    [uploadReq setPreviewSendProcessBlock:^(int64_t count, int64_t total, BOOL isStart) {
        
    }];
    
    [uploadReq setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
    }];
    
    [uploadReq setFinishBlock:^(QCloudSMHContentInfo *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result.name isEqualToString:testFileName]);
        XCTAssertTrue([result.paths.firstObject isEqualToString:testDirName]);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test03CopyFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCopyFile"];
    QCloudSMHCopyObjectRequest *req = [QCloudSMHCopyObjectRequest new];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    QCloudSMHBatchCopyInfo *info = [QCloudSMHBatchCopyInfo new];
    info.from = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    info.to = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_copy"]]];
    info.conflictStrategy = QCloudSMHConflictStrategyEnumAsk;
    req.batchInfos = @[info];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue(result.status == QCloudSMHBatchTaskStatusSucceed);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] copyObject:req];
    
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test04MoveFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHMoveObjectRequest *req = [QCloudSMHMoveObjectRequest new];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    QCloudSMHBatchMoveInfo *info = [QCloudSMHBatchMoveInfo new];
    info.from = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_copy"]]];
    info.to = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    info.moveAuthority = YES;
    info.conflictStrategy = QCloudSMHConflictStrategyEnumRename;

    
    
    req.batchInfos =@[info];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] moveObject:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test05RenameFile{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHRenameFileRequest *req = [QCloudSMHRenameFileRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;

    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    req.from = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_rename"]]];
    req.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    [req setFinishBlock:^(QCloudSMHRenameResult *result, NSError *_Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result.paths.lastObject isEqualToString:[testFileName stringByAppendingString:@"_rename"]]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] renameFile:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test06GetFileDetailURL{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetFileDetailURL"];
    QCloudSMHGetDownloadInfoRequest * requeset = [[QCloudSMHGetDownloadInfoRequest alloc]init];
    requeset.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    requeset.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    requeset.userId = QCloudSMHTestTools.singleTool.getUserId;
    requeset.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    [requeset setFinishBlock:^(QCloudSMHDownloadInfoModel * outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(outputObject.cosUrl);
        XCTAssertTrue(outputObject.size.integerValue == 20 * 1024 * 1024);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getDonwloadInfo:requeset];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test07DeleteFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    NSMutableArray *batchInfos = [NSMutableArray array];
    
    QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
    
    info.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_rename"]]];
    [batchInfos addObject:info];

    req.batchInfos = [batchInfos copy];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteObject:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
}

-(void)test08DownloadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDownloadFile"];
    QCloudSMHDownloadFileRequest *req = [QCloudSMHDownloadFileRequest new];

    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
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

-(void)test09RestoreRecycleObjectList{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRecycleObjectList"];
    QCloudSMHGetRecycleObjectListReqeust *req = [QCloudSMHGetRecycleObjectListReqeust new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    req.limit = 200;
    req.sortType = QCloudSMHSortTypeCTimeReverse;
    [req setFinishBlock:^(QCloudSMHRecycleObjectListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        Boolean exit = NO;
        __block NSString * recycledItemId;
        for (QCloudSMHRecycleObjectItemInfo * item in result.contents) {
            if ([item.name isEqualToString:@"testFile_rename"]) {
                exit = true;
                recycledItemId = item.recycledItemId;
                break;
            }
        }
        XCTAssertTrue(exit);
        XCTAssertNotNil(recycledItemId);

        QCloudSMHRestoreObjectRequest *req = [QCloudSMHRestoreObjectRequest new];
        req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
        req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
        
        req.userId = QCloudSMHTestTools.singleTool.getUserId;
        
        req.batchInfos = @[@(recycledItemId.integerValue)];
        [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] restoreObject:req];
    }];
    [[QCloudSMHService defaultSMHService] getRecycleList:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test10MyAuthorizedDirectory{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testMyAuthorizedDirectory"];
    QCloudSMHGetMyAuthorizedDirectoryRequest *req = [QCloudSMHGetMyAuthorizedDirectoryRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    
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
    request.libraryId = @"smh0hn0ke4y0k471";QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;

    [request setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue([outputObject isKindOfClass:[NSArray class]]);
        NSArray * roles = outputObject;
        XCTAssertTrue(roles.count == 7);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRoleList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)test12GetlistContents {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetlistContents"];
    __block QCloudSMHListContentsRequest *req = [QCloudSMHListContentsRequest new];
    
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    req.dirPath = @"/";
    req.limit = 10;
    req.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [req setFinishBlock:^(QCloudSMHContentListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if (result.contents.count > 0) {
            
            NSMutableArray *favoriteInfos = [NSMutableArray array];
            for (QCloudSMHContentInfo *contentInfo in result.contents) {
                QCloudSMHCheckFavoriteInfo *checkInfo = [QCloudSMHCheckFavoriteInfo new];
                checkInfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
                checkInfo.path = @"/";
                [favoriteInfos addObject:checkInfo];
            }
            
            QCloudSMHCheckFavoriteRequest *req = [QCloudSMHCheckFavoriteRequest new];
            req.organizationId =QCloudSMHTestTools.singleTool.getOrgnizationId;
            req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
            req.checkFavoriteInfos = [favoriteInfos copy];
            [req setFinishBlock:^(NSArray<QCloudSMHCheckFavoriteResultInfo *> * _Nonnull result1, NSError * _Nonnull error1) {
                XCTAssertNil(error1);
                XCTAssertNotNil(result1);
                XCTAssertTrue(result.contents.count == result1.count);
                [expectation fulfill];
            }];
            [[QCloudSMHUserService defaultSMHUserService] checkFavoriteState:req];
        }else{
            [expectation fulfill];
        }
    }];
    [[QCloudSMHService defaultSMHService] listContents:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test13ListHisotryVersion{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListHisotryVersion"];
    QCloudSMHListHistoryVersionRequest *req = [QCloudSMHListHistoryVersionRequest new];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    req.limit = 50;
    [req setFinishBlock:^(QCloudSMHListHistoryVersionResult *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] listHisotryVersion:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test14GetPreginURLFileObject{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetPreginURLFileObject"];
    QCloudSMHGetPresignedURLRequest *req = [QCloudSMHGetPresignedURLRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.priority = QCloudAbstractRequestPriorityHigh;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;

    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    req.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    [req setFinishBlock:^(NSString *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result isKindOfClass:[NSString class]] && result.length > 0);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getPresignedURL:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test15GetFileInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetFileInfo"];
    QCloudSMHGetFileInfoRequest *req = [QCloudSMHGetFileInfoRequest new];
    req.dirPath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHContentInfo *_Nonnull result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result.paths.lastObject isEqualToString:[testFileName stringByAppendingString:@"_move"]]);
        XCTAssertTrue([result.paths.firstObject isEqualToString:testDirName]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getFileInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)test15FavorateObject {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetFileInfo"];
    QCloudSMHFavoriteFileRequest *req = [QCloudSMHFavoriteFileRequest new];
    req.priority = QCloudAbstractRequestPriorityHigh;
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_move"]]];
    req.userToken =  QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHFavoriteInfo *favoriteInfo, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(favoriteInfo);
        XCTAssertTrue(favoriteInfo.favoriteId > 0);
        
        QCloudSMHDeleteFavoriteRequest *req1 = [QCloudSMHDeleteFavoriteRequest new];
        req1.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        req1.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        req1.favoriteIds = @[@(favoriteInfo.favoriteId)];
        [req1 setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(outputObject);
            [expectation fulfill];
        }];
        [[QCloudSMHUserService defaultSMHUserService] deleteFavoriteFiles:req1];
        
    }];
    [[QCloudSMHUserService defaultSMHUserService] favoriteFile:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)test15ListFavorateObject {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetFileInfo"];
    QCloudGetFavoriteListRequest *req = [QCloudGetFavoriteListRequest new];
    req.userToken =  QCloudSMHTestTools.singleTool.getUserToken;
    req.sortType = QCloudSMHSortTypeFavoriteTime;
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [req setFinishBlock:^(QCloudSMHFavoriteResult *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getFavoriteList:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test15QuickUpload{
    
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
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_quick"]]];
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
        request1.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
        request1.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
        request1.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
        request1.userId = QCloudSMHTestTools.singleTool.getUserId;
        request1.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:[testFileName stringByAppendingString:@"_quick"]]];
        
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

-(void)test16DeleteDir{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRenameFile"];
    QCloudSMHDeleteObjectRequest *req = [QCloudSMHDeleteObjectRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    NSMutableArray *batchInfos = [NSMutableArray array];
    
    QCloudSMHBatchDeleteInfo *info = [QCloudSMHBatchDeleteInfo new];
    
    info.path = testDirName;
    [batchInfos addObject:info];

    req.batchInfos = [batchInfos copy];
    [req setFinishBlock:^(QCloudSMHBatchResult *result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService]deleteObject:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)test17DeleteRecycleObject{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRecycleObjectList"];
    QCloudSMHGetRecycleObjectListReqeust *req = [QCloudSMHGetRecycleObjectListReqeust new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    
    req.limit = 200;
    req.sortType = QCloudSMHSortTypeCTimeReverse;
    [req setFinishBlock:^(QCloudSMHRecycleObjectListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        Boolean exit = NO;
        __block NSString * recycledItemId;
        for (QCloudSMHRecycleObjectItemInfo * item in result.contents) {
            if ([item.name isEqualToString:testDirName]) {
                exit = true;
                recycledItemId = item.recycledItemId;
                break;
            }
        }
        XCTAssertTrue(exit);
        XCTAssertNotNil(recycledItemId);
        
        QCloudSMHBatchDeleteRecycleObjectReqeust *req1 = [QCloudSMHBatchDeleteRecycleObjectReqeust new];
        req1.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
        req1.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    
        req1.userId = QCloudSMHTestTools.singleTool.getUserId;
        req1.recycledItemIds = @[@([recycledItemId integerValue])];
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

-(void)testCrossCopy{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCrossCopy"];
    QCloudSMHCrossSpaceAsyncCopyDirectoryRequest *req = [QCloudSMHCrossSpaceAsyncCopyDirectoryRequest new];
    req.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;

    req.userId = QCloudSMHTestTools.singleTool.getUserId;
    req.dirPath = @"-1";
    req.from = @"-2";
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
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;

    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    QCloudSMHExitFileAuthorize * info = [QCloudSMHExitFileAuthorize new];
    info.name = @"";
    info.userId = @"1";
    info.roleId = @"1";
    request.authorizeTo = @[info];
    request.dirPath = @"ffff1";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"RoleNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] exitFileAuthorize:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testHeadFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHeadFile"];
    QCloudSMHHeadFileRequest * request = [QCloudSMHHeadFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    request.filePath = @"test.PNG";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 400);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] headFile:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudSMHDeleteFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testHeadFile"];
    QCloudSMHDeleteFileRequest * request = [QCloudSMHDeleteFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    request.filePath = @"test.jpg";
    request.permanent = 0;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"FileNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteFile:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudSMHGetAlbumRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExitFileAuthorize"];
    QCloudSMHGetAlbumRequest * request = [QCloudSMHGetAlbumRequest new];
    request.size = @"100";
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue(error.code == 400);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getAlbum:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudSMHEditFileOnlineRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHEditFileOnlineRequest"];
    QCloudSMHEditFileOnlineRequest * request = [QCloudSMHEditFileOnlineRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    request.filePath = @"test (2).doc";
    [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getEditFileOnlineUrl:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHCreateFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCreateFileRequest"];
    QCloudSMHCreateFileRequest * request = [QCloudSMHCreateFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.userId = QCloudSMHTestTools.singleTool.getUserId;
    request.fromTemplate = QCloudSMHFileTemplateWord;
    request.filePath = @"test.doc";
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
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
    QCloudSMHDeleteAuthorizeRequest * request = [QCloudSMHDeleteAuthorizeRequest new];
    
    request.dirPath = @"/dirPath";
    
    QCloudSMHSelectRoleInfo * role = [[QCloudSMHSelectRoleInfo alloc]initWithType:QCloudSMHRoleMember targetId:@"userId" roleId:@"1" name:@"name"];
    
    request.selectRoles = @[role];
    
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
            
    }];
    
    [[QCloudSMHService defaultSMHService] deleteAuthorizedDirectoryFromSomeone:request];
}

- (void)testQCloudSMHGetINodeDetailRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetRecentlyUsedFileRequest"];
    QCloudSMHGetINodeDetailRequest * request = [QCloudSMHGetINodeDetailRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.iNode = @"v1_XACMAKUAkwD0CrwZDMqLTSg";
    [request setFinishBlock:^(QCloudSMHINodeDetailInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getINodeDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetRecentlyUsedFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetRecentlyUsedFileRequest"];
    QCloudSMHGetRecentlyUsedFileRequest * request = [QCloudSMHGetRecentlyUsedFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.type = @[@"all"];
    [request setFinishBlock:^(QCloudSMHRecentlyUsedFileInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result.contents.firstObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecentlyUsedFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudUpdateDirectoryTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateDirectoryTagRequest"];
    QCloudUpdateDirectoryTagRequest * request = [QCloudUpdateDirectoryTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.dirPath = testDirName;
    request.labels = @[@"label1",@"label1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] updateDirectoryTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetSpaceHomeFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetSpaceHomeFileRequest"];
    QCloudSMHGetSpaceHomeFileRequest * request = [QCloudSMHGetSpaceHomeFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.directoryFilter = QCloudSMHDirectoryOnlyDir;
    [request setFinishBlock:^(QCloudSMHSpaceHomeFileInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getSpaceHomeFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudUpdateFileTagRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateFileTagRequest"];
    QCloudUpdateFileTagRequest * request = [QCloudUpdateFileTagRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.filePath = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    request.labels = @[@"label1",@"label1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] updateFileTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testQCloudSMHGetRecyclePresignedURLRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetRecyclePresignedURLRequest"];
    QCloudSMHGetRecyclePresignedURLRequest * request = [QCloudSMHGetRecyclePresignedURLRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.recycledItemId = @"723074";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecyclePresignedURL:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetRecycleFileDetailReqeust{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHGetRecycleFileDetailReqeust"];
    QCloudSMHGetRecycleFileDetailReqeust * request = [QCloudSMHGetRecycleFileDetailReqeust new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.recycledItemId = @"723074";
    [request setFinishBlock:^(QCloudSMHRecycleObjectItemInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getRecycleFileDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSetSpaceTrafficLimitRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSetSpaceTrafficLimitRequest"];
    QCloudSetSpaceTrafficLimitRequest * request = [QCloudSetSpaceTrafficLimitRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.downloadTrafficLimit = 1 * 1024 * 1024;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] setSpaceTrafficLimit:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHFavoriteSpaceFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHFavoriteSpaceFileRequest"];
    QCloudSMHFavoriteSpaceFileRequest * request = [QCloudSMHFavoriteSpaceFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
//    request.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    request.inode = @"c7106bbe6d55415e00062f32c5e987b3";
    [request setFinishBlock:^(QCloudSMHFavoriteSpaceFileResult * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] favoriteSpaceFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteFavoriteSpaceFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHDeleteFavoriteSpaceFileRequest"];
    QCloudSMHDeleteFavoriteSpaceFileRequest * request = [QCloudSMHDeleteFavoriteSpaceFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
//    request.path = [testDirName stringByAppendingString:[@"/" stringByAppendingString:testFileName]];
    request.inode = @"c7106bbe6d55415e00062f32c5e987b3";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        NSLog(@"%@",outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] deleteFavoriteSpaceFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHListFavoriteSpaceFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHListFavoriteSpaceFileRequest"];
    QCloudSMHListFavoriteSpaceFileRequest * request = [QCloudSMHListFavoriteSpaceFileRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    [request setFinishBlock:^(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listFavoriteSpaceFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudGetSpaceUsageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudGetSpaceUsageRequest"];
    QCloudGetSpaceUsageRequest * request = [QCloudGetSpaceUsageRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryId;
    request.spaceIds = QCloudSMHTestTools.singleTool.getSpaceId;
    [request setFinishBlock:^(NSArray<QCloudSMHSpaceUsageInfo *> * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getSpaceUsage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


@end
