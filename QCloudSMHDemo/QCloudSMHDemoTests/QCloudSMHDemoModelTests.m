//
//  QCloudSMHDemoModelTests.m
//  QCloudSMHDemoModelTests
//
//  Created by garenwang on 2022/5/12.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "NSData+SHA256.h"
#import "NSObject+Equal.h"
#import "NSObject+QCloudModel.h"
#import "QCloudSMHSpaceHomeFileInfo.h"
#import "QCloudSMHFavoriteTypeEnum.h"
#import "QCloudAbstractRequest+Quality.h"
@interface QCloudSMHDemoModelTests : XCTestCase

@end

@implementation QCloudSMHDemoModelTests
- (void)testModel {
    QCloudSMHINodeDetailInfo * detailInfo = [QCloudSMHINodeDetailInfo new];
    [detailInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [detailInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{}];
    [detailInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"type":@"file"}];
    
    [QCloudSMHSpaceHomeFileInfo.class performSelector:@selector(modelContainerPropertyGenericClass)];
    
    [QCloudSMHTeamInfo.class performSelector:@selector(modelCustomPropertyMapper)];
    
    [QCloudSMHTeamInfo.class performSelector:@selector(modelContainerPropertyGenericClass)];
    QCloudSMHTeamInfo * info = QCloudSMHTeamInfo.new;
    QCloudSMHTeamInfo * info1 = QCloudSMHTeamInfo.new;
    [info isEqual:info];
    [info isEqual:info1];
    [info isEqual:@"test"];
    
    QCloudSMHSpaceInfo * spaceInfo = QCloudSMHSpaceInfo.new;
    spaceInfo.beginDate = NSDate.now;
    NSDate * date = spaceInfo.beginDate;
}

- (void)testNULL {
    NSNull * obj = [NSNull new];
    NSInteger length = obj.length;
    obj.integerValue;
    obj.floatValue;
    obj.doubleValue;
    obj.intValue;
    obj.stringValue;
    obj.boolValue;
    obj.longLongValue;
    [obj hasPrefix:@""];
    [obj hasSuffix:@""];
    [obj isEqualToString:@""];
    
    QCloudSMHRoleInfo * info = QCloudSMHRoleInfo.new;
    QCloudSMHRoleInfo * info1 = QCloudSMHRoleInfo.new;
    [info isEqual:info1];
}
- (void)testDicToModel {
    NSArray <Class> * classes = @[
        QCloudSMHSearchListInfo.class,
        QCloudFileTagItemModel.class,
        QCloudSMHMultipartUploadPart.class,
        QCloudSMHSearchTeamInfo.class,
        QCloudSMHTeamInfoPathNode.class,
        QCloudSMHUploadObjectResult.class,
        QCloudSMHUploadPartResult.class,
        QCloudSMHTaskResultInfo.class,
        QCloudSMHSpaceInfo.class,
        QCloudSMHRecentlyUsedFileInfo.class,
        QCloudSMHListHistoryVersionResult.class,
        QCloudSMHUserInfo.class,
        QCloudSMHUploadStateInfo.class,
        QCloudSMHMultipartInfo.class,
        QCloudSMHBaseDynamicList.class,
        QCloudSMHSpaceDynamicList.class,
        QCloudSMHDynamicListContent.class,
        QCloudSMHWorkBenchDynamicList.class,
        QCloudSMHWorkBenchDynamicListContentItem.class,
        QCloudSMHWorkBenchDynamicListContentItemDetail.class,
        QCloudSMHDownloadInfoModel.class,
        QCloudSMHHistoryVersionInfo.class,
        QCloudSMHListHistoryVersionResult.class,
        QCloudSMHRenameResult.class,
        QCloudSMHDownloadInfoModel.class,
        QCloudTagModel.class,
        QCloudSMHSearchTag.class,
        QCloudSMHCopyResult.class,
        QCloudQueryTagFilesInfo.class,
    ];
    for (Class obj in classes) {
        NSObject * result = [obj new];
        if ([obj respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
            [obj performSelector:@selector(modelContainerPropertyGenericClass)];
        }
        if ([obj respondsToSelector:@selector(modelCustomPropertyMapper)]) {
            [obj performSelector:@selector(modelCustomPropertyMapper)];
        }
        if ([result respondsToSelector:@selector(modelCustomTransformToDictionary)]) {
            [result performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{}];
            [result performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
        }
        
        if ([result respondsToSelector:@selector(modelCustomWillTransformFromDictionary:)]) {
            [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{}];
            [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
        }
    }
}

-(void)testCoverModel{
    [QCloudCOSSMHConfig setCanSMHUploadBeacon:NO];
    [QCloudCOSSMHConfig disableSMHStartBeacon:YES];
}

- (void)testSMHEqual {
    [@"test" smh_isEqual:@"test1"];
    [@(1) smh_isEqual:@(1)];
    QCloudSMHBizRequest * req = [QCloudSMHBizRequest new];
    QCloudSMHBizRequest * req1 = [QCloudSMHBizRequest new];
    [req smh_isEqual:req];
    [req smh_isEqual:req1];
}

#pragma mark - QCloudSMHOrderByTransferToString Tests
- (void)testQCloudSMHOrderByTransferToString {
    // 测试所有已知类型
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeName), @"name");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeMTime), @"modificationTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeSize), @"size");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeCTime), @"creationTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeExpireTime), @"expireTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeFavoriteTime), @"favoriteTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeVisitTime), @"visitTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeRemovalTime), @"removalTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeRemainingTime), @"remainingTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeUploadTime), @"uploadTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeLocalCreationTime), @"localCreationTime");
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString(QCloudSMHSortTypeLocalModificationTime), @"localModificationTime");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHOrderByTransferToString((QCloudSMHSortType)999), @"name");
}

#pragma mark - QCloudSMHGetGroupSortTypeTransferToString Tests
- (void)testQCloudSMHGetGroupSortTypeTransferToString {
    // 测试所有分支
    XCTAssertEqualObjects(QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGroupSortTypeCreationTime), @"creationTime");
    XCTAssertEqualObjects(QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGroupSortTypeCreationTimeReverse), @"creationTime");
    XCTAssertEqualObjects(QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGroupSortTypeJoinTime), @"joinTime");
    XCTAssertEqualObjects(QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGroupSortTypeJoinTimeReverse), @"joinTime");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHGetGroupSortTypeTransferToString((QCloudSMHGetGroupSortType)999), @"");
}

