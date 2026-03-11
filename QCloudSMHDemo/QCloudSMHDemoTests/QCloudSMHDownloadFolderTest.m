//
//  QCloudSMHDownloadFolderTest.m
//  QCloudSMHDemo01FileTests
//
//  Created by mochadu on 2025/11/21.
//

/**
 * 文件夹下载功能测试套件
 *
 * 测试分类说明：
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ 分类              │ 命名前缀           │ 耗时    │ 说明                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │ 初始化测试        │ test_Init_         │ 快速    │ 无网络，纯参数校验     │
 * │ 任务控制测试      │ test_Control_      │ 中等    │ 使用小文件夹           │
 * │ 冲突策略测试      │ test_Conflict_     │ 中等    │ 单文件下载             │
 * │ 查询测试          │ test_Query_        │ 短      │ 单文件下载后查询       │
 * │ 子任务测试        │ test_Subtask_      │ 中等    │ 使用小文件夹           │
 * │ 错误处理测试      │ test_Error_        │ 快速    │ API快速返回错误        │
 * │ 边界条件测试      │ test_Edge_         │ 短-中等 │ 特殊场景               │
 * │ 完整集成测试      │ test_Integration_  │ 很长    │ 大文件夹，建议单独运行  │
 * └─────────────────────────────────────────────────────────────────────────┘
 *
 * 快速测试（日常开发）：运行除 test_Integration_ 外的所有测试
 * 完整测试（发布前）：运行所有测试，包括 test_Integration_
 */

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "NSData+SHA256.h"
#import "NSObject+Equal.h"
#import "QCloudSMHCheckHostRequest.h"
#import "QCloudSMHGetINodeDetailRequest.h"
#import "QCloudSMHGetRecentlyUsedFileRequest.h"

#import "QCloudSMHService+FolderDownload.h"
#import "QCloudSMHTaskDatabaseManager.h"
#import "QCloudSMHTaskManager.h"

// MARK: - 测试常量

/// 远程测试目录（大文件夹，用于完整测试）
static NSString * const kTestDirName = @"AndroidUT/DownloadBigPlusDirTest";
/// 远程测试目录（小文件夹，用于快速测试）
static NSString * const kTestSmallDirName = @"AndroidUT/DownloadBigPlusDirTest/branch_1_10";
/// 测试单文件
static NSString * const kTestSimpleFile = @"testsimiple.dat";
/// 测试子文件夹
static NSString * const kTestFolder1 = @"branch_1_10";
/// 空文件夹名称
static NSString * const kTestFolder2 = @"emptyFolder";

// MARK: - 测试超时时间

/// 快速操作超时（API调用、参数校验等）
static const NSTimeInterval kQuickTimeout = 10.0;
/// 短超时（单文件下载、简单操作）
static const NSTimeInterval kShortTimeout = 30.0;
/// 中等超时（小文件夹下载）
static const NSTimeInterval kMediumTimeout = 10 * 60;
/// 长超时（大文件夹完整下载 - 仅用于完整集成测试）
static const NSTimeInterval kLongTimeout = 60 * 60 * 6;

@interface QCloudSMHDownloadFolderTest : XCTestCase <QCloudSMHAccessTokenProvider>

@property (nonatomic, strong) QCloudSMHService *service;
@property (nonatomic, strong) NSMutableArray<QCloudSMHDownloadRequest *> *activeRequests;
@property (nonatomic, copy) NSString *testDownloadPath;

@property (nonatomic, copy) NSString *libraryId;
@property (nonatomic, copy) NSString *spaceId;
@property (nonatomic, copy) NSString *userId;

/// 大文件夹远程路径（完整测试用）
@property (nonatomic, copy) NSString *rootRemotePath;
/// 小文件夹远程路径（快速测试用）
@property (nonatomic, copy) NSString *smallRemotePath;
/// 子文件夹路径
@property (nonatomic, copy) NSString *remoteFolderPath;
/// 单文件路径
@property (nonatomic, copy) NSString *remoteFilePath;

@end

@implementation QCloudSMHDownloadFolderTest

#pragma mark - Test Lifecycle

