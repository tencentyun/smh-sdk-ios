//
//  QCloudSMHSpaceV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHCreateSpaceRequest.h"
#import "QCloudSMHListSpaceRequest.h"
#import "QCloudSMHGetSpaceExtensionRequest.h"
#import "QCloudSMHUpdateSpaceExtensionRequest.h"
#import "QCloudSMHDeleteSpaceRequest.h"
#import "QCloudSMHGetLibrarySpaceCountRequest.h"
#import "QCloudSMHGetLibraryUsageRequest.h"
#import "QCloudSMHCreateTokenRequest.h"

@interface QCloudSMHSpaceV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
/// 临时覆盖的 spaceId 和 accessToken（用于 deleteSpace 测试）
@property (nonatomic, strong) NSString *overrideSpaceId;
@property (nonatomic, strong) NSString *overrideAccessToken;
@end

@implementation QCloudSMHSpaceV2Tests

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
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    // 支持临时覆盖（用于 deleteSpace 测试）
    if (self.overrideAccessToken && self.overrideSpaceId) {
        spaceinfo.accessToken = self.overrideAccessToken;
        spaceinfo.spaceId = self.overrideSpaceId;
    } else {
        spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
        spaceinfo.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    }
    continueBlock(spaceinfo, nil);
}

#pragma mark - Space

- (void)testQCloudSMHListSpaceRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ListSpaceRequest"];
    QCloudSMHListSpaceRequest *request = [QCloudSMHListSpaceRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.limit = 10;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listSpace:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetSpaceExtensionRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetSpaceExtensionRequest"];
    QCloudSMHGetSpaceExtensionRequest *request = [QCloudSMHGetSpaceExtensionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getSpaceExtension:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHUpdateSpaceExtensionRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UpdateSpaceExtensionRequest"];
    QCloudSMHUpdateSpaceExtensionRequest *request = [QCloudSMHUpdateSpaceExtensionRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.isPublicRead = NO;
    request.allowPhoto = YES;
    request.allowVideo = YES;
    request.allowPhotoExtname = @[@"jpg", @"png", @"heic"];
    request.allowVideoExtname = @[@"mp4", @"mov"];
    request.recognizeSensitiveContent = NO;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] updateSpaceExtension:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetLibrarySpaceCountRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetLibrarySpaceCountRequest"];
    QCloudSMHGetLibrarySpaceCountRequest *request = [QCloudSMHGetLibrarySpaceCountRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getLibrarySpaceCount:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHGetLibraryUsageRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetLibraryUsageRequest"];
    QCloudSMHGetLibraryUsageRequest *request = [QCloudSMHGetLibraryUsageRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getLibraryUsage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSMHCreateSpaceRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CreateSpaceRequest"];
    QCloudSMHCreateSpaceRequest *request = [QCloudSMHCreateSpaceRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.isPublicRead = YES;
    request.isMultiAlbum = YES;
    request.allowPhoto = YES;
    request.allowVideo = YES;
    request.allowPhotoExtname = @[@"jpg", @"png"];
    request.allowVideoExtname = @[@"mp4", @"mov"];
    request.recognizeSensitiveContent = NO;
    request.spaceTag = @"personal";
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] createSpace:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

// deleteSpace: 先创建一个临时空间，为其创建 token，再删除它
- (void)testQCloudSMHDeleteSpaceRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DeleteSpaceRequest"];
    
    // 第一步：创建一个临时空间
    QCloudSMHCreateSpaceRequest *createRequest = [QCloudSMHCreateSpaceRequest new];
    createRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    createRequest.isPublicRead = NO;
    createRequest.isMultiAlbum = NO;
    createRequest.spaceTag = @"personal";
    [createRequest setFinishBlock:^(NSDictionary *_Nullable createResult, NSError *_Nullable createError) {
        XCTAssertNil(createError);
        XCTAssertNotNil(createResult);
        
        NSString *newSpaceId = [createResult valueForKey:@"spaceId"];
        if (!newSpaceId) {
            XCTFail(@"创建临时空间失败，无法获取 spaceId");
            [expectation fulfill];
            return;
        }
        
        // 第二步：为新空间创建 accessToken
        QCloudSMHCreateTokenRequest *tokenRequest = [QCloudSMHCreateTokenRequest new];
        tokenRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        tokenRequest.librarySecret = QCloudSMHTestTools.singleTool.getLibrarySecretV2;
        tokenRequest.spaceId = newSpaceId;
        tokenRequest.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
        tokenRequest.period = 1200;
        tokenRequest.grant = @"admin";
        [tokenRequest setFinishBlock:^(QCloudSMHTokenResult *_Nullable tokenResult, NSError *_Nullable tokenError) {
            XCTAssertNil(tokenError);
            XCTAssertNotNil(tokenResult);
            
            if (!tokenResult || !tokenResult.accessToken) {
                XCTFail(@"为新空间创建 token 失败");
                [expectation fulfill];
                return;
            }
            
            // 第三步：临时覆盖 token 和 spaceId，删除新空间
            self.overrideAccessToken = tokenResult.accessToken;
            self.overrideSpaceId = newSpaceId;
            
            QCloudSMHDeleteSpaceRequest *deleteRequest = [QCloudSMHDeleteSpaceRequest new];
            deleteRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            deleteRequest.spaceId = newSpaceId;
            deleteRequest.force = 1;
            [deleteRequest setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                // 恢复原 token
                self.overrideAccessToken = nil;
                self.overrideSpaceId = nil;
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] deleteSpace:deleteRequest];
        }];
        [[QCloudSMHService defaultSMHService] createToken:tokenRequest];
    }];
    [[QCloudSMHService defaultSMHService] createSpace:createRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