#pragma mark - QCloudSMHGroupMemberSortTypeTransferToString Tests
- (void)testQCloudSMHGroupMemberSortTypeTransferToString {
    // 测试所有分支
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByRole), @"groupRole");
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByRoleAsc), @"groupRole");
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByEnabled), @"enabled");
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByEnabledAsc), @"enabled");
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByNickname), @"nickname");
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortByNicknameAsc), @"nickname");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHGroupMemberSortTypeTransferToString((QCloudSMHGroupMemberSortType)999), @"");
}

#pragma mark - QCloudSMHGroupJoinTypeTransferToString Tests
- (void)testQCloudSMHGroupJoinTypeTransferToString {
    XCTAssertEqualObjects(QCloudSMHGroupJoinTypeTransferToString(QCloudSMHGroupJoinTypeOwn), @"own");
    XCTAssertEqualObjects(QCloudSMHGroupJoinTypeTransferToString(QCloudSMHGroupJoinTypeJoin), @"join");
    XCTAssertEqualObjects(QCloudSMHGroupJoinTypeTransferToString(QCloudSMHGroupJoinTypeAll), @"all");
    
    // 测试未定义类型默认返回all
    XCTAssertEqualObjects(QCloudSMHGroupJoinTypeTransferToString((QCloudSMHGroupJoinType)999), @"all");
}

#pragma mark - QCloudSMHTemporaryUserSortTypeTransferToString Tests
- (void)testQCloudSMHTemporaryUserSortTypeTransferToString {
    // 测试所有分支
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortByEnabled), @"enabled");
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortByEnabledAsc), @"enabled");
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortByNickname), @"nickname");
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortByNicknameAsc), @"nickname");
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortNone), @"");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHTemporaryUserSortTypeTransferToString((QCloudSMHTemporaryUserSortType)999), @"");
}

#pragma mark - QCloudSMHShareSortTypeTransferToString Tests
- (void)testQCloudSMHShareSortTypeTransferToString {
    // 测试所有分支
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeName), @"name");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeNameAsc), @"name");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeExpireTime), @"expireTime");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeExpireTimeAsc), @"expireTime");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeNickname), @"nickname");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeNicknameAsc), @"nickname");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeShareTraffic), @"shareTraffic");
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortTypeShareTrafficAsc), @"shareTraffic");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHShareSortTypeTransferToString((QCloudSMHShareSortType)999), @"expireTime");
}

#pragma mark - QCloudSMHApplySortTypeTransferToString Tests
- (void)testQCloudSMHApplySortTypeTransferToString {
    // 测试所有分支
    XCTAssertEqualObjects(QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortTypeCreationTime), @"creationTime");
    XCTAssertEqualObjects(QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortTypeCreationTimeAsc), @"creationTime");
    XCTAssertEqualObjects(QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortTypeOperationTime), @"operationTime");
    XCTAssertEqualObjects(QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortTypeOperationTimeAsc), @"operationTime");
    
    // 测试默认情况
    XCTAssertEqualObjects(QCloudSMHApplySortTypeTransferToString((QCloudSMHApplySortType)999), @"creationTime");
}


#pragma mark - QCloudSMHSearchTypeByTransferToString Tests
- (void)testAllSearchTypeConversions {
    // 验证所有明确定义的枚举值
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeAll), @"all");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeDir), @"dir");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeFile), @"file");
    
    // 文档类型
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeDoc), @"doc");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeXls), @"xls");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypePpt), @"ppt");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeTxt), @"txt");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypePdf), @"pdf");
    
    // 媒体类型
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeVideo), @"video");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeAudio), @"audio");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeImage), @"image");
    
    // 特定应用格式
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypePowerPoint), @"powerpoint");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeExcel), @"excel");
    XCTAssertEqualObjects(QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchTypeWord), @"word");
    
    // 边界测试：未定义的枚举值
    XCTAssertNil(QCloudSMHSearchTypeByTransferToString((QCloudSMHSearchType)999));
    XCTAssertNil(QCloudSMHSearchTypeByTransferToString(-1));
}

#pragma mark - QCloudSMHSearchByTypeByTransferToString Tests
- (void)testSearchByTypeConversions {
    // 明确定义的枚举值
    XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(QCloudSMHSearchSearchByFileName), @"fileName");
    XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(QCloudSMHSearchSearchByFileContents), @"fileContents");
    
    // 默认分支验证
    XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(QCloudSMHSearchSearchByAll), @"all");
    
    // 边界测试：未定义的枚举值
    XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString((QCloudSMHSearchSearchByType)999), @"all");
    XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(-5), @"all");
    
    // 验证所有分支覆盖
    for (int i = 0; i <= 2; i++) {
        QCloudSMHSearchSearchByType type = (QCloudSMHSearchSearchByType)i;
        switch (type) {
            case QCloudSMHSearchSearchByFileName:
                XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(type), @"fileName");
                break;
            case QCloudSMHSearchSearchByFileContents:
                XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(type), @"fileContents");
                break;
            default:
                XCTAssertEqualObjects(QCloudSMHSearchByTypeByTransferToString(type), @"all");
                break;
        }
    }
}


#pragma mark - ActionDetailType 测试
- (void)testActionDetailTypeConversion {
    // 测试单个标志位
    QCloudSMHDynamicActionDetailType type = QCloudSMHDynamicActionDetailDownload;
    NSArray *result = QCloudSMHDynamicActionDetailTypeTransferToString(type);
    XCTAssertEqualObjects(result, @[@"download"]);
    
    // 测试组合标志位
    type = QCloudSMHDynamicActionDetailDownload | QCloudSMHDynamicActionDetailDelete | QCloudSMHDynamicActionDetailRestore;
    result = QCloudSMHDynamicActionDetailTypeTransferToString(type);
    XCTAssertTrue([result containsObject:@"download"]);
    XCTAssertTrue([result containsObject:@"delete"]);
    XCTAssertTrue([result containsObject:@"restore"]);
    
    // 测试全量组合
    type = QCloudSMHDynamicActionDetailDownload | QCloudSMHDynamicActionDetailPreview | QCloudSMHDynamicActionDetailDelete |
    QCloudSMHDynamicActionDetailMove | QCloudSMHDynamicActionDetailRename | QCloudSMHDynamicActionDetailCopy |
    QCloudSMHDynamicActionDetailCreate | QCloudSMHDynamicActionDetailUpdate | QCloudSMHDynamicActionDetailRestore;
    result = QCloudSMHDynamicActionDetailTypeTransferToString(type);
    XCTAssertEqual(result.count, 9);
    
    // 测试空值
    XCTAssertEqualObjects(QCloudSMHDynamicActionDetailTypeTransferToString(0), @[]);
}