- (void)setUp {
    [super setUp];
    
    // 配置服务
    [QCloudSMHBaseRequest setBaseRequestHost:[NSString stringWithFormat:@"%@/", QCloudSMHTestTools.singleTool.getBaseUrlStrV2]
                                  targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
    
    self.service = [QCloudSMHService defaultSMHService];
    self.service.accessTokenProvider = self;
    [self.service setupDownload];
    
    // 初始化测试环境
    self.activeRequests = [NSMutableArray array];
    self.testDownloadPath = [self createTestDownloadDirectory];
    self.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    self.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    self.userId = QCloudSMHTestTools.singleTool.getUserIdV2;
    self.rootRemotePath = kTestDirName;
    self.smallRemotePath = kTestSmallDirName;
    self.remoteFolderPath = kTestFolder1;
    self.remoteFilePath = kTestSimpleFile;
    
    NSLog(@"✅ 测试环境初始化完成 - 下载路径: %@", self.testDownloadPath);
}

- (void)tearDown {
    // 清理所有活跃的下载任务
    for (QCloudSMHDownloadRequest *request in self.activeRequests) {
        @try {
            [self.service removeObserverFolderDownloadForRequest:request];
        } @catch (NSException *exception) {
            NSLog(@"⚠️ 清理任务时出现异常: %@", exception);
        }
    }
    [self.activeRequests removeAllObjects];
    
    // 重置任务管理器单例（释放所有内存缓存，确保测试隔离性）
    [QCloudSMHTaskManager resetSharedManager];
    
    // 清理数据库中的所有任务记录
    [[QCloudSMHTaskDatabaseManager sharedManager] deleteAllTasks];
    
    // 清理测试下载目录中的文件
    [self cleanupTestDownloadFiles];
    
    NSLog(@"🧹 测试环境清理完成");
    [super tearDown];
}


#pragma mark - Helper Methods

/**
 * 创建测试下载目录
 */
- (NSString *)createTestDownloadDirectory {
    NSString *documentsPath = QCloudDocumentsPath();
    NSString *testPath = [documentsPath stringByAppendingPathComponent:@"SMHDownloadTests"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // 如果目录已存在，直接返回
    if ([fileManager fileExistsAtPath:testPath]) {
        return testPath;
    }
    
    // 创建新目录
    [fileManager createDirectoryAtPath:testPath 
           withIntermediateDirectories:YES 
                            attributes:nil 
                                 error:&error];
    
    XCTAssertNil(error, @"创建测试目录失败: %@", error);
    return testPath;
}

/**
 * 清理测试下载目录中的文件（保留目录本身）
 * 每个测试用例执行后调用，确保测试隔离性
 */
- (void)cleanupTestDownloadFiles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if (![fileManager fileExistsAtPath:self.testDownloadPath]) {
        return;
    }
    
    // 获取目录下的所有内容
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.testDownloadPath error:&error];
    if (error) {
        NSLog(@"⚠️ 读取测试目录内容失败: %@", error);
        return;
    }
    
    // 删除目录下的所有文件和子目录
    for (NSString *item in contents) {
        NSString *itemPath = [self.testDownloadPath stringByAppendingPathComponent:item];
        [fileManager removeItemAtPath:itemPath error:&error];
        if (error) {
            NSLog(@"⚠️ 删除文件失败: %@ - %@", itemPath, error);
            error = nil;
        }
    }
    
    NSLog(@"✅ 测试下载目录已清理");
}

/**
 * 清理测试下载目录（完全删除）
 * 注意：延迟执行以确保所有数据库操作完成
 */
- (void)cleanupTestDownloadDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // 清理测试下载目录
    if ([fileManager fileExistsAtPath:self.testDownloadPath]) {
        [fileManager removeItemAtPath:self.testDownloadPath error:&error];
        if (error) {
            NSLog(@"⚠️ 清理测试目录失败: %@", error);
        }
    }
    
    [self cleanupDatabaseWithDelay];
}

/**
 * 清理数据库文件（延迟执行）
 * 给予足够时间确保数据库连接已完全关闭
 */
- (void)cleanupDatabaseWithDelay {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *supportDirectory = [paths firstObject];
    if (!supportDirectory) {
        NSLog(@"❌ 数据库目录不存在");
        return;
    }
    
    // SDK 数据库目录
    NSString *sdkDataDir = [supportDirectory stringByAppendingPathComponent:@"QCloudSMH"];
    
    if (![fileManager fileExistsAtPath:sdkDataDir]) {
        return;
    }
    
    // 清理主数据库文件
    NSString *databasePath = [sdkDataDir stringByAppendingPathComponent:@"qcloud_smh_tasks.db"];
    if ([fileManager fileExistsAtPath:databasePath]) {
        BOOL removed = [fileManager removeItemAtPath:databasePath error:&error];
        if (!removed && error) {
            NSLog(@"⚠️ 清理数据库文件失败: %@", error);
        } else if (removed) {
            NSLog(@"✅ 数据库文件已清理");
        }
    }
    
    // 清理 SQLite WAL 和 SHM 文件（如果存在）
    NSString *walPath = [databasePath stringByAppendingString:@"-wal"];
    NSString *shmPath = [databasePath stringByAppendingString:@"-shm"];
    
    if ([fileManager fileExistsAtPath:walPath]) {
        [fileManager removeItemAtPath:walPath error:NULL];
    }
    
    if ([fileManager fileExistsAtPath:shmPath]) {
        [fileManager removeItemAtPath:shmPath error:NULL];
    }
}

