//
//  QCloudSMHTokenV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/23.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHCreateTokenRequest.h"
#import "QCloudSMHRenewTokenRequest.h"
#import "QCloudSMHDeleteTokenRequest.h"
#import "QCloudSMHDeleteUserTokensRequest.h"

@interface QCloudSMHTokenV2Tests : XCTestCase
@end

@implementation QCloudSMHTokenV2Tests

- (void)setUp {
    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/", QCloudSMHTestTools.singleTool.getBaseUrlStrV2] targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
}

#pragma mark - 辅助方法

/// 创建一个临时 token 并返回
- (void)createTempTokenWithCompletion:(void (^)(QCloudSMHTokenResult *result, NSError *error))completion {
    QCloudSMHCreateTokenRequest *request = [QCloudSMHCreateTokenRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.librarySecret = QCloudSMHTestTools.singleTool.getLibrarySecretV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.userId = @"temp_user_for_delete_test";
    request.period = 1200;
    request.grant = @"admin";
    [request setFinishBlock:^(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error) {
        completion(result, error);
    }];
    [[QCloudSMHService defaultSMHService] createToken:request];
}

/// 刷新主 token，保证后续测试用例正常
- (void)refreshMainTokenWithCompletion:(void (^)(QCloudSMHTokenResult *result, NSError *error))completion {
    QCloudSMHCreateTokenRequest *request = [QCloudSMHCreateTokenRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.librarySecret = QCloudSMHTestTools.singleTool.getLibrarySecretV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    request.period = 7200;
    request.grant = @"admin";
    [request setFinishBlock:^(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error) {
        completion(result, error);
    }];
    [[QCloudSMHService defaultSMHService] createToken:request];
}

#pragma mark - CreateToken

- (void)testQCloudSMHCreateTokenRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CreateTokenRequest"];
    QCloudSMHCreateTokenRequest *request = [QCloudSMHCreateTokenRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.librarySecret = QCloudSMHTestTools.singleTool.getLibrarySecretV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    request.period = 7200;
    request.grant = @"admin";
    [request setFinishBlock:^(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if (result) {
            XCTAssertNotNil(result.accessToken);
            XCTAssertTrue(result.accessToken.length > 0, @"accessToken 不应为空");
            XCTAssertTrue(result.expiresIn > 0, @"expiresIn 应大于 0");
        }
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] createToken:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - RenewToken

- (void)testQCloudSMHRenewTokenRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"RenewTokenRequest"];
    QCloudSMHRenewTokenRequest *request = [QCloudSMHRenewTokenRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    [request setFinishBlock:^(QCloudSMHTokenResult *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if (result) {
            XCTAssertNotNil(result.accessToken);
            XCTAssertTrue(result.accessToken.length > 0, @"accessToken 不应为空");
            XCTAssertTrue(result.expiresIn > 0, @"expiresIn 应大于 0");
        }
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] renewToken:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - DeleteToken

// 先创建临时 token → 删除临时 token → 刷新主 token
- (void)testQCloudSMHDeleteTokenRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DeleteTokenRequest"];
    
    // 第一步：创建一个临时 token
    [self createTempTokenWithCompletion:^(QCloudSMHTokenResult *createResult, NSError *createError) {
        XCTAssertNil(createError);
        XCTAssertNotNil(createResult);
        
        if (!createResult || !createResult.accessToken) {
            XCTFail(@"创建临时 token 失败，无法继续测试删除");
            [expectation fulfill];
            return;
        }
        
        // 第二步：删除刚创建的临时 token
        QCloudSMHDeleteTokenRequest *deleteRequest = [QCloudSMHDeleteTokenRequest new];
        deleteRequest.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        deleteRequest.accessToken = createResult.accessToken;
        [deleteRequest setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            
            // 第三步：刷新主 token，保证后续测试用例正常
            [self refreshMainTokenWithCompletion:^(QCloudSMHTokenResult *refreshResult, NSError *refreshError) {
                XCTAssertNil(refreshError);
                XCTAssertNotNil(refreshResult);
                [expectation fulfill];
            }];
        }];
        [[QCloudSMHService defaultSMHService] deleteToken:deleteRequest];
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

#pragma mark - DeleteUserTokens

// 先创建临时用户的 token → 删除该用户所有 token → 刷新主 token
- (void)testQCloudSMHDeleteUserTokensRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DeleteUserTokensRequest"];
    
    // 第一步：为临时用户创建一个 token
    [self createTempTokenWithCompletion:^(QCloudSMHTokenResult *createResult, NSError *createError) {
        XCTAssertNil(createError);
        XCTAssertNotNil(createResult);
        
        // 第二步：删除该临时用户的所有 token
        QCloudSMHDeleteUserTokensRequest *request = [QCloudSMHDeleteUserTokensRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.librarySecret = QCloudSMHTestTools.singleTool.getLibrarySecretV2;
        request.userId = @"temp_user_for_delete_test";
        request.clientId = @"test_client_id";
        request.sessionId = @"test_session_id";
        [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            
            // 第三步：刷新主 token，保证后续测试用例正常
            [self refreshMainTokenWithCompletion:^(QCloudSMHTokenResult *refreshResult, NSError *refreshError) {
                XCTAssertNil(refreshError);
                XCTAssertNotNil(refreshResult);
                [expectation fulfill];
            }];
        }];
        [[QCloudSMHService defaultSMHService] deleteUserTokens:request];
    }];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