- (void)testActionDetailFromString {
    // 正向测试
    XCTAssertEqual(QCloudSMHDynamicActionDetailTypeFromString(@"download"), QCloudSMHDynamicActionDetailDownload);
    XCTAssertEqual(QCloudSMHDynamicActionDetailTypeFromString(@"restore"), QCloudSMHDynamicActionDetailRestore);
    
    // 边界测试
    XCTAssertEqual(QCloudSMHDynamicActionDetailTypeFromString(nil), QCloudSMHDynamicActionDetailDownload); // null安全
    XCTAssertEqual(QCloudSMHDynamicActionDetailTypeFromString(@"invalid"), QCloudSMHDynamicActionDetailDownload);
    XCTAssertEqual(QCloudSMHDynamicActionDetailTypeFromString(@"DOWNLOAD"), QCloudSMHDynamicActionDetailDownload); // 大小写敏感测试
}

#pragma mark - LogType 测试
- (void)testLogTypeConversion {
    // 正向测试
    XCTAssertEqualObjects(QCloudSMHDDynamicLogTypeTransferToString(QCloudSMHDynamicLogAPI), @"api");
    XCTAssertEqualObjects(QCloudSMHDDynamicLogTypeTransferToString(QCloudSMHDynamicLogUser), @"user");
    
    // 默认值测试
    XCTAssertEqualObjects(QCloudSMHDDynamicLogTypeTransferToString((QCloudSMHDynamicLogType)99), @"");
    
    // 逆向测试
    XCTAssertEqual(QCloudSMHDDynamicLogTypeFromString(@"api"), QCloudSMHDynamicLogAPI);
    XCTAssertEqual(QCloudSMHDDynamicLogTypeFromString(@"user"), QCloudSMHDynamicLogUser);
    XCTAssertEqual(QCloudSMHDDynamicLogTypeFromString(@"invalid"), QCloudSMHDynamicLogAPI); // 默认值
}

#pragma mark - ActionType 测试
- (void)testActionTypeConversion {
    // 测试所有定义的类型
    NSDictionary *testCases = @{
        @"Login": @(QCloudSMHDynamicTypeLogin),
        @"UserManagement": @(QCloudSMHDynamicTypeUserManagement),
        @"TeamManagement": @(QCloudSMHDynamicTypeTeamManagement),
        @"ShareManagement": @(QCloudSMHDynamicTypeShareManagement),
        @"AuthorityAction": @(QCloudSMHDynamicTypeAuthorityAction),
        @"FileAction": @(QCloudSMHDynamicTypeFileAction),
        @"SyncAction": @(QCloudSMHDynamicTypeSyncAction)
    };
    
    [testCases enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL * _Nonnull stop) {
        // 正向转换
        QCloudSMHDynamicActionType type = (QCloudSMHDynamicActionType)value.integerValue;
        XCTAssertEqualObjects(QCloudSMHDDynamicActionTypeTransferToString(type), key);
        
        // 逆向转换
        XCTAssertEqual(QCloudSMHDDynamicActionTypeFromString(key), type);
    }];
    
    // 测试未定义类型
    XCTAssertEqualObjects(QCloudSMHDDynamicActionTypeTransferToString((QCloudSMHDynamicActionType)999), @"");
    XCTAssertEqual(QCloudSMHDDynamicActionTypeFromString(@"UndefinedAction"), QCloudSMHDynamicTypeLogin); // 默认值
}

#pragma mark - ObjectType 测试
- (void)testObjectTypeConversion {
    // 测试所有定义类型
    XCTAssertEqualObjects(QCloudSMHDDynamicObjectTypeTransferToString(QCloudSMHDynamicObjectTypeUser), @"user");
    XCTAssertEqualObjects(QCloudSMHDDynamicObjectTypeTransferToString(QCloudSMHDynamicObjectTypeTeam), @"team");
    XCTAssertEqualObjects(QCloudSMHDDynamicObjectTypeTransferToString(QCloudSMHDynamicObjectTypeOrganization), @"organization");
    
    // 逆向测试
    XCTAssertEqual(QCloudSMHDDynamicObjectTypeFromString(@"user"), QCloudSMHDynamicObjectTypeUser);
    XCTAssertEqual(QCloudSMHDDynamicObjectTypeFromString(@"team"), QCloudSMHDynamicObjectTypeTeam);
    XCTAssertEqual(QCloudSMHDDynamicObjectTypeFromString(@"organization"), QCloudSMHDynamicObjectTypeOrganization);
    
    // 测试边界条件
    XCTAssertEqualObjects(QCloudSMHDDynamicObjectTypeTransferToString((QCloudSMHDynamicObjectType)99), @"");
    XCTAssertEqual(QCloudSMHDDynamicObjectTypeFromString(@"invalid"), QCloudSMHDynamicObjectTypeUser); // 默认值
    XCTAssertEqual(QCloudSMHDDynamicObjectTypeFromString(nil), QCloudSMHDynamicObjectTypeUser); // null安全
}

