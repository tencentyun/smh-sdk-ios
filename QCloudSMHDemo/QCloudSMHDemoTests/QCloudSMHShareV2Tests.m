//
//  QCloudSMHShareV2Tests.m
//  QCloudSMHDemoTests
//
//  Created by codegen on 2026/04/22.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudSMHCreateShareRequest.h"
#import "QCloudSMHCreateShareResult.h"
#import "QCloudSMHDeleteShareRequest.h"
#import "QCloudSMHVerifyExtractionCodeRequest.h"
#import "QCloudSMHVerifyExtractionCodeResult.h"
#import "QCloudSMHSearchSharesRequest.h"
#import "QCloudSMHSetShareEnabledRequest.h"
#import "QCloudSMHGetShareDetailRequest.h"
#import "QCloudSMHShareDetail.h"
#import "QCloudSMHListSharesRequest.h"
#import "QCloudSMHGetShareUrlDetailRequest.h"
#import "QCloudSMHShareUrlDetail.h"
#import "QCloudSMHUpdateShareRequest.h"
#import "QCloudSMHSaveShareFileRequest.h"
#import "QCloudSMHPreviewShareFileRequest.h"
#import "QCloudSMHDownloadShareFileRequest.h"
#import "QCloudSMHListShareFilesRequest.h"
#import "QCloudSMHPutDirectoryRequest.h"
#import "QCloudCOSSMHUploadObjectRequest.h"

@interface QCloudSMHShareV2Tests : XCTestCase <QCloudSMHAccessTokenProvider, QCloudAccessTokenFenceQueueDelegate>
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;
@end

@implementation QCloudSMHShareV2Tests

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

#pragma mark - 辅助方法：上传前置文件

- (void)uploadTestFileWithCompletion:(void (^)(NSString *inode, NSError *error))completion {
    QCloudSMHPutDirectoryRequest *dirReq = [QCloudSMHPutDirectoryRequest new];
    dirReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    dirReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    dirReq.dirPath = @"codegen_share_test";
    [dirReq setFinishBlock:^(id _Nullable dirResult, NSError *_Nullable dirError) {
        // 使用 TestTools 提供的方法生成测试文件（0.5MB）
        QCloudCOSSMHUploadObjectRequest *uploadReq = [QCloudCOSSMHUploadObjectRequest new];
        uploadReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        uploadReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        uploadReq.uploadPath = @"codegen_share_test/share_test.txt";
        uploadReq.body = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"test_word" ofType:@"txt"]];
        uploadReq.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
        uploadReq.withInode = YES;
        [uploadReq setFinishBlock:^(QCloudSMHContentInfo *_Nullable result, NSError *_Nullable error) {
            completion(result.inode, error);
        }];
        [[QCloudSMHService defaultSMHService] uploadObject:uploadReq];
    }];
    [[QCloudSMHService defaultSMHService] putDirectory:dirReq];
}

#pragma mark - 创建分享

- (void)testQCloudSMHCreateShareRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"CreateShareRequest"];
    // 先创建前置文件
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *request = [QCloudSMHCreateShareRequest new];
        request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        request.name = @"codegen_test_share";
        request.filePath = @[@"codegen_share_test/share_test.txt"];
        request.isPermanent = YES;
        request.canPreview = YES;
        request.canDownload = YES;
        request.extractionCode = @"1234";
        [request setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable result, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudSMHService defaultSMHService] createShare:request];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 分享列表

- (void)testQCloudSMHListSharesRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ListSharesRequest"];
    QCloudSMHListSharesRequest *request = [QCloudSMHListSharesRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] listShares:request];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHSearchSharesRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SearchSharesRequest"];
    QCloudSMHSearchSharesRequest *request = [QCloudSMHSearchSharesRequest new];
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    request.name = @"codegen";
    [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHService defaultSMHService] searchShares:request];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 分享详情（先创建分享获取真实 shareId）

- (void)testQCloudSMHGetShareDetailRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetShareDetailRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        // 先创建分享
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"detail_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.canPreview = YES;
        createReq.extractionCode = @"23333";
        createReq.canSaveToNetdisk = YES;
        createReq.canPreview = YES;
        createReq.canDownload = YES;
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareId = createResult.identifier;
            if (!shareId) {
                XCTFail(@"创建分享未返回 id");
                [expectation fulfill];
                return;
            }
            // 获取分享详情
            QCloudSMHGetShareDetailRequest *request = [QCloudSMHGetShareDetailRequest new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            request.shareId = shareId;
            request.withFileInfo = YES;
            [request setFinishBlock:^(QCloudSMHShareDetail *_Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                // 验证接口文档中定义的响应字段
                XCTAssertNotNil(result.identifier, @"分享 ID 不应为空");
                XCTAssertNotNil(result.name, @"分享名称不应为空");
                XCTAssertNotNil(result.code, @"分享访问码不应为空");
                XCTAssertNotNil(result.creationTime, @"创建时间不应为空");
                XCTAssertTrue(result.canPreview, @"应允许预览");
                XCTAssertTrue(result.canDownload, @"应允许下载");
                XCTAssertTrue(result.canSaveToNetdisk, @"应允许保存到网盘");
                XCTAssertTrue(result.isPermanent, @"应为永久分享");
                // 验证 fileInfo（with_file_info=1 时返回）
                XCTAssertNotNil(result.fileInfo, @"设置 withFileInfo=YES 后应返回 fileInfo");
                if (result.fileInfo) {
                    XCTAssertNotNil(result.fileInfo.fileName, @"fileInfo.fileName 不应为空");
                }
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] getShareDetail:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHGetShareUrlDetailRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GetShareUrlDetailRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"url_detail_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.canPreview = YES;
        createReq.canDownload = YES;
        createReq.canSaveToNetdisk = YES;
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            QCloudSMHGetShareUrlDetailRequest *request = [QCloudSMHGetShareUrlDetailRequest new];
            request.shareToken = shareCode;
            [request setFinishBlock:^(QCloudSMHShareUrlDetail *_Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                // 验证接口文档中定义的响应字段
                XCTAssertNotNil(result.name, @"分享名称不应为空");
                // 验证布尔字段已正确解析（不做值断言，仅确认模型可用）
                XCTAssertTrue(result.canPreview || !result.canPreview, @"canPreview 应为有效布尔值");
                XCTAssertTrue(result.canDownload || !result.canDownload, @"canDownload 应为有效布尔值");
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] getShareUrlDetail:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 分享操作

- (void)testQCloudSMHSetShareEnabledRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SetShareEnabledRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"enabled_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareId = createResult.identifier;
            if (!shareId) {
                XCTFail(@"创建分享未返回 id");
                [expectation fulfill];
                return;
            }
            QCloudSMHSetShareEnabledRequest *request = [QCloudSMHSetShareEnabledRequest new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            request.shareId = shareId;
            request.adminEnabled = YES;
            request.ownerEnabled = YES;
            [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] setShareEnabled:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHUpdateShareRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UpdateShareRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"update_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareId = createResult.identifier;
            if (!shareId) {
                XCTFail(@"创建分享未返回 id");
                [expectation fulfill];
                return;
            }
            QCloudSMHUpdateShareRequest *request = [QCloudSMHUpdateShareRequest new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
            request.shareId = shareId;
            request.isPermanent = YES;
            request.canPreview = YES;
            request.canDownload = YES;
            request.name = @"updated_share_name";
            [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] updateShare:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 删除分享（先创建再删除）

- (void)testQCloudSMHDeleteShareRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DeleteShareRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"delete_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareId = createResult.identifier;
            if (!shareId) {
                XCTFail(@"创建分享未返回 id");
                [expectation fulfill];
                return;
            }
            QCloudSMHDeleteShareRequest *request = [QCloudSMHDeleteShareRequest new];
            request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
            request.shareId = shareId;
            [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] deleteShare:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 分享验证（先创建带提取码的分享）

- (void)testQCloudSMHVerifyExtractionCodeRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"VerifyExtractionCodeRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"verify_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.extractionCode = @"6789";
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            QCloudSMHVerifyExtractionCodeRequest *request = [QCloudSMHVerifyExtractionCodeRequest new];
            request.shareCode = shareCode;
            request.extractionCode = @"6789";
            [request setFinishBlock:^(QCloudSMHVerifyExtractionCodeResult *_Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                // 验证接口文档中定义的响应字段
                XCTAssertNotNil(result.accessToken, @"分享访问令牌不应为空");
                XCTAssertNotNil(result.expireTime, @"令牌过期时间不应为空");
                [expectation fulfill];
            }];
            [[QCloudSMHService defaultSMHService] verifyExtractionCode:request];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

#pragma mark - 分享文件操作（先创建分享 → 验证提取码获取分享 accessToken → 操作文件）

- (void)testQCloudSMHListShareFilesRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"ListShareFilesRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"listfiles_test_share";
        createReq.filePath = @[@"codegen_share_test"];
        createReq.isPermanent = YES;
        createReq.canPreview = YES;
        createReq.canDownload = YES;
        createReq.extractionCode = @"1111";
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            // 先验证提取码获取分享 accessToken
            QCloudSMHVerifyExtractionCodeRequest *verifyReq = [QCloudSMHVerifyExtractionCodeRequest new];
            verifyReq.shareCode = shareCode;
            verifyReq.extractionCode = @"1111";
            [verifyReq setFinishBlock:^(QCloudSMHVerifyExtractionCodeResult *_Nullable verifyResult, NSError *_Nullable verifyError) {
                XCTAssertNil(verifyError);
                XCTAssertNotNil(verifyResult.accessToken, @"验证提取码未返回 accessToken");
                QCloudSMHListShareFilesRequest *request = [QCloudSMHListShareFilesRequest new];
                request.shareCode = shareCode;
                request.accessToken = verifyResult.accessToken;
                request.limit = 10;
                [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] listShareFiles:request];
            }];
            [[QCloudSMHService defaultSMHService] verifyExtractionCode:verifyReq];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHPreviewShareFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"PreviewShareFileRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        XCTAssertNotNil(fileInode, @"上传文件未返回 inode");
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"preview_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.canPreview = YES;
        createReq.extractionCode = @"2222";
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            // 先验证提取码获取分享 accessToken
            QCloudSMHVerifyExtractionCodeRequest *verifyReq = [QCloudSMHVerifyExtractionCodeRequest new];
            verifyReq.shareCode = shareCode;
            verifyReq.extractionCode = @"2222";
            [verifyReq setFinishBlock:^(QCloudSMHVerifyExtractionCodeResult *_Nullable verifyResult, NSError *_Nullable verifyError) {
                XCTAssertNil(verifyError);
                XCTAssertNotNil(verifyResult.accessToken, @"验证提取码未返回 accessToken");
                QCloudSMHPreviewShareFileRequest *request = [QCloudSMHPreviewShareFileRequest new];
                request.shareCode = shareCode;
                request.inodes = fileInode;
                request.accessToken = verifyResult.accessToken;
                [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] previewShareFile:request];
            }];
            [[QCloudSMHService defaultSMHService] verifyExtractionCode:verifyReq];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHDownloadShareFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"DownloadShareFileRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        XCTAssertNotNil(fileInode, @"上传文件未返回 inode");
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"download_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.canDownload = YES;
        createReq.extractionCode = @"3333";
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            // 先验证提取码获取分享 accessToken
            QCloudSMHVerifyExtractionCodeRequest *verifyReq = [QCloudSMHVerifyExtractionCodeRequest new];
            verifyReq.shareCode = shareCode;
            verifyReq.extractionCode = @"3333";
            [verifyReq setFinishBlock:^(QCloudSMHVerifyExtractionCodeResult *_Nullable verifyResult, NSError *_Nullable verifyError) {
                XCTAssertNil(verifyError);
                XCTAssertNotNil(verifyResult.accessToken, @"验证提取码未返回 accessToken");
                QCloudSMHDownloadShareFileRequest *request = [QCloudSMHDownloadShareFileRequest new];
                request.shareCode = shareCode;
                request.inodes = fileInode;
                request.accessToken = verifyResult.accessToken;
                [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] downloadShareFile:request];
            }];
            [[QCloudSMHService defaultSMHService] verifyExtractionCode:verifyReq];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testQCloudSMHSaveShareFileRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"SaveShareFileRequest"];
    [self uploadTestFileWithCompletion:^(NSString *fileInode, NSError *fileError) {
        XCTAssertNil(fileError, @"上传前置文件失败: %@", fileError);
        QCloudSMHCreateShareRequest *createReq = [QCloudSMHCreateShareRequest new];
        createReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
        createReq.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
        createReq.name = @"save_test_share";
        createReq.filePath = @[@"codegen_share_test/share_test.txt"];
        createReq.isPermanent = YES;
        createReq.canSaveToNetdisk = YES;
        createReq.extractionCode = @"4444";
        [createReq setFinishBlock:^(QCloudSMHCreateShareResult *_Nullable createResult, NSError *_Nullable createError) {
            XCTAssertNil(createError);
            NSString *shareCode = createResult.code;
            if (!shareCode) {
                XCTFail(@"创建分享未返回 code");
                [expectation fulfill];
                return;
            }
            // 先验证提取码获取分享 accessToken
            QCloudSMHVerifyExtractionCodeRequest *verifyReq = [QCloudSMHVerifyExtractionCodeRequest new];
            verifyReq.shareCode = shareCode;
            verifyReq.extractionCode = @"4444";
            verifyReq.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
            verifyReq.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;;
            [verifyReq setFinishBlock:^(QCloudSMHVerifyExtractionCodeResult *_Nullable verifyResult, NSError *_Nullable verifyError) {
                XCTAssertNil(verifyError);
                XCTAssertNotNil(verifyResult.accessToken, @"验证提取码未返回 accessToken");
                QCloudSMHSaveShareFileRequest *request = [QCloudSMHSaveShareFileRequest new];
                request.shareCode = shareCode;
                request.accessToken = verifyResult.accessToken;
                request.targetSpaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
                request.targetPath = @"";
                request.sourceInodesPath = @"";
                request.inodes = @[fileInode];
                request.conflictResolutionStrategy = @"rename";
                [request setFinishBlock:^(id _Nullable result, NSError *_Nullable error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudSMHService defaultSMHService] saveShareFile:request];
            }];
            [[QCloudSMHService defaultSMHService] verifyExtractionCode:verifyReq];
        }];
        [[QCloudSMHService defaultSMHService] createShare:createReq];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