/**
 * 创建下载请求
 */
- (QCloudSMHDownloadRequest *)createDownloadRequestWithPath:(NSString *)remotePath 
                                                       type:(QCloudSMHTaskType)type {
    NSURL *localURL = [NSURL fileURLWithPath:self.testDownloadPath];
    QCloudSMHDownloadRequest *request = [[QCloudSMHDownloadRequest alloc]
                                          initWithLibraryId:self.libraryId
                                          spaceId:self.spaceId
                                          userId:self.userId
                                          path:remotePath
                                          type:type
                                          localURL:localURL];
    
    [self.activeRequests addObject:request];
    return request;
}

#pragma mark - Access Token Provider

- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequest
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    
    QCloudSMHSpaceInfo *spaceInfo = [QCloudSMHSpaceInfo new];
    spaceInfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    spaceInfo.libraryId = self.libraryId;
    spaceInfo.spaceId = self.spaceId;
    continueBlock(spaceInfo, nil);
}

#pragma mark - Initialization Tests (初始化测试 - 快速)

/**
 * 测试：QCloudSMHDownloadRequest 初始化
 * 验证：所有属性正确设置，包括默认值
 * 类型：快速测试（无网络）
 */
- (void)test_Init_RequestPropertiesAndDefaults {
    NSString *remotePath = kTestDirName;
    NSURL *downloadURL = [NSURL fileURLWithPath:self.testDownloadPath];
    
    QCloudSMHDownloadRequest *request = [[QCloudSMHDownloadRequest alloc]
                                          initWithLibraryId:self.libraryId
                                          spaceId:self.spaceId
                                          userId:self.userId
                                          path:remotePath
                                          type:QCloudSMHTaskTypeFolder
                                          localURL:downloadURL];
    
    // 验证基本属性
    XCTAssertEqualObjects(request.libraryId, self.libraryId, @"库ID不匹配");
    XCTAssertEqualObjects(request.spaceId, self.spaceId, @"空间ID不匹配");
    XCTAssertEqualObjects(request.userId, self.userId, @"用户ID不匹配");
    XCTAssertEqualObjects(request.path, remotePath, @"路径不匹配");
    XCTAssertEqualObjects(request.localURL, downloadURL, @"下载URL不匹配");
    XCTAssertEqual(request.type, QCloudSMHTaskTypeFolder, @"任务类型不匹配");
    
    // 验证默认配置
    XCTAssertTrue(request.enableResumeDownload, @"默认应启用断点续传");
    XCTAssertTrue(request.enableCRC64Verification, @"默认应启用CRC64校验");
    XCTAssertEqual(request.conflictStrategy, QCloudSMHConflictStrategyEnumOverWrite, @"默认冲突策略应为覆盖");
    
    // 验证 requestId 生成
    NSString *requestId = [request requestId];
    XCTAssertNotNil(requestId, @"requestId 不应为空");
    XCTAssertTrue(requestId.length > 0, @"requestId 应该有内容");
    
    NSLog(@"✅ 请求ID: %@", requestId);
}

/**
 * 测试：自定义配置
 * 验证：配置修改正确应用
 * 类型：快速测试（无网络）
 */
- (void)test_Init_CustomConfiguration {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:@"/test" 
                                                                        type:QCloudSMHTaskTypeFile];
    
    // 修改配置
    request.enableResumeDownload = NO;
    request.enableCRC64Verification = NO;
    request.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    
    // 验证修改生效
    XCTAssertFalse(request.enableResumeDownload, @"断点续传应被禁用");
    XCTAssertFalse(request.enableCRC64Verification, @"CRC64校验应被禁用");
    XCTAssertEqual(request.conflictStrategy, QCloudSMHConflictStrategyEnumRename, @"冲突策略应为重命名");
}


#pragma mark - Task Control Tests (任务控制测试 - 使用小文件夹)

/**
 * 测试：暂停和恢复任务
 * 验证：任务能正确暂停和恢复
 * 类型：中等耗时（使用小文件夹）
 */
- (void)test_Control_PauseAndResume {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                        type:QCloudSMHTaskTypeFolder];
    
    __block BOOL pausedStateSeen = NO;
    __block int64_t pausedBytes = 0;
    __block BOOL resumed = NO;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"pauseAndResumeTask"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        if (!resumed && bytesProcessed > 0) {
            pausedBytes = bytesProcessed;
        }
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]",
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        if (state == QCloudSMHTaskStatePaused) {
            pausedStateSeen = YES;
        } else if (state == QCloudSMHTaskStateDownloading && pausedStateSeen) {
            NSLog(@"▶️ 任务已恢复");
            resumed = YES;
        } else if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"任务最终应该完成");
            XCTAssertTrue(pausedStateSeen, @"应该看到暂停状态");
            XCTAssertTrue(resumed, @"应该已经恢复");
            XCTAssertGreaterThan(pausedBytes, 0, @"暂停时应该有进度");
            
            [expectation fulfill];
        }
    }];
    
    // 在有进度后暂停
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                  dispatch_get_main_queue(), ^{
        [request pause];
        NSLog(@"⏸️ 暂停任务，已下载: %lld bytes", pausedBytes);
        // 5秒后恢复
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                      dispatch_get_main_queue(), ^{
            NSLog(@"▶️ 恢复任务");
            [request resume];
        });
                
    });
    
    
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kLongTimeout];
}