#pragma mark - QCloudSMHContentInfoTypeDumpFromString 测试
- (void)testStringToEnumConversion {
    // 测试所有定义的映射关系
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"file"), QCloudSMHContentInfoTypeFile);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"dir"), QCloudSMHContentInfoTypeDir);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"word"), QCloudSMHContentInfoTypeWord);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"video"), QCloudSMHContentInfoTypeVideo);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"audio"), QCloudSMHContentInfoTypeAudio);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"portable"), QCloudSMHContentInfoTypePDF); // 特别注意这个特殊映射
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"powerpoint"), QCloudSMHContentInfoTypePPT);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"text"), QCloudSMHContentInfoTypeTXT);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"excel"), QCloudSMHContentInfoTypeExcel);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"archive"), QCloudSMHContentInfoTypeArchive);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"image"), QCloudSMHContentInfoTypeImage);
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"symlink"), QCloudSMHContentInfoTypeSymlink);

    // 测试边界条件
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(nil), QCloudSMHContentInfoTypeOther); // null安全
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@""), QCloudSMHContentInfoTypeOther); // 空字符串
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"File"), QCloudSMHContentInfoTypeOther); // 大小写敏感测试
    XCTAssertEqual(QCloudSMHContentInfoTypeDumpFromString(@"unknown_type"), QCloudSMHContentInfoTypeOther);
}

#pragma mark - QCloudSMHContentInfoTypeTransferToString 测试
- (void)testEnumToStringConversion {
    // 测试所有枚举值
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeFile), @"file");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeDir), @"dir");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeWord), @"word");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeVideo), @"video");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeAudio), @"audio");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypePDF), @"portable"); // 逆向映射验证
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypePPT), @"powerpoint");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeTXT), @"text");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeExcel), @"excel");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeArchive), @"archive");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeImage), @"image");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeSymlink), @"symlink");

    // 测试未定义枚举值
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString((QCloudSMHContentInfoType)999), @"other");
    XCTAssertEqualObjects(QCloudSMHContentInfoTypeTransferToString(-1), @"other");
}

#pragma mark - 双向转换一致性测试
- (void)testBidirectionalConsistency {
    // 验证所有定义的类型可以双向转换
    NSArray *testTypes = @[@"file", @"dir", @"word", @"video", @"audio", @"portable", @"powerpoint", @"text", @"excel", @"archive", @"image", @"symlink"];
    
    for (NSString *typeString in testTypes) {
        QCloudSMHContentInfoType type = QCloudSMHContentInfoTypeDumpFromString(typeString);
        NSString *convertedString = QCloudSMHContentInfoTypeTransferToString(type);
        XCTAssertEqualObjects(typeString, convertedString, @"双向转换不一致: %@ -> %ld -> %@", typeString, (long)type, convertedString);
    }
}

#pragma mark - 性能测试
- (void)testConversionPerformance {
    [self measureBlock:^{
        for (int i = 0; i < 1000; i++) {
            QCloudSMHContentInfoTypeDumpFromString(@"file");
            QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoTypeFile);
        }
    }];
}


#pragma mark - GroupRole 测试
- (void)testGroupRoleConversions {
    // 字符串转枚举
    XCTAssertEqual(QCloudSMHGroupRoleFromString(@"owner"), QCloudSMHGroupRoleOwner);
    XCTAssertEqual(QCloudSMHGroupRoleFromString(@"groupAdmin"), QCloudSMHGroupRoleAdmin);
    XCTAssertEqual(QCloudSMHGroupRoleFromString(@"user"), QCloudSMHGroupRoleUser);
    XCTAssertEqual(QCloudSMHGroupRoleFromString(@"invalid"), QCloudSMHGroupRoleAdmin); // 默认值
    
    // 枚举转字符串
    XCTAssertEqualObjects(QCloudSMHGroupRoleTransferToString(QCloudSMHGroupRoleOwner), @"owner");
    XCTAssertEqualObjects(QCloudSMHGroupRoleTransferToString(QCloudSMHGroupRoleAdmin), @"groupAdmin");
    XCTAssertEqualObjects(QCloudSMHGroupRoleTransferToString(QCloudSMHGroupRoleUser), @"user");
    XCTAssertEqualObjects(QCloudSMHGroupRoleTransferToString((QCloudSMHGroupRole)999), @"");
}

#pragma mark - OrganizationType 测试
- (void)testOrganizationTypeConversions {
    // 正向测试
    XCTAssertEqual(QCloudSMHOrganizationTypeFromString(@"personal"), QCloudSMHOrganizationTypePersonal);
    XCTAssertEqual(QCloudSMHOrganizationTypeFromString(@"team"), QCloudSMHOrganizationTypeTeam);
    XCTAssertEqual(QCloudSMHOrganizationTypeFromString(@"enterprise"), QCloudSMHOrganizationTypeEnterprise);
    
    // 逆向测试
    XCTAssertEqualObjects(QCloudSMHOrganizationTypeTransferToString(QCloudSMHOrganizationTypePersonal), @"personal");
    XCTAssertEqualObjects(QCloudSMHOrganizationTypeTransferToString(QCloudSMHOrganizationTypeTeam), @"team");
    XCTAssertEqualObjects(QCloudSMHOrganizationTypeTransferToString(QCloudSMHOrganizationTypeEnterprise), @"enterprise");
    
    // 边界测试
    XCTAssertEqual(QCloudSMHOrganizationTypeFromString(@"Company"), QCloudSMHOrganizationTypePersonal); // 默认值
    XCTAssertEqualObjects(QCloudSMHOrganizationTypeTransferToString((QCloudSMHOrganizationType)99), @"");
}

#pragma mark - OrgUserRole 测试
- (void)testOrgUserRoleConversions {
    NSDictionary *testCases = @{
        @"superAdmin": @(QCloudSMHOrgUserRoleSuperAdmin),
        @"admin": @(QCloudSMHOrgUserRoleAdmin),
        @"user": @(QCloudSMHOrgUserRoleUser)
    };
    
    [testCases enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL *stop) {
        XCTAssertEqual(QCloudSMHOrgUserRoleTypeFromString(key), value.integerValue);
        XCTAssertEqualObjects(QCloudSMHOrgUserRoleTypeTransferToString(value.integerValue), key);
    }];
    
    // 默认分支测试
    XCTAssertEqual(QCloudSMHOrgUserRoleTypeFromString(@"manager"), QCloudSMHOrgUserRoleOther);
    XCTAssertEqualObjects(QCloudSMHOrgUserRoleTypeTransferToString((QCloudSMHOrgUserRole)99), @"");
}

