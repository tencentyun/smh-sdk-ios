//
//  QCloudSMHQuotaV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHCreateQuotaRequest.h"
#import "QCloudSMHGetQuotaRequest.h"
#import "QCloudSMHUpdateQuotaRequest.h"
#import "QCloudSMHGetQuotaInfoRequest.h"
#import "QCloudSMHUpdateQuotaByIdRequest.h"

@interface QCloudSMHQuotaV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHQuotaV2Tests

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

- (void)testQCloudSMHGetQuotaRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetQuotaRequest"];
    QCloudSMHGetQuotaRequest *request = [QCloudSMHGetQuotaRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] getQuota:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

// 创建配额（如果已存在则跳过）→ 获取配额 → 修改配额
- (void)testQCloudSMHCreateAndManageQuota {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CreateAndManageQuota"];
    
    // 第一步：尝试创建配额（可能已存在，返回 409 DuplicateQuota）
    QCloudSMHCreateQuotaRequest *createRequest = [QCloudSMHCreateQuotaRequest new];
    createRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    createRequest.spaces = @[QCloudSMHTestTools.singleTool.getSpaceIdV2];
    createRequest.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
    createRequest.removeWhenExceed = NO;
    createRequest.removeAfterDays = 30;
    [createRequest setFinishBlock:^(QCloudSMHQuotaInfo *_Nullable createResult, NSError *_Nullable createError) {
        // 创建成功或已存在（409）都继续
        if (createError) {
            NSInteger code = [createError.userInfo[@"status"] integerValue];
            XCTAssertEqual(code, 409, @"创建配额失败且非 DuplicateQuota: %@", createError);
        }
        
        // 第二步：获取配额
        QCloudSMHGetQuotaRequest *getRequest = [QCloudSMHGetQuotaRequest new];
        getRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        getRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        [getRequest setFinishBlock:^(id _Nullable getResult, NSError *_Nullable getError) {
            XCTAssertNil(getError);
            XCTAssertNotNil(getResult);
            
            // 第三步：修改配额
            QCloudSMHUpdateQuotaRequest *updateRequest = [QCloudSMHUpdateQuotaRequest new];
            updateRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            updateRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            updateRequest.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
            [updateRequest setFinishBlock:^(id _Nullable updateResult, NSError *_Nullable updateError) {
                XCTAssertNil(updateError);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] updateQuota:updateRequest];
        }];
        [[QCloudSMHService defaultSMHService] getQuota:getRequest];
    }];
    [[QCloudSMHService defaultSMHService] createQuota:createRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - 获取配额详情（按 quotaId）

- (void)testQCloudSMHGetQuotaInfoRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetQuotaInfoRequest"];
    // 先创建配额获取 quotaId
    QCloudSMHCreateQuotaRequest *createRequest = [QCloudSMHCreateQuotaRequest new];
    createRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    createRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    createRequest.spaces = @[QCloudSMHTestTools.singleTool.getSpaceIdV2];
    createRequest.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
    createRequest.removeWhenExceed = NO;
    createRequest.removeAfterDays = 30;
    [createRequest setFinishBlock:^(QCloudSMHQuotaInfo *_Nullable createResult, NSError *_Nullable createError) {
        // 获取 quotaId（创建成功或已存在 409 都需要获取）
        NSString *quotaId = createResult.quotaId > 0 ? [NSString stringWithFormat:@"%ld", (long)createResult.quotaId] : nil;
        if (!quotaId) {
            // 如果已存在，通过 getQuota 获取
            QCloudSMHGetQuotaRequest *getReq = [QCloudSMHGetQuotaRequest new];
            getReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            getReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            [getReq setFinishBlock:^(QCloudSMHQuotaInfo *_Nullable getResult, NSError *_Nullable getError) {
                XCTAssertNil(getError);
                NSString *fetchedQuotaId = getResult.quotaId > 0 ? [NSString stringWithFormat:@"%ld", (long)getResult.quotaId] : nil;
                if (!fetchedQuotaId) {
                    XCTFail(@"无法获取 quotaId");
                    [expectation fulfill];
                    return;
                }
                QCloudSMHGetQuotaInfoRequest *infoReq = [QCloudSMHGetQuotaInfoRequest new];
                infoReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
                infoReq.quotaId = fetchedQuotaId;
                [infoReq setFinishBlock:^(QCloudSMHQuotaDetailInfo *_Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    XCTAssertNotNil(result);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] getQuotaInfo:infoReq];
            }];
            [[QCloudSMHService defaultSMHService] getQuota:getReq];
            return;
        }
        QCloudSMHGetQuotaInfoRequest *infoReq = [QCloudSMHGetQuotaInfoRequest new];
        infoReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        infoReq.quotaId = quotaId;
        [infoReq setFinishBlock:^(QCloudSMHQuotaDetailInfo *_Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] getQuotaInfo:infoReq];
    }];
    [[QCloudSMHService defaultSMHService] createQuota:createRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - 按 ID 修改配额

- (void)testQCloudSMHUpdateQuotaByIdRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UpdateQuotaByIdRequest"];
    // 先创建配额获取 quotaId
    QCloudSMHCreateQuotaRequest *createRequest = [QCloudSMHCreateQuotaRequest new];
    createRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    createRequest.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    createRequest.spaces = @[QCloudSMHTestTools.singleTool.getSpaceIdV2];
    createRequest.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
    createRequest.removeWhenExceed = NO;
    createRequest.removeAfterDays = 30;
    [createRequest setFinishBlock:^(QCloudSMHQuotaInfo *_Nullable createResult, NSError *_Nullable createError) {
        NSString *quotaId = createResult.quotaId > 0 ? [NSString stringWithFormat:@"%ld", (long)createResult.quotaId] : nil;
        if (!quotaId) {
            // 如果已存在，通过 getQuota 获取
            QCloudSMHGetQuotaRequest *getReq = [QCloudSMHGetQuotaRequest new];
            getReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            getReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            [getReq setFinishBlock:^(QCloudSMHQuotaInfo *_Nullable getResult, NSError *_Nullable getError) {
                XCTAssertNil(getError);
                NSString *fetchedQuotaId = getResult.quotaId > 0 ? [NSString stringWithFormat:@"%ld", (long)getResult.quotaId] : nil;
                if (!fetchedQuotaId) {
                    XCTFail(@"无法获取 quotaId");
                    [expectation fulfill];
                    return;
                }
                QCloudSMHUpdateQuotaByIdRequest *updateReq = [QCloudSMHUpdateQuotaByIdRequest new];
                updateReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
                updateReq.quotaId = fetchedQuotaId;
                updateReq.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
                updateReq.spaces = @[QCloudSMHTestTools.singleTool.getSpaceIdV2];
                [updateReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] updateQuotaById:updateReq];
            }];
            [[QCloudSMHService defaultSMHService] getQuota:getReq];
            return;
        }
        QCloudSMHUpdateQuotaByIdRequest *updateReq = [QCloudSMHUpdateQuotaByIdRequest new];
        updateReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        updateReq.quotaId = quotaId;
        updateReq.capacity = [NSString stringWithFormat:@"%lld",(long long)(100LL*1024*1024*1024)];
        updateReq.spaces = @[QCloudSMHTestTools.singleTool.getSpaceIdV2];
        [updateReq setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] updateQuotaById:updateReq];
    }];
    [[QCloudSMHService defaultSMHService] createQuota:createRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