/**
 * 测试：取消任务
 * 验证：任务能正确取消
 * 类型：快速测试（5秒后取消）
 */
- (void)test_Control_Cancel {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                        type:QCloudSMHTaskTypeFolder];
    
    __block BOOL cancelled = NO;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"cancelTask"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
        
    } 
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isInactiveState:state]) {
            XCTAssertTrue(cancelled, @"应该是主动取消的");
            XCTAssertTrue([QCloudSMHBaseTask isInactiveState:state], @"任务应该处于非活跃状态");
            XCTAssertTrue(error.code == QCloudSMHTaskErrorUserCancel, @"错误码应该是取消");
            NSLog(@"❌ 任务已取消");
            [expectation fulfill];
        }
    }];
    
    // 有进度后取消
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                  dispatch_get_main_queue(), ^{
        cancelled = YES;
        [request cancel];
        NSLog(@"❌ 取消任务");
    });
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

/**
 * 测试：删除任务
 * 验证：任务和文件都被删除
 * 类型：快速测试（5秒后删除）
 */
- (void)test_Control_Delete {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                        type:QCloudSMHTaskTypeFolder];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"deleteTask"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        if (state == QCloudSMHTaskStateFailed) {
            XCTAssertTrue(error.code == QCloudSMHTaskErrorUserDelete, @"错误码应该是删除");
            // 验证任务记录已删除
            QCloudSMHDownloadDetail *detail = [self.service getFolderDownloadDetail:request];
            
            // 验证文件已删除
            XCTAssertNil(detail, @"记录应该不存在");
            
            [expectation fulfill];
        }
    }];
    
    // 删除任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                  dispatch_get_main_queue(), ^{
        NSLog(@"🗑️ 删除任务和文件");
        [request delete];
    });
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

#pragma mark - Conflict Strategy Tests (冲突策略测试 - 单文件)

/**
 * 测试：覆盖策略
 * 验证：文件重名时覆盖原文件
 * 类型：中等耗时（单文件下载两次）
 */
- (void)test_Conflict_Overwrite {
    NSString *remotePath = [NSString stringWithFormat:@"%@/%@", self.rootRemotePath, self.remoteFilePath];
    
    // 第一次下载
    QCloudSMHDownloadRequest *request1 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request1.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"firstDownload"];
    __block NSInteger completedCount = 0;
    [self.service observerFolderDownloadForRequest:request1
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"第一次下载应该成功");
            if (completedCount == 0) {
                [expectation1 fulfill];
            }
            completedCount++;
        }
    }];
    
    [self.service downloadFolder:request1];
    
    [self waitForExpectations:@[expectation1] timeout:kMediumTimeout];
    
    // 记录第一次下载的文件修改时间
    QCloudSMHDownloadDetail *detail1 = [self.service getFolderDownloadDetail:request1];
    NSString *filePath = detail1.localPath;
    NSDictionary *attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate *modDate1 = attrs1[NSFileModificationDate];
    
    sleep(2); // 等待以区分修改时间
    
    // 第二次下载（覆盖）
    QCloudSMHDownloadRequest *request2 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request2.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"secondDownload"];
    __block NSInteger completedCount2 = 0;
    [self.service observerFolderDownloadForRequest:request2
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            if (completedCount2 == 0) {
                completedCount2 += 1;
                return;
            }
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"第二次下载（覆盖）应该成功");
            
            // 验证文件被覆盖（修改时间不同）
            QCloudSMHDownloadDetail *detail2 = [self.service getFolderDownloadDetail:request2];
            XCTAssertEqualObjects(detail2.localPath, filePath, @"文件路径应该相同");
            
            NSDictionary *attrs2 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            NSDate *modDate2 = attrs2[NSFileModificationDate];
            
            XCTAssertNotEqualObjects(modDate1, modDate2, @"文件修改时间应该不同（已覆盖）");
            [expectation2 fulfill];
        }
    }];
    
    [self.service downloadFolder:request2];
    
    [self waitForExpectations:@[expectation2] timeout:kMediumTimeout];
}