#pragma mark - LoginAuthType 测试
- (void)testLoginAuthTypeConversions {
    // 字符串转枚举
    XCTAssertEqual(QCloudSMHLoginAuthTypeFromString(@"web"), QCloudSMHLoginAuthWeb);
    XCTAssertEqual(QCloudSMHLoginAuthTypeFromString(@"mobile"), QCloudSMHLoginAuthMobile);
    XCTAssertEqual(QCloudSMHLoginAuthTypeFromString(@"desktop"), QCloudSMHLoginAuthOther);
    
    // 枚举转字符串
    XCTAssertEqualObjects(QCloudSMHLoginAuthTypeTransferToString(QCloudSMHLoginAuthWeb), @"web");
    XCTAssertEqualObjects(QCloudSMHLoginAuthTypeTransferToString(QCloudSMHLoginAuthMobile), @"mobile");
    XCTAssertEqualObjects(QCloudSMHLoginAuthTypeTransferToString(QCloudSMHLoginAuthOther), @"");
}

#pragma mark - PurposeType 测试
- (void)testPurposeTypeConversion {
    NSArray *expected = @[@"download", @"preview", @"list"];
    for (NSInteger i = 0; i < expected.count; i++) {
        QCloudSMHPurposeType type = (QCloudSMHPurposeType)i;
        XCTAssertEqualObjects(QCloudSMHPurposeTypeTransferToString(type), expected[i]);
    }
    XCTAssertEqualObjects(QCloudSMHPurposeTypeTransferToString((QCloudSMHPurposeType)99), @"");
}

#pragma mark - UsedSence 测试
- (void)testUsedSenceConversion {
    XCTAssertEqualObjects(QCloudSMHUsedSenceTransferToString(QCloudSMHUsedSencePersonal), @"personal_space");
    XCTAssertEqualObjects(QCloudSMHUsedSenceTransferToString(QCloudSMHUsedSenceTeam), @"team_space");
    XCTAssertEqualObjects(QCloudSMHUsedSenceTransferToString(QCloudSMHUsedSenceGroup), @"group_space");
    XCTAssertEqualObjects(QCloudSMHUsedSenceTransferToString((QCloudSMHUsedSence)99), @"");
}

#pragma mark - FileTemplate 测试
- (void)testFileTemplateConversion {
    XCTAssertEqualObjects(QCloudSMHFileTemplateTransferToString(QCloudSMHFileTemplateWord), @"word.docx");
    XCTAssertEqualObjects(QCloudSMHFileTemplateTransferToString(QCloudSMHFileTemplateExcel), @"excel.xlsx");
    XCTAssertEqualObjects(QCloudSMHFileTemplateTransferToString(QCloudSMHFileTemplatePPT), @"powerpoint.pptx");
    XCTAssertEqualObjects(QCloudSMHFileTemplateTransferToString((QCloudSMHFileTemplate)99), @"");
}

#pragma mark - ChannelFlag 测试
- (void)testChannelFlagConversions {
    // 字符串转枚举
    XCTAssertEqual(QCloudSMHChannelFlagFromString(@"meeting"), QCloudSMHChannelFlagMeeting);
    XCTAssertEqual(QCloudSMHChannelFlagFromString(@"hiflow"), QCloudSMHChannelFlagHiflow);
    XCTAssertEqual(QCloudSMHChannelFlagFromString(@"official-free"), QCloudSMHChannelFlagOfficialFree);
    XCTAssertEqual(QCloudSMHChannelFlagFromString(@"visitor"), QCloudSMHChannelFlagVisitor);
    XCTAssertEqual(QCloudSMHChannelFlagFromString(@"invalid"), QCloudSMHChannelFlagNone);
    
    // 枚举转字符串
    XCTAssertEqualObjects(QCloudSMHChannelFlagTransferToString(QCloudSMHChannelFlagMeeting), @"meeting");
    XCTAssertEqualObjects(QCloudSMHChannelFlagTransferToString(QCloudSMHChannelFlagHiflow), @"hiflow");
    XCTAssertEqualObjects(QCloudSMHChannelFlagTransferToString(QCloudSMHChannelFlagOfficialFree), @"official-free");
    XCTAssertEqualObjects(QCloudSMHChannelFlagTransferToString(QCloudSMHChannelFlagVisitor), @"visitor");
    XCTAssertEqualObjects(QCloudSMHChannelFlagTransferToString(QCloudSMHChannelFlagNone), @"");
}

#pragma mark - ShareFileType 测试
- (void)testShareFileTypeConversions {
    // 字符串转枚举
    XCTAssertEqual(QCloudSMHShareFileTypeFromString(@"multi-file"), QCloudSMHShareFileTypeMultiFile);
    XCTAssertEqual(QCloudSMHShareFileTypeFromString(@"file"), QCloudSMHShareFileTypeFile);
    XCTAssertEqual(QCloudSMHShareFileTypeFromString(@"dir"), QCloudSMHShareFileTypeDir);
    XCTAssertEqual(QCloudSMHShareFileTypeFromString(@"folder"), QCloudSMHShareFileTypeNone);
    
    // 枚举转字符串
    XCTAssertEqualObjects(QCloudSMHShareFileTypeTransferToString(QCloudSMHShareFileTypeMultiFile), @"multi-file");
    XCTAssertEqualObjects(QCloudSMHShareFileTypeTransferToString(QCloudSMHShareFileTypeFile), @"file");
    XCTAssertEqualObjects(QCloudSMHShareFileTypeTransferToString(QCloudSMHShareFileTypeDir), @"dir");
    XCTAssertEqualObjects(QCloudSMHShareFileTypeTransferToString(QCloudSMHShareFileTypeNone), @"");
}

#pragma mark - AppleType 测试
- (void)testAppleTypeConversion {
    XCTAssertEqualObjects(QCloudSMHAppleTypeTransferToString(QCloudSMHAppleTypeMyApply), @"my_apply");
    XCTAssertEqualObjects(QCloudSMHAppleTypeTransferToString(QCloudSMHAppleTypeMyAudit), @"my_audit");
    XCTAssertEqualObjects(QCloudSMHAppleTypeTransferToString((QCloudSMHAppleType)99), @"");
}

#pragma mark - AppleStatusType 测试
- (void)testAppleStatusTypeConversion {
    XCTAssertEqualObjects(QCloudSMHAppleStatusTypeTransferToString(QCloudSMHAppleStatusTypeAuditing), @"auditing");
    XCTAssertEqualObjects(QCloudSMHAppleStatusTypeTransferToString(QCloudSMHAppleStatusTypeHistory), @"history");
    XCTAssertEqualObjects(QCloudSMHAppleStatusTypeTransferToString((QCloudSMHAppleStatusType)99), @"");
}

