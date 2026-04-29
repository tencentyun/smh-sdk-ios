//
//  QCloudSMHRecycleV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHRecycleSetLifecycleRequest.h"

@interface QCloudSMHRecycleV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHRecycleV2Tests

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

- (void)testQCloudSMHRecycleSetLifecycleRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"RecycleSetLifecycleRequest"];
    QCloudSMHRecycleSetLifecycleRequest *request = [QCloudSMHRecycleSetLifecycleRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.retentionDays = 30;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] recycleSetLifecycle:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end