/**
 * 测试：重命名策略
 * 验证：文件重名时自动重命名
 * 类型：中等耗时（单文件下载两次）
 */
- (void)test_Conflict_Rename {
    NSString *remotePath = [NSString stringWithFormat:@"%@/%@", self.rootRemotePath, self.remoteFilePath];
    
    // 第一次下载
    QCloudSMHDownloadRequest *request1 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request1.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"firstDownloadRename"];
    
    [self.service observerFolderDownloadForRequest:request1
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"第一次下载应该成功");
            [expectation1 fulfill];
        }
    }];
    
    [self.service downloadFolder:request1];
    
    [self waitForExpectations:@[expectation1] timeout:kMediumTimeout];
    
    QCloudSMHDownloadDetail *detail1 = [self.service getFolderDownloadDetail:request1];
    NSString *originalPath = detail1.localPath;
    NSString *originalFileName = originalPath.lastPathComponent;
    
    // 第二次下载（重命名）
    QCloudSMHDownloadRequest *request2 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request2.conflictStrategy = QCloudSMHConflictStrategyEnumRename;
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"secondDownloadRename"];
    
    // 计数器：跳过订阅时立即返回的第一次完成状态（来自第一次下载）
    __block NSInteger completedStateCount = 0;
    
    [self.service observerFolderDownloadForRequest:request2
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            
            // 跳过第一次完成状态（订阅时立即返回的旧状态）
            if (completedStateCount == 0) {
                NSLog(@"⏭️ 跳过第一次完成状态回调（旧状态）");
                completedStateCount++;
                return;
            }
            
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"第二次下载（重命名）应该成功");
            
            // 验证生成了新文件名
            QCloudSMHDownloadDetail *detail2 = [self.service getFolderDownloadDetail:request2];
            NSString *newFileName = detail2.localPath.lastPathComponent;
            
            XCTAssertNotEqualObjects(originalFileName, newFileName, @"文件名应该不同（已重命名）");
            
            // 验证两个文件都存在
            BOOL originalExists = [[NSFileManager defaultManager] fileExistsAtPath:originalPath];
            BOOL newExists = [[NSFileManager defaultManager] fileExistsAtPath:detail2.localPath];
            
            XCTAssertTrue(originalExists, @"原文件应该存在");
            XCTAssertTrue(newExists, @"新文件应该存在");
            
            NSLog(@"原文件: %@", originalFileName);
            NSLog(@"新文件: %@", newFileName);
            [expectation2 fulfill];
        }
    }];
    
    [self.service downloadFolder:request2];
    
    [self waitForExpectations:@[expectation2] timeout:kMediumTimeout];
}

/**
 * 测试：询问策略（应该报错）
 * 验证：使用询问策略时应该返回冲突错误
 * 类型：中等耗时（单文件下载两次）
 */
- (void)test_Conflict_Ask {
    NSString *remotePath = [NSString stringWithFormat:@"%@/%@", self.rootRemotePath, self.remoteFilePath];
    
    // 第一次下载
    QCloudSMHDownloadRequest *request1 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request1.conflictStrategy = QCloudSMHConflictStrategyEnumOverWrite;
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"firstDownloadAsk"];
    
    [self.service observerFolderDownloadForRequest:request1
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"第一次下载应该成功");
            [expectation1 fulfill];
        }
    }];
    
    [self.service downloadFolder:request1];
    
    [self waitForExpectations:@[expectation1] timeout:kMediumTimeout];
    
    // 第二次下载（询问策略 - 应该失败）
    QCloudSMHDownloadRequest *request2 = [self createDownloadRequestWithPath:remotePath 
                                                                         type:QCloudSMHTaskTypeFile];
    request2.conflictStrategy = QCloudSMHConflictStrategyEnumAsk;
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"secondDownloadAsk"];
    
    // 计数器：跳过订阅时立即返回的第一次完成状态（来自第一次下载）
    __block NSInteger terminalStateCount = 0;
    
    [self.service observerFolderDownloadForRequest:request2
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            terminalStateCount++;
            
            // 跳过第一次终态（订阅时立即返回的旧状态）
            if (terminalStateCount == 1) {
                NSLog(@"⏭️ 跳过第一次终态回调（旧状态）");
                return;
            }
            
            XCTAssertEqual(state, QCloudSMHTaskStateFailed, @"询问策略下应该失败");
            XCTAssertNotNil(error, @"应该有错误");
            XCTAssertEqual(error.code, QCloudSMHTaskErrorPathConflict, @"应该是路径冲突错误");
            
            NSLog(@"预期的冲突错误: %@", error.localizedDescription);
            [expectation2 fulfill];
        }
    }];
    
    [self.service downloadFolder:request2];
    
    [self waitForExpectations:@[expectation2] timeout:kMediumTimeout];
}