#pragma mark - DirectoryFilter 测试
- (void)testDirectoryFilterConversion {
    XCTAssertEqualObjects(QCloudSMHDirectoryFilterTransferToString(QCloudSMHDirectoryOnlyDir), @"onlyDir");
    XCTAssertEqualObjects(QCloudSMHDirectoryFilterTransferToString(QCloudSMHDirectoryOnlyFile), @"onlyFile");
}

#pragma mark - SearchMode 测试
- (void)testSearchModeConversion {
    XCTAssertEqualObjects(QCloudSMHSearchModeTransferToString(QCloudSMHSearchModeFast), @"fast");
    XCTAssertEqualObjects(QCloudSMHSearchModeTransferToString(QCloudSMHSearchModeNormal), @"normal");
    XCTAssertEqualObjects(QCloudSMHSearchModeTransferToString((QCloudSMHSearchMode)99), @"normal");
}

#pragma mark - String to Enum 测试
- (void)testValidStringToEnumConversion {
    // 测试所有有效字符串映射
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"personal"), QCloudSpaceTag_Personal);
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"team"), QCloudSpaceTag_Team);
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"group"), QCloudSpaceTag_Group);
}

- (void)testInvalidStringToEnumConversion {
    // 测试无效字符串返回 None
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"invalid"), QCloudSpaceTag_None);
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"PERSONAL"), QCloudSpaceTag_None); // 大小写敏感测试
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@"teams"), QCloudSpaceTag_None);
}

- (void)testEdgeCaseStringInputs {
    // 测试边界输入
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(nil), QCloudSpaceTag_None); // null安全
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString(@""), QCloudSpaceTag_None); // 空字符串
    XCTAssertEqual(QCloudSMHQCloudSpaceTagFromString((id)[NSNull null]), QCloudSpaceTag_None); // 非字符串类型
}

#pragma mark - Enum to String 测试
- (void)testValidEnumToStringConversion {
    // 测试所有有效枚举值
    XCTAssertEqualObjects(QCloudSMHQCloudSpaceTagTransferToString(QCloudSpaceTag_Personal), @"personal");
    XCTAssertEqualObjects(QCloudSMHQCloudSpaceTagTransferToString(QCloudSpaceTag_Team), @"team");
    XCTAssertEqualObjects(QCloudSMHQCloudSpaceTagTransferToString(QCloudSpaceTag_Group), @"group");
    XCTAssertEqualObjects(QCloudSMHQCloudSpaceTagTransferToString(QCloudSpaceTag_None), @"");
}

#pragma mark - 双向转换一致性测试
- (void)testSpaceTypeBidirectionalConsistency {
    NSArray *validStrings = @[@"personal", @"team", @"group"];
    
    [validStrings enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        QCloudSpaceTagEnum enumValue = QCloudSMHQCloudSpaceTagFromString(str);
        NSString *convertedString = QCloudSMHQCloudSpaceTagTransferToString(enumValue);
        XCTAssertEqualObjects(str, convertedString, @"双向转换不一致: %@ -> %ld -> %@", str, (long)enumValue, convertedString);
    }];
}

#pragma mark - 有效状态码测试
- (void)testValidStatusCodeConversion {
    // 测试所有定义的状态码转换
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(202), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(200), QCloudSMHBatchTaskStatusSucceed);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(204), QCloudSMHBatchTaskStatusSucceed);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(207), QCloudSMHBatchTaskStatusFaliure);
}

#pragma mark - 无效状态码测试
- (void)testInvalidStatusCodeConversion {
    // 测试未定义状态码返回默认值
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(0), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(201), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(203), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(205), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(300), QCloudSMHBatchTaskStatusWating);
}

#pragma mark - 边界值测试
- (void)testBoundaryValues {
    // 测试数值边界情况
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(NSIntegerMin), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(NSIntegerMax), QCloudSMHBatchTaskStatusWating);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(-1), QCloudSMHBatchTaskStatusWating);
}

#pragma mark - 多值映射验证
- (void)testMultiCodeMapping {
    // 验证多个状态码映射到同一个枚举值
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(200), QCloudSMHBatchTaskStatusSucceed);
    XCTAssertEqual(QCloudSMHBatchTaskStatusTypeFromStatus(204), QCloudSMHBatchTaskStatusSucceed);
}

#pragma mark - 有效枚举值映射测试
- (void)testValidEnumMappings {
    // 给定-当-则模式验证标准映射关系
    XCTAssertEqualObjects(QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnumRename), @"rename");
    XCTAssertEqualObjects(QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnumAsk), @"ask");
    XCTAssertEqualObjects(QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnumOverWrite), @"overwrite");
}

#pragma mark - 字符串精确性验证
- (void)testStringAccuracy {
    // 重点检查易错拼写
    XCTAssertEqualObjects(QCloudSMHConflictStrategyByTransferToString(QCloudSMHConflictStrategyEnumOverWrite), @"overwrite");
}

#pragma mark - 参数化测试模板
- (void)testParameterized {
    // 使用数据驱动提高测试覆盖率
    NSDictionary *testCases = @{
        @(QCloudSMHConflictStrategyEnumRename): @"rename",
        @(QCloudSMHConflictStrategyEnumAsk): @"ask",
        @(QCloudSMHConflictStrategyEnumOverWrite): @"overwrite",
        @(-1): @"rename",
        @(3): @"rename",
        @(INT_MAX): @"rename"
    };
    
    [testCases enumerateKeysAndObjectsUsingBlock:^(NSNumber *input, NSString *expected, BOOL *stop) {
        NSString *result = QCloudSMHConflictStrategyByTransferToString(input.integerValue);
        XCTAssertEqualObjects(result, expected, @"输入 %@ 时转换失败", input);
    }];
}


- (void)testUserBase {
    QCloudSMHUserBizRequest * request = [QCloudSMHUserBizRequest new];
    NSError * error;
    
    [request buildRequestData:&error];
    
    [request buildURLRequest:&error];
    
    [request prepareInvokeURLRequest:nil error:nil];
}

-(void)testQCloudSMHAccessTokenFenceQueue{
    QCloudSMHAccessTokenFenceQueue * queue = QCloudSMHAccessTokenFenceQueue.new;
    QCloudSMHPutTagRequest * request = [QCloudSMHPutTagRequest new];
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceIdV2;
    request.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    queue.delegate = self;
    [queue performRequest:request withAction:^(QCloudSMHSpaceInfo * _Nonnull spaceInfo, NSError * _Nonnull error) {
       
    }];
    [queue cleanAllAccesstoken];
}

- (void)fenceQueue:(QCloudSMHAccessTokenFenceQueue *)queue request:(QCloudSMHBizRequest *)request requestCreatorWithContinue:(QCloudAccessTokenFenceQueueContinue)continueBlock{
    
    QCloudSMHSpaceInfo * spaceinfo = [QCloudSMHSpaceInfo new];
    spaceinfo.accessToken = QCloudSMHTestTools.singleTool.getAccessTokenV2;
    spaceinfo.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    spaceinfo.spaceId =QCloudSMHTestTools.singleTool.getSpaceIdV2;
    continueBlock(spaceinfo,nil);
}

- (void)testQCloudSMHBatchBaseRequest {
    QCloudSMHBatchBaseRequest * requset = [QCloudSMHBatchBaseRequest new];
    requset.libraryId = QCloudSMHTestTools.singleTool.getLibraryIdV2;
    requset.spaceId =QCloudSMHTestTools.singleTool.getSpaceIdV2;
    requset.taskId = @"test";
    [requset startAsyncTask];
}