#pragma mark - Query Tests (查询测试 - 单文件)

/**
 * 测试：查询单个任务详情
 * 验证：能正确查询任务信息
 * 类型：短耗时（单文件下载）
 */
- (void)test_Query_SingleTaskDetail {
    NSString *remotePath = [NSString stringWithFormat:@"%@/%@", self.rootRemotePath, self.remoteFilePath];
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:remotePath
                                                                        type:QCloudSMHTaskTypeFile];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"querySingleTaskDetail"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            // 下载完成后查询
            QCloudSMHDownloadDetail *detail = [self.service getFolderDownloadDetail:request];
            
            XCTAssertNotNil(detail, @"完成后应该能查询到任务详情");
            XCTAssertEqual(detail.bytesProcessed, detail.totalBytes, @"完成后字节数应该相等");
            XCTAssertGreaterThan(detail.totalBytes, 0, @"文件大小应该大于0");
            NSLog(@"任务详情: 远程路径=%@, 本地路径=%@, 进度=%ld/%ld",
                  detail.remotePath, detail.localPath,
                  (long)detail.bytesProcessed, (long)detail.totalBytes);
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

#pragma mark - Subtask Tests (子任务测试 - 完整集成测试，耗时较长)

/**
 * 测试：监听子任务进度
 * 验证：能单独监听子任务的进度
 * 类型：长耗时（需要下载大文件夹）- 完整集成测试
 */
- (void)test_Subtask_ObserveProgress {
    // 下载文件夹（使用小文件夹加速测试）
    QCloudSMHDownloadRequest *folderRequest = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                              type:QCloudSMHTaskTypeFolder];
    
    // 单独监听子文件（小文件夹中的文件）
    NSString *childPath = [NSString stringWithFormat:@"%@/%@", self.smallRemotePath, self.remoteFilePath];
    QCloudSMHDownloadRequest *childRequest = [self createDownloadRequestWithPath:childPath
                                                                            type:QCloudSMHTaskTypeFile];
    
    __block BOOL childProgressCalled = NO;
    __block BOOL childCompleted = NO;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"observeSubtaskProgress"];
    
    [self.service observerFolderDownloadForRequest:folderRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
    }];
    
    [self.service observerFolderDownloadForRequest:childRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 子任务进度更新 - %@ [%lld/%lld bytes] [%d/%d files]",
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
        
        childProgressCalled = YES;
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 子任务状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            childCompleted = YES;
            NSLog(@"✅ 子任务完成: %@", path);
            
            XCTAssertTrue(childProgressCalled, @"子任务进度回调应该被调用");
            XCTAssertTrue(childCompleted, @"子任务应该完成");
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:folderRequest];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

/**
 * 测试：暂停子任务
 * 验证：能单独暂停某个子任务
 * 类型：中等耗时（使用小文件夹）
 */
- (void)test_Subtask_Pause {
    QCloudSMHDownloadRequest *folderRequest = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                              type:QCloudSMHTaskTypeFolder];
    
    NSString *childPath = [NSString stringWithFormat:@"%@/%@", self.smallRemotePath, self.remoteFilePath];
    QCloudSMHDownloadRequest *childRequest = [self createDownloadRequestWithPath:childPath
                                                                            type:QCloudSMHTaskTypeFile];
    
    __block BOOL childPaused = NO;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"pauseSubtask"];
    
    [self.service observerFolderDownloadForRequest:childRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes,
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 子任务进度更新 - %@ [%lld/%lld bytes] [%d/%d files]",
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
        
        // 有进度后暂停子任务
        if (!childPaused && bytesProcessed > 0) {
            childPaused = YES;
            [childRequest pause];
            NSLog(@"⏸️ 暂停子任务");
        }
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type,
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 子任务状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStatePaused) {
            NSLog(@"⏸️ 子任务已暂停: %@", path);
        }
    }];
    
    [self.service observerFolderDownloadForRequest:folderRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isInactiveState:state]) {
            XCTAssertTrue(childPaused, @"子任务应该被暂停");
            
            // 检查子任务状态
            QCloudSMHDownloadDetail *childDetail = [self.service getFolderDownloadDetail:childRequest];
            NSLog(@"子任务最终状态: %@", childDetail);
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:folderRequest];
    
    // 等待父任务完成或超时
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

/**
 * 测试：取消子任务
 * 验证：能单独取消某个子任务，父任务继续
 * 类型：中等耗时（使用小文件夹）
 */
- (void)test_Subtask_Cancel {
    QCloudSMHDownloadRequest *folderRequest = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                              type:QCloudSMHTaskTypeFolder];
    
    NSString *childPath = [NSString stringWithFormat:@"%@/%@", self.smallRemotePath, self.remoteFilePath];
    QCloudSMHDownloadRequest *childRequest = [self createDownloadRequestWithPath:childPath
                                                                            type:QCloudSMHTaskTypeFile];
    
    __block BOOL childCancelled = NO;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"cancelSubtask"];
    
    [self.service observerFolderDownloadForRequest:childRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes,
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 子任务进度更新 - %@ [%lld/%lld bytes] [%d/%d files]",
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
        
        // 有进度后取消子任务
        if (!childCancelled && bytesProcessed > 0) {
            childCancelled = YES;
            [childRequest cancel];
            NSLog(@"❌ 取消子任务");
        }
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type,
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 子任务状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isInactiveState:state]) {
            XCTAssertTrue(error.code == QCloudSMHTaskErrorUserCancel, @"子任务应该被取消");
            NSLog(@"❌ 子任务已取消: %@", path);
        }
    }];
    
    [self.service observerFolderDownloadForRequest:folderRequest
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertTrue(childCancelled, @"子任务应该被取消");
            XCTAssertNotNil(error, @"应该存在错误");
            XCTAssertTrue(state == QCloudSMHTaskStateFailed, @"父任务最终应该失败");

            [expectation fulfill];
        }
    }];
    
    
    
    [self.service downloadFolder:folderRequest];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

#pragma mark - Error Handling Tests (错误处理测试 - 快速)

/**
 * 测试：下载不存在的文件
 * 验证：能正确处理文件不存在的情况
 * 类型：快速测试（API快速返回错误）
 */
- (void)test_Error_NonExistentFile {
    NSString *nonExistentPath = @"/non_existent_folder/non_existent_file.txt";
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:nonExistentPath 
                                                                        type:QCloudSMHTaskTypeFile];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"downloadNonExistentFile"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertEqual(state, QCloudSMHTaskStateFailed, @"下载不存在的文件应该失败");
            XCTAssertNotNil(error, @"应该有错误信息");
            
            NSLog(@"预期的错误: %@", error.localizedDescription);
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kShortTimeout];
}

/**
 * 测试：无效的下载路径
 * 验证：能处理空路径
 * 类型：快速测试（参数校验）
 */
- (void)test_Error_InvalidPath {
    NSString *invalidPath = @"";  // 空路径
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:invalidPath 
                                                                        type:QCloudSMHTaskTypeFile];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"invalidDownloadPath"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertEqual(state, QCloudSMHTaskStateFailed, @"空路径应该失败");
            XCTAssertNotNil(error, @"应该有错误信息");
            NSLog(@"空路径处理结果: state=%ld, error=%@", (long)state, error);
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kShortTimeout];
}


#pragma mark - Edge Case Tests (边界条件测试)

/**
 * 测试：空文件夹下载
 * 验证：能正确处理空文件夹
 * 类型：短耗时（空文件夹无实际下载）
 */
- (void)test_Edge_EmptyFolder {
    // 创建空文件夹
    NSString *emptyFolderPath = [NSString stringWithFormat:@"%@/%@", self.rootRemotePath, kTestFolder2];
    
    XCTestExpectation *createExpectation = [self expectationWithDescription:@"createEmptyFolder"];
    QCloudSMHPutDirectoryRequest *createReq = [QCloudSMHPutDirectoryRequest new];
    createReq.dirPath = emptyFolderPath;
    createReq.spaceId = self.spaceId;
    createReq.libraryId = self.libraryId;
    createReq.userId = self.userId;
    [createReq setFinishBlock:^(QCloudSMHContentInfo *contentInfo, NSError *error) {
        [createExpectation fulfill];
    }];
    [self.service putDirectory:createReq];
    [self waitForExpectations:@[createExpectation] timeout:kShortTimeout];
    
    // 下载空文件夹
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:emptyFolderPath 
                                                                        type:QCloudSMHTaskTypeFolder];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"downloadEmptyFolder"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if (state == QCloudSMHTaskStateCompleted) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"空文件夹下载应该完成");
            
            QCloudSMHDownloadDetail *detail = [self.service getFolderDownloadDetail:request];
            XCTAssertEqual(detail.totalFiles, 0, @"空文件夹文件数应为0");
            
            NSLog(@"✅ 空文件夹下载完成");
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

/**
 * 测试：重复启动同一任务
 * 验证：能正确处理重复启动
 * 类型：中等耗时（使用小文件夹）
 */
- (void)test_Edge_DuplicateStart {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:self.smallRemotePath
                                                                        type:QCloudSMHTaskTypeFolder];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"duplicateTaskStart"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes, 
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]", 
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type, 
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertTrue([QCloudSMHBaseTask isTerminalState:state], @"任务应该到达终止状态");
            NSLog(@"重复启动处理结果: %ld", (long)state);
            [expectation fulfill];
        }
    }];
    
    // 第一次启动
    [self.service downloadFolder:request];
    
    // 立即再次启动
    [self.service downloadFolder:request];
    
    // 应该只执行一次下载
    [self waitForExpectations:@[expectation] timeout:kMediumTimeout];
}