- (void)testRequestBuild {
    QCloudSMHGetRecentlyUsedFileRequest * request = [QCloudSMHGetRecentlyUsedFileRequest new];
    request.limit = 1;
    request.marker = @"maker";
    request.filterActionBy = @"preview";
    NSError * error;
    
    QCloudSMHGetRecycleObjectListReqeust * request1 = [QCloudSMHGetRecycleObjectListReqeust new];
    request1.marker = @"maker";
    request1.page = 1;
    request1.pageSize = 10;
    request1.sortType = QCloudSMHSortTypeName;
    [request1 buildURLRequest:&error];
    
    request1.sortType = QCloudSMHSortTypeCTimeReverse;
    [request1 buildURLRequest:&error];
    
    request1.sortType = QCloudSMHSortTypeCTime;
    [request1 buildURLRequest:&error];
    
    request1.sortType = QCloudSMHSortTypeNameReverse;
    [request1 buildURLRequest:&error];
    
    QCloudSMHExitFileAuthorizeRequest * request2 = [QCloudSMHExitFileAuthorizeRequest new];
    request2.dirPath = @"test";
    [request2 buildURLRequest:&error];
    
    QCloudSMHPostAuthorizeRequest * request3 = [QCloudSMHPostAuthorizeRequest new];
    [request3 buildURLRequest:&error];
    QCloudSMHSelectRoleInfo * role = [[QCloudSMHSelectRoleInfo alloc]init];
    role.type = QCloudSMHRoleMember;
    role.name = @"test";
    
    QCloudSMHSelectRoleInfo * role1 = [[QCloudSMHSelectRoleInfo alloc]init];
    role1.type = QCloudSMHRoleGrop;
    role1.name = @"test";
    request3.selectRoles = @[role,role1];
    [request3 buildURLRequest:&error];
    
    
    QCloudSMHGetFileListByTagsRequest * request4 = [QCloudSMHGetFileListByTagsRequest new];
    [request4 buildURLRequest:&error];
    QCloudFileQueryTagModel * tag = [QCloudFileQueryTagModel new];
    tag.tagId = @"1";
    tag.tagValue = @"value";

    request4.tagList = @[tag];
    [request4 buildURLRequest:&error];
    
    QCloudSMHPostAuthorizeRequest * request5 = [QCloudSMHPostAuthorizeRequest new];
    [request5 buildURLRequest:&error];
    QCloudSMHSelectRoleInfo * role2 = [[QCloudSMHSelectRoleInfo alloc]init];
    role2.type = QCloudSMHRoleMember;
    role2.name = @"test";
    
    QCloudSMHSelectRoleInfo * role3 = [[QCloudSMHSelectRoleInfo alloc]init];
    role3.type = QCloudSMHRoleGrop;
    role3.name = @"test";
    request5.selectRoles = @[role2,role3];
    [request5 buildURLRequest:&error];
    
    QCloudSMHListContentsRequest * request6 = [QCloudSMHListContentsRequest new];
    request6.limit = 100;
    request6.marker = @"maker";
    request6.page = 1;
    request6.pageSize = 100;
    request6.sortType = QCloudSMHSortTypeName;
    
    [request6 buildURLRequest:&error];
    request6.sortType = QCloudSMHSortTypeNameReverse;
    
    request6.accessToken = @"accessToken";
    [request6 buildURLRequest:&error];
    
    request6.headerIfNoneMatch = @"accessToken";
    [request6 buildURLRequest:&error];
    
    
    QCloudSMHCompleteUploadRequest * request7 = [QCloudSMHCompleteUploadRequest new];
    [request7 buildURLRequest:&error];
    [request7 setCustomHeaders:@{@"test":@"test"}.mutableCopy];
    request7.crc64 = @"crc64";
    request7.labels = @[@"labels"];
    request7.category = @"category";
    request7.localCreationTime = @"category";
    request7.localModificationTime = @"category";
    [request7 buildURLRequest:&error];
    
    QCloudSMHUploadPartRequest * requset8 = [QCloudSMHUploadPartRequest new];
    [requset8 buildURLRequest:&error];
    requset8.filePath = @"test.jpg";
    [requset8 buildURLRequest:&error];
    requset8.partNumberRange = @"1000";
    [requset8 buildURLRequest:&error];
    requset8.fileSize = @"1000";
    requset8.fullHash = @"test";
    requset8.labels = @[@"labels"];
    requset8.category = @"category";
    requset8.localCreationTime = @"category";
    requset8.localModificationTime = @"category";
    [requset8 buildURLRequest:&error];
    
    QCloudSMHPutObjectRequest * requset9 = [QCloudSMHPutObjectRequest new];
    [requset9 buildURLRequest:&error];
    requset9.filePath = @"test.jpg";
    [requset9 buildURLRequest:&error];
    [requset9 buildURLRequest:&error];
    requset9.fileSize = @"1000";
    requset9.fullHash = @"test";
    requset9.labels = @[@"labels"];
    requset9.category = @"category";
    requset9.localCreationTime = @"category";
    requset9.localModificationTime = @"category";
    [requset9 buildURLRequest:&error];
    
    QCloudSMHPutFileTagRequest * requset10 = [QCloudSMHPutFileTagRequest new];
    [requset10 buildURLRequest:&error];
    requset10.tags  =@[@"test"];
    [requset10 buildURLRequest:&error];
    
    QCloudSMHResumeSearchRequest * requset11 = [QCloudSMHResumeSearchRequest new];
    requset11.searchId = @"test";
    requset11.nextMarker = @"nextMarker";
    requset11.withInode = YES;
    requset11.withFavoriteStatus = YES;
    [requset11 buildURLRequest:&error];
    
    QCloudSMHInitiateSearchRequest * requset12 = [QCloudSMHInitiateSearchRequest new];
    requset12.extname = @[@"jpg"];
    QCloudSMHSearchTag * tag1 = [QCloudSMHSearchTag new];
    tag1.tagId = @"test";
    requset12.searchTags = @[tag1];
    requset12.maxFileSize = 100;
    requset12.minFileSize = 100;
    requset12.modificationTimeStart = @"test";
    requset12.modificationTimeEnd = @"test";
    requset12.withInode = YES;
    requset12.withFavoriteStatus = YES;
    requset12.creators = @[[QCloudSMHSearchCreator new]];
    requset12.categories = @[@"test"];
    requset12.labels = @[@"test"];
    [requset12 buildURLRequest:&error];
    
    QCloudSMHAbortMultipfartUploadRequest * requset13 = [QCloudSMHAbortMultipfartUploadRequest new];
    requset13.confirmKey = @"test";
    [requset13 buildURLRequest:&error];
    
    QCloudSMHCrossSpaceCopyDirectoryRequest * requset14 = [QCloudSMHCrossSpaceCopyDirectoryRequest new];
    [requset14 buildURLRequest:&error];
    requset14.from = @"test";
    [requset14 buildURLRequest:&error];
    requset14.fromSpaceId = @"test";
    [requset14 buildURLRequest:&error];
    
    
    QCloudSMHGetUploadStateRequest * requset15 = [QCloudSMHGetUploadStateRequest new];
    [requset15 buildURLRequest:&error];
    requset15.confirmKey = @"test";
    [requset15 buildURLRequest:&error];
    requset15.customHeaders = @{@"test":@"test"}.mutableCopy;
    [requset15 buildURLRequest:&error];
    
    
    QCloudGetFileThumbnailRequest * requset16 = [QCloudGetFileThumbnailRequest new];
    [requset16 buildURLRequest:&error];
    requset16.filePath = @"test";
    [requset16 buildURLRequest:&error];
    requset16.historyId = 1;
    [requset16 buildURLRequest:&error];
    
    QCloudSMHDeleteFileTagRequest * requset17 = [QCloudSMHDeleteFileTagRequest new];
    [requset17 buildURLRequest:&error];
    requset17.fileTagId = @"test";
    [requset17 buildURLRequest:&error];
 
    QCloudSMHDeleteTagRequest *requset18 = [QCloudSMHDeleteTagRequest new];
    [requset18 buildURLRequest:&error];
    requset18.tagId = @"test";
    [requset18 buildURLRequest:&error];
    
    QCloudSMHPutObjectRenewRequest * requset19 = [QCloudSMHPutObjectRenewRequest new];
    [requset19 buildURLRequest:&error];
    requset19.confirmKey = @"test";
    [requset19 buildURLRequest:&error];
    requset19.customHeaders = @{@"test":@"test"}.mutableCopy;
    [requset19 buildURLRequest:&error];
    
    QCloudSMHAbortSearchRequest * request20 = [QCloudSMHAbortSearchRequest new];
    [request20 buildURLRequest:&error];
    
    QCloudSMHGetSpaceHomeFileRequest * request21 = [QCloudSMHGetSpaceHomeFileRequest new];
    request21.limit = 10;
    request21.marker = @"maker";
    request21.sortType = QCloudSMHSortTypeName;
    [request21 buildURLRequest:&error];
    request21.sortType = QCloudSMHSortTypeNameReverse;
    [request21 buildURLRequest:&error];
    request21.category = @"test";
    request21.withPath = YES;
    [request21 buildURLRequest:&error];
    
    QCloudSMHGetDownloadInfoRequest * request22 = [QCloudSMHGetDownloadInfoRequest new];
    [request22 buildURLRequest:&error];
    
    QCloudSMHBatchDeleteRecycleObjectReqeust * request23 = [QCloudSMHBatchDeleteRecycleObjectReqeust new];
    [request23 buildURLRequest:&error];
    
    
    
    QCloudSMHGetMyAuthorizedDirectoryRequest * request24 = [QCloudSMHGetMyAuthorizedDirectoryRequest new];
    request24.limit = 10;
    request24.marker = @"maker";
    request24.sortType = QCloudSMHSortTypeName;
    [request24 buildURLRequest:&error];
    request24.sortType = QCloudSMHSortTypeNameReverse;
    [request24 buildURLRequest:&error];
    
    QCloudSMHDeleteRecycleObjectReqeust * request25 = [QCloudSMHDeleteRecycleObjectReqeust new];
    [request25 buildURLRequest:&error];
    request25.recycledItemId = 10;
    [request25 buildURLRequest:&error];
    
}

- (void)testModelBuild {
    QCloudSMHTaskResult * result = [QCloudSMHTaskResult new];
    [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"status":@200}];
    [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    
    QCloudSMHBatchResult * result1 = [QCloudSMHBatchResult new];
    [result1 performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"status":@200}];
    [result1 performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    
    QCloudSMHCopyResult * result2 = [QCloudSMHCopyResult new];
    [result2 performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"result":@{@"status":@200,@"path":@"path"}}];
    [result2 performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    
    
    QCloudSMHFileInputInfo * info = [QCloudSMHFileInputInfo new];
    [info performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
    [info performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"isDirectory":@(YES)}.mutableCopy];
    
    [QCloudSMHListFileInfo performSelector:@selector(modelContainerPropertyGenericClass)];
}
@end