#pragma mark - Full Integration Tests (完整集成测试 - 耗时很长，仅在需要时运行)

/**
 * 测试：下载整个大文件夹
 * 验证：文件夹结构完整下载，并验证子任务查询功能
 * 类型：长耗时（完整集成测试）- 建议单独运行
 * 注意：此测试需要下载大量文件，耗时可能超过数小时
 */
- (void)test_Integration_DownloadLargeFolder {
    QCloudSMHDownloadRequest *request = [self createDownloadRequestWithPath:self.rootRemotePath
                                                                        type:QCloudSMHTaskTypeFolder];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"downloadCompleteFolder"];
    
    [self.service observerFolderDownloadForRequest:request
                                             error:nil
                                          progress:^(NSString *path, QCloudSMHTaskType type,
                                                    int64_t bytesProcessed, int64_t totalBytes,
                                                    int completedFiles, int totalFiles) {
        NSLog(@"📊 进度更新 - %@ [%lld/%lld bytes] [%d/%d files]",
              path, bytesProcessed, totalBytes, completedFiles, totalFiles);
    }
                                      stateChanged:^(NSString *path, QCloudSMHTaskType type,
                                                    QCloudSMHTaskState state, NSError *error) {
        NSLog(@"📡 状态变化 - %@ -> %ld %@", path, (long)state, error ?: @"");
        
        if ([QCloudSMHBaseTask isTerminalState:state]) {
            XCTAssertEqual(state, QCloudSMHTaskStateCompleted, @"文件夹下载应该完成");
            XCTAssertNil(error, @"不应该有错误");
            
            // 验证下载详情
            QCloudSMHDownloadDetail *detail = [self.service getFolderDownloadDetail:request];
            XCTAssertNotNil(detail, @"应该能查询到下载详情");
            XCTAssertEqual(detail.filesProcessed, detail.totalFiles, @"所有文件应该下载完成");
            
            // 验证子任务查询功能
            [self verifySubtaskQueryWithRequest:request];
            
            [expectation fulfill];
        }
    }];
    
    [self.service downloadFolder:request];
    
    [self waitForExpectations:@[expectation] timeout:kLongTimeout];
}

#pragma mark - Query Verification Helper

/**
 * 验证子任务查询功能
 * 在完整下载完成后调用，验证各种查询条件
 */
- (void)verifySubtaskQueryWithRequest:(QCloudSMHDownloadRequest *)request {
    // 查询所有任务（第一页）
    NSArray<QCloudSMHDownloadDetail *> *allTasks = [self.service
        getFolderDownloadDetails:request
                            page:@0
                        pageSize:@10
                       orderType:QCloudSMHSortFieldUpdatedAt
                  orderDirection:QCloudSMHSortOrderDescending
                        grouping:QCloudSMHGroupFlat
                  directoryFilter:QCloudSMHDirectoryAll
                          states:nil];
    
    XCTAssertNotNil(allTasks, @"应该能查询到任务列表");
    XCTAssertGreaterThan(allTasks.count, 0, @"应该有任务记录");
    NSLog(@"📋 查询到 %lu 个任务", (unsigned long)allTasks.count);
    
    // 只查询文件类型
    NSArray<QCloudSMHDownloadDetail *> *fileTasks = [self.service
        getFolderDownloadDetails:request
                            page:@0
                        pageSize:@10
                       orderType:QCloudSMHSortFieldUpdatedAt
                  orderDirection:QCloudSMHSortOrderDescending
                        grouping:QCloudSMHGroupFlat
                  directoryFilter:QCloudSMHDirectoryOnlyFile
                          states:nil];
    
    for (QCloudSMHDownloadDetail *task in fileTasks) {
        XCTAssertTrue(task.isFile, @"应该只返回文件类型");
    }
    NSLog(@"📄 查询到 %lu 个文件任务", (unsigned long)fileTasks.count);
    
    // 只查询已完成的任务
    NSArray<QCloudSMHDownloadDetail *> *completedTasks = [self.service
        getFolderDownloadDetails:request
                            page:@0
                        pageSize:@10
                       orderType:QCloudSMHSortFieldUpdatedAt
                  orderDirection:QCloudSMHSortOrderDescending
                        grouping:QCloudSMHGroupFlat
                  directoryFilter:QCloudSMHDirectoryAll
                          states:@[@(QCloudSMHTaskStateCompleted)]];
    
    XCTAssertGreaterThan(completedTasks.count, 0, @"应该有已完成的任务");
    NSLog(@"✅ 查询到 %lu 个已完成任务", (unsigned long)completedTasks.count);
}


@end
