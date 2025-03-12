//
//  QCloudSMHDemo00UserTests.m
//  QCloudSMHDemo00UserTests
//
//  Created by garenwang on 2022/5/11.
//

#import <XCTest/XCTest.h>
#import "QCloudSMHTestTools.h"
#import "QCloudCOSSMH.h"
#import "NSObject+HTTPHeadersContainer.h"
@interface QCloudSMHDemo00UserTests : XCTestCase

@end

@implementation QCloudSMHDemo00UserTests

- (void)setUp {
    [QCloudSMHBaseRequest setBaseRequestHost:@"https://apiv2.test.tencentsmh.cn/" targetType:QCloudECDTargetTest];
    [QCloudSMHBaseRequest setBaseRequestHost:@"https://apiv2.test.tencentsmh.cn/" targetType:QCloudECDTargetDevelop];
    [QCloudSMHBaseRequest setTargetType:QCloudECDTargetDevelop];
}

- (void)test01GetVerificationCode {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetVerificationCode"];
    
    QCloudSMHSendSMSCodeRequest *request = [QCloudSMHSendSMSCodeRequest new];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.countryCode = [QCloudSMHTestTools getTestCountryCode];
    request.phone = [QCloudSMHTestTools getTestPhone];

    [request setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        if ([error.userInfo[@"code"]isEqualToString:@"SmsFrequencyLimit"]) {
            [expectation fulfill];
        }else{
            XCTAssertNil(error);
            [expectation fulfill];
        }
    }];

    [[QCloudSMHUserService defaultSMHUserService] sendSMHCode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test02VerifySMSCode{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testVerifySMSCode"];
    QCloudSMHVerifySMSCodeRequest *request = [QCloudSMHVerifySMSCodeRequest new];
    request.priority = QCloudAbstractRequestPriorityHigh;
    NSString *deviceId = [UIDevice currentDevice].name;
    request.deviceID = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    request.code = QCloudSMHTestTools.getTestDefautlVerificationCode;;
    request.countryCode = QCloudSMHTestTools.getTestCountryCode;
    request.phone = QCloudSMHTestTools.getTestPhone;

    [request setFinishBlock:^(QCloudSMHOrganizationsInfo *_Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(outputObject.userToken);
        XCTAssertTrue(outputObject.organizations.count > 0);
        QCloudSMHTestTools.singleTool.organizationsInfo = outputObject;
        [expectation fulfill];
    }];

    [[QCloudSMHUserService defaultSMHUserService] verifySMSCode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test03GetAccessToken{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetAccessToken"];
    QCloudSMHLoginOrganizationRequest *request = [[QCloudSMHLoginOrganizationRequest alloc] init];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        QCloudSMHGetAccessTokenRequest *getAccessToken = [QCloudSMHGetAccessTokenRequest new];
        getAccessToken.priority = QCloudAbstractRequestPriorityHigh;
        getAccessToken.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        getAccessToken.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(outputObject.accessToken);
            XCTAssertNotNil(outputObject.spaceId);
            QCloudSMHTestTools.singleTool.spaceInfo = outputObject;
            [expectation fulfill];
        }];
        [[QCloudSMHUserService defaultSMHUserService] getAccessToken:getAccessToken];
    }];
    [[QCloudSMHUserService defaultSMHUserService] loginToOrganization:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test04GetUserInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test04GetUserInfo"];
    QCloudSMHGetUserInfoRequest *updateInfo = [[QCloudSMHGetUserInfoRequest alloc] init];
    updateInfo.priority = QCloudAbstractRequestPriorityHigh;
    updateInfo.userId = QCloudSMHTestTools.singleTool.getUserId;
    updateInfo.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    updateInfo.organizationId =  QCloudSMHTestTools.singleTool.getOrgnizationId;
    updateInfo.finishBlock = ^(QCloudSMHUserDetailInfo *outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertTrue([outputObject.phoneNumber isEqualToString:QCloudSMHTestTools.getTestPhone]);
        QCloudSMHTestTools.singleTool.userInfo = outputObject;
        [expectation fulfill];
    };
    [[QCloudSMHUserService defaultSMHUserService] getUserInfo:updateInfo];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)test04GetUserList{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test04GetUserList"];
    QCloudSMHGetUserListRequest *updateInfo = [[QCloudSMHGetUserListRequest alloc] init];
    updateInfo.priority = QCloudAbstractRequestPriorityHigh;
    updateInfo.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    updateInfo.organizationId =  QCloudSMHTestTools.singleTool.getOrgnizationId;
    [updateInfo setFinishBlock:^(QCloudSMHTeamContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
        }];
    
    [[QCloudSMHUserService defaultSMHUserService] getUserList:updateInfo];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)test05GetOrganizationInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test05GetOrganizationInfo"];
    QCloudSMHGetOrganizationInfoRequest *request = [[QCloudSMHGetOrganizationInfoRequest alloc] init];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHOrganizationDetailInfo * _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(outputObject.name);
        XCTAssertNotNil(outputObject.extensionData);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getOrganizationInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetOrganizationList{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetOrganizationList"];
    QCloudSMHGetOrganizationRequest *request = [[QCloudSMHGetOrganizationRequest alloc] init];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [request setFinishBlock:^(NSArray <QCloudSMHOrganizationInfo *> * _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue(outputObject.count > 0);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getOrganizationList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetSpaceInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetSpaceInfo"];
    QCloudSMHGetSpacesRequest *request = [[QCloudSMHGetSpacesRequest alloc] init];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;;
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHSpacesSizeInfo * _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getTeamInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetOrgSpaceInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetOrgSpaceInfo"];
    QCloudSMHGetOrgSpacesRequest *request = [[QCloudSMHGetOrgSpacesRequest alloc] init];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;;
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHOrgSpacesSizeInfo * _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getOrgSpaceSizeInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testExchangePhone{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExchangePhone"];
    QCloudSMHGetUpdatePhoneCodeRequest *request = [QCloudSMHGetUpdatePhoneCodeRequest new];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.countryCode = QCloudSMHTestTools.getTestCountryCode;
    request.phone = QCloudSMHTestTools.getTestPhone;
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [request setFinishBlock:^(QCloudSMHNewPhoneInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([@"DuplicateUserPhoneNumber" isEqualToString:error.userInfo[@"code"]]);
        [expectation fulfill];
    }];

    [[QCloudSMHUserService defaultSMHUserService] getVCodeByUpdatePhone:request];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testGetTeamList {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExchangePhone"];
    QCloudSMHGetTeamRequest *request = [[QCloudSMHGetTeamRequest alloc] init];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.withPath = YES;
    [request setFinishBlock:^(QCloudSMHTeamInfo *outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        if (outputObject.teamId) {
            QCloudSMHGetTeamDetailRequest *request = [[QCloudSMHGetTeamDetailRequest alloc] init];
            request.priority = QCloudAbstractRequestPriorityHigh;
            request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
            request.teamId = outputObject.teamId;
            request.withPath = YES;
            request.WithRecursiveUserCount = YES;
            request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
            [request setFinishBlock:^(QCloudSMHTeamInfo *_Nullable result, NSError *_Nullable error1) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);
                [expectation fulfill];
            }];
            [[QCloudSMHUserService defaultSMHUserService] getTeamDetail:request];
        }else{
            [expectation fulfill];
        }
    }];
    [[QCloudSMHUserService defaultSMHUserService] getTeam:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testShareFileLinkList {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testShareFileLinkList"];
    QCloudSMHGetListFileShareLinkRequest *req = [QCloudSMHGetListFileShareLinkRequest new];
    
    req.page = 0;
    req.pageSize = 200;
    req.sortType = QCloudSMHSortTypeNameReverse;
    req.userToken =  QCloudSMHTestTools.singleTool.getUserToken;;
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [req setFinishBlock:^(QCloudFileListContent *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        XCTAssertTrue([result isKindOfClass:[QCloudFileListContent class]]);
        
        QCloudSMHGeFileShareLinkDetailRequest  * request = [[QCloudSMHGeFileShareLinkDetailRequest alloc]init];
        request.priority = QCloudAbstractRequestPriorityHigh;
        request.shareId = @"3184";
        request.userToken =  QCloudSMHTestTools.singleTool.getUserToken;;
        request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        
        request.finishBlock = ^(id outputObject, NSError *error) {
            [expectation fulfill];
        };
        [[QCloudSMHUserService defaultSMHUserService] getShareLinkDetail:request];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getListShareLink:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetAuthorizedToMeDirectory{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetAuthorizedToMeDirectory"];
    QCloudSMHGetAuthorizedToMeDirectoryRequest *req = [QCloudSMHGetAuthorizedToMeDirectoryRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.limit = 200;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHContentListInfo *_Nullable result, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getAuthorizedToMeDirectory:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetRecentlyFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetRecentlyFile"];
    QCloudSMHRecentlyFileRequest *req = [QCloudSMHRecentlyFileRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.page = 0;
    req.pageSize = 100;
    req.sortType = QCloudSMHSortTypeName;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHRecentlyFileListInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getRecentlyFiles:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
//这个？https://api.dev.tencentsmh.cn/user/v1/group/5/list?check_update_recursively=1&order_by=creationTime&order_by_type=desc&page=1&page_size=50&user_token=c5d0c8161adf20b337b9cb224a94eb8c0dc9b20d70927d251517d08798ca95822fc94a1834b05865e438ff2ec2df2cd1c875fcfa21c09d64cce11274f04e9551&with_directory=1&with_file_count=1&with_users=1 }
-(void)testListGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListGroup"];
    QCloudSMHListGroupRequest *request = [QCloudSMHListGroupRequest new];
    request.page = 1;
    request.pageSize = 20;
    request.withFileCount = YES;
    request.withDirectory = YES;
    request.checkUpdateRecursively = YES;
    request.withUser = YES;
    request.userToken = @"c5d0c8161adf20b337b9cb224a94eb8c0dc9b20d70927d251517d08798ca95822fc94a1834b05865e438ff2ec2df2cd1c875fcfa21c09d64cce11274f04e9551";//QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = @"5"; //QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHListGroupInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] listGroup:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

-(void)testRelatedToMeFile{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRelatedToMeFile"];
    QCloudSMHRelatedToMeFileRequest *req = [QCloudSMHRelatedToMeFileRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.page = 0;
    req.pageSize = 100;
    req.sortType = QCloudSMHSortTypeName;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHRecentlyFileListInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getRelatedToMeFile:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testCreateInviteOrgCode{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCreateInviteOrgCode"];
    QCloudSMHCreateInviteOrgCodeRequest *req = [QCloudSMHCreateInviteOrgCodeRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.role = QCloudSMHGroupRoleAdmin;
    
    [req setFinishBlock:^(QCloudSMHCodeResult * _Nullable result, NSError * _Nullable error) {

        QCloudSMHGetOrgInviteCodeRequest * req1 = [QCloudSMHGetOrgInviteCodeRequest new];
        req1.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        req1.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        
        [req1 setFinishBlock:^(QCloudSMHCodeResult * _Nullable result3, NSError * _Nullable error3) {
            XCTAssertNil(error3);
            XCTAssertNotNil(result3);
            
            QCloudSMHGetOrgInviteCodeInfoRequest *req2 = [QCloudSMHGetOrgInviteCodeInfoRequest new];
            req2.code = result3.code;
            [req2 setFinishBlock:^(QCloudSMHInviteOrgCodeInfoModel * _Nullable result1, NSError * _Nullable error1) {
                XCTAssertNil(error1);
                XCTAssertNotNil(result1);
                QCloudSMHDeleteInviteRequest * deleteReq = [QCloudSMHDeleteInviteRequest new];
                deleteReq.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
                deleteReq.userToken = QCloudSMHTestTools.singleTool.getUserToken;
                deleteReq.code = result3.code;
                [deleteReq setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error2) {

                    XCTAssertNil(error2);
                    XCTAssertNotNil(outputObject);

                    [expectation fulfill];
                }];
                [[QCloudSMHUserService defaultSMHUserService] deleteInvite:deleteReq];
                
            }];
            [[QCloudSMHUserService defaultSMHUserService] getOrgInviteCodeInfo:req2];
            
            
          
        }];
        [[QCloudSMHUserService defaultSMHUserService] getOrgInviteCode:req1];
        
        
    }];
    [[QCloudSMHUserService defaultSMHUserService] createInviteOrgCode:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testCreateInviteGroupCode{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCreateInviteGroupCode"];
    QCloudSMHCreateInviteGroupCodeRequest *req = [QCloudSMHCreateInviteGroupCodeRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"1332";
    req.authRoleId = @"2";
    req.allowExternalUser = @(YES);
    
    [req setFinishBlock:^(QCloudSMHCodeResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        
        QCloudSMHGetGroupInviteCodeRequest * req1 = [QCloudSMHGetGroupInviteCodeRequest new];
        req1.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        req1.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        req1.groupId = @"1332";
        
        [req1 setFinishBlock:^(QCloudSMHCodeResult * _Nullable result3, NSError * _Nullable error3) {
            XCTAssertNil(error3);
            XCTAssertNotNil(result3);
            
            QCloudSMHGetGroupInviteCodeInfoRequest *req2 = [QCloudSMHGetGroupInviteCodeInfoRequest new];
            req2.code = result3.code;
            [req2 setFinishBlock:^(QCloudSMHInviteGroupCodeInfoModel * _Nullable result1, NSError * _Nullable error1) {
                XCTAssertNil(error1);
                XCTAssertNotNil(result1);
                QCloudSMHDeleteInviteRequest * deleteReq = [QCloudSMHDeleteInviteRequest new];
                deleteReq.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
                deleteReq.userToken = QCloudSMHTestTools.singleTool.getUserToken;
                deleteReq.code = result3.code;
                [deleteReq setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error2) {

                    XCTAssertNil(error2);
                    XCTAssertNotNil(outputObject);

                    [expectation fulfill];
                }];
                [[QCloudSMHUserService defaultSMHUserService] deleteInvite:deleteReq];
                
            }];
            [[QCloudSMHUserService defaultSMHUserService] getGroupInviteCodeInfo:req2];
            
            
          
        }];
        [[QCloudSMHUserService defaultSMHUserService] getGroupInviteCode:req1];

    }];
    [[QCloudSMHUserService defaultSMHUserService] createInviteGroupCode:req];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testJoinGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testJoinGroup"];
    QCloudSMHJoinGroupRequest *req = [QCloudSMHJoinGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.code = @"-1";
    [req setFinishBlock:^(QCloudSMHJoinResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvitationCodeInvalidOrExpired"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] joinGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testJoinOrg{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testJoinOrg"];
    QCloudSMHJoinOrgRequest *req = [QCloudSMHJoinOrgRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.code = @"-1";
    [req setFinishBlock:^(QCloudSMHJoinResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvitationCodeInvalidOrExpired"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] joinOrg:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testUpdateOrgInviteInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateOrgInviteInfo"];
    QCloudSMHUpdateOrgInviteInfoRequest *req = [QCloudSMHUpdateOrgInviteInfoRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.code = @"***";
    req.role = QCloudSMHGroupRoleUser;
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvitationNotExist"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] updateOrgInviteInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testUpdateGroupInviteInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateGroupInviteInfo"];
    QCloudSMHUpdateGroupInviteInfoRequest *req = [QCloudSMHUpdateGroupInviteInfoRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.code = @"***";
    req.allowExternalUser = @(YES);
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvitationNotExist"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] updateGroupInviteInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testCreateGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCreateGroup"];
    QCloudSMHCreateGroupRequest *req = [QCloudSMHCreateGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.name = @"testGroup";
    QCloudSMHCreateGroupItem * user1 = [[QCloudSMHCreateGroupItem alloc]init];
    user1.userId = @"1";
    user1.role = QCloudSMHGroupRoleUser;
    user1.authRoleId = @"2";
    
    QCloudSMHCreateGroupItem * user2 = [[QCloudSMHCreateGroupItem alloc]init];
    user2.userId = @"2";
    user2.role = QCloudSMHGroupRoleUser;
    user2.authRoleId = @"2";
    
    req.users = @[user1,user2];
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(QCloudSMHCreateGroupResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] putCreateGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testAddMemberToGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testAddMemberToGroup"];
    QCloudSMHAddMemberToGroupRequest *req = [QCloudSMHAddMemberToGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"***";
    QCloudSMHCreateGroupItem * user1 = [[QCloudSMHCreateGroupItem alloc]init];
    user1.userId = @"1";
    user1.role = QCloudSMHGroupRoleUser;
    user1.authRoleId = @"2";
    
    QCloudSMHCreateGroupItem * user2 = [[QCloudSMHCreateGroupItem alloc]init];
    user2.userId = @"2";
    user2.role = QCloudSMHGroupRoleUser;
    user2.authRoleId = @"2";
    
    req.users = @[user1,user2];
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] addMemberToGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testDeleteMember{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testAddMemberToGroup"];
    QCloudSMHDeleteGroupMemberRequest *req = [QCloudSMHDeleteGroupMemberRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"***";
    QCloudSMHCreateGroupItem * user1 = [[QCloudSMHCreateGroupItem alloc]init];
    user1.userId = @"1";
    user1.role = QCloudSMHGroupRoleUser;
    user1.authRoleId = @"2";
    
    QCloudSMHCreateGroupItem * user2 = [[QCloudSMHCreateGroupItem alloc]init];
    user2.userId = @"2";
    user2.role = QCloudSMHGroupRoleUser;
    user2.authRoleId = @"2";
    
    req.users = @[user1,user2];
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] deleteGroupMember:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testDeleteGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteGroup"];
    QCloudSMHDeleteGroupRequest *req = [QCloudSMHDeleteGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"***";
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] deleteGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testDeregister{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeregister"];
    QCloudSMHDeregisterRequest * req = [QCloudSMHDeregisterRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"DeregisterNotAllowedForSuperAdmin"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] exitOrganization:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testCheckDeregister{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCheckDeregister"];
    QCloudSMHCheckDeregisterRequest * req = [QCloudSMHCheckDeregisterRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] checkDeregister:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testExitGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testExitGroup"];
    QCloudSMHExitGroupRequest *req = [QCloudSMHExitGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"***";
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] exitGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetCreateGroupCount{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetCreateGroupCount"];
    QCloudSMHGetCreateGroupCountRequest *req = [QCloudSMHGetCreateGroupCountRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.userIds = @[@"0"];
    [req setFinishBlock:^(NSArray<QCloudSMHCreateGroupCountResult *> * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvalidUserId"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getCreateGroupCount:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetGroup"];
    QCloudSMHGetGroupRequest *req = [QCloudSMHGetGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"0";
    [req setFinishBlock:^(QCloudSMHGroupInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testListGroupMember{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListGroupMember"];
    QCloudSMHListGroupMemberRequest *req = [QCloudSMHListGroupMemberRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"0";
    [req setFinishBlock:^(QCloudSMHListGroupMemberInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"NoPermission"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] listGroupMember:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testUpdateGroupMemberRole{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateGroupMemberRole"];
    QCloudSMHUpdateGroupMemberRoleRequest *req = [QCloudSMHUpdateGroupMemberRoleRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"0";
    
    QCloudSMHCreateGroupItem * user1 = [[QCloudSMHCreateGroupItem alloc]init];
    user1.userId = @"1";
    user1.role = QCloudSMHGroupRoleUser;
    user1.authRoleId = @"4";
    
    QCloudSMHCreateGroupItem * user2 = [[QCloudSMHCreateGroupItem alloc]init];
    user2.userId = @"2";
    user2.role = QCloudSMHGroupRoleAdmin;
    user2.authRoleId = @"4";
    
    req.users = @[user2];
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] updateGroupMemberRole:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testUpdateGroup{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateGroup"];
    QCloudSMHUpdateGroupRequest *req = [QCloudSMHUpdateGroupRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.groupId = @"-1";
    
    req.groupName = @"测试一下";
    
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] updateGroup:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testListSpaceDynamic{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListSpaceDynamic"];
    QCloudSMHListSpaceDynamicRequest *req = [QCloudSMHListSpaceDynamicRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    req.actionTypeDetail = QCloudSMHDynamicActionDetailCopy | QCloudSMHDynamicActionDetailMove;
    [req setFinishBlock:^(QCloudSMHSpaceDynamicList * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        QCloudSMHNextListSpaceDynamicRequest * req1 = [QCloudSMHNextListSpaceDynamicRequest new];
        req1.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
        req1.userToken = QCloudSMHTestTools.singleTool.getUserToken;
        req1.searchId = result.searchId;
        req1.marker = result.nextMarker;
        [req1 setFinishBlock:^(QCloudSMHSpaceDynamicList * _Nullable result1, NSError * _Nullable error1) {
            XCTAssertNil(error1);
            [expectation fulfill];
        }];
        [[QCloudSMHUserService defaultSMHUserService] nextListSpaceDynamic:req1];
        
    }];
    [[QCloudSMHUserService defaultSMHUserService] listSpaceDynamic:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testListDetailInfo{
    
    QCloudSMHFileInputInfo * info = [QCloudSMHFileInputInfo new];
    info.path = @"*";
    info.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    info.isDirectory = NO;
       
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListDetailInfo"];
    QCloudSMHBatchMultiSpaceFileInfoRequest *req = [QCloudSMHBatchMultiSpaceFileInfoRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.infos = @[info];
    
    [req setFinishBlock:^(QCloudSMHListFileInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] batchMultiSpaceFileInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testListWorkBenchDynamic{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testListSpaceDynamic"];
    QCloudSMHListWorkBenchDynamicRequest *req = [QCloudSMHListWorkBenchDynamicRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.actionTypeDetail = QCloudSMHDynamicActionDetailCopy | QCloudSMHDynamicActionDetailMove;
    [req setFinishBlock:^(QCloudSMHWorkBenchDynamicList * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
        
    }];
    [[QCloudSMHUserService defaultSMHUserService] listWorkBenchDynamic:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testWXLogin{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testWXLogin"];
    QCloudSMHWXLoginRequest *req = [QCloudSMHWXLoginRequest new];
    req.code = @"code";
    req.phoneNumber = @"18888888888";
    req.countryCode = @"+86";
    req.deviceId = @"iphone";
    req.smsCode = @"21941";
    [req setFinishBlock:^(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"WechatOauthFailed"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] wxLogin:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testBindWX{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testWXLogin"];
    QCloudSMHBindWXRequest *req = [QCloudSMHBindWXRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.authCode = @"test";
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"WechatOauthFailed"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] bindWX:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testUnbindWX{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testWXLogin"];
    QCloudSMHUnbindWXRequest *req = [QCloudSMHUnbindWXRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    [req setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] unbindWX:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetExtraInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetExtraInfo"];
    QCloudSMHFileExtraReqInfo * info = [QCloudSMHFileExtraReqInfo new];
    info.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    info.path = @"*";
    
    QCloudGetFileExtraInfoRequest * req = [QCloudGetFileExtraInfoRequest new];
    req.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.fileInfos = @[info];
    [req setFinishBlock:^(NSArray<QCloudSMHFileExtraInfo *> * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getFileExtraInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testUploadUserInfo{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetExtraInfo"];
    
    QCloudSMHUploadPersonalInfoRequest * req = [QCloudSMHUploadPersonalInfoRequest new];
    req.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    req.model = @"model";
    req.system = @"ios";
    req.idfv = @"idfv";
    [req setFinishBlock:^(QCloudSMHUploadPersonalInfoResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] uploadPersonalInfo:req];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testStoreCodeDetail{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testStoreCodeDetail"];
    QCloudSMHGetStoreCodeDetailRequest *request = [QCloudSMHGetStoreCodeDetailRequest new];
    request.priority = QCloudAbstractRequestPriorityHigh;
    request.code = @"-1";
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;

    [request setFinishBlock:^(QCloudStoreDetailInfo *_Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ParamInvalid"]);
        [expectation fulfill];
    }];

    [[QCloudSMHUserService defaultSMHUserService] getStoreCodeDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testGetRecycleList{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetRecycleList"];
    QCloudSMHGetRecycleListRequest *request = [QCloudSMHGetRecycleListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    
    QCloudSMHSpaceItem * item = [QCloudSMHSpaceItem new];
    item.spaceId =  QCloudSMHTestTools.singleTool.getSpaceId;
    item.includeChildSpace = YES;
    
    request.spaceItems = @[item];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getRecycleList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testRestoreCrossSpaceObject{
    
    QCloudSMHBatchInputRecycleInfo * info1 = [QCloudSMHBatchInputRecycleInfo new];
    info1.spaceId =  QCloudSMHTestTools.singleTool.getSpaceId;
    info1.recycledItemId = -1;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteCrossSpaceObject"];
    QCloudSMHRestoreCrossSpaceObjectRequest *request = [QCloudSMHRestoreCrossSpaceObjectRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.batchInfos = @[info1];
    [request setFinishBlock:^(QCloudSMHBatchResult * _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([outputObject.result.firstObject.message isEqualToString:@"Recycled item not found."]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] restoreCrossSpaceObject:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

-(void)testDeleteSpaceRecycleObject{
    
    QCloudSMHBatchInputRecycleInfo * info1 = [QCloudSMHBatchInputRecycleInfo new];
    info1.spaceId =  QCloudSMHTestTools.singleTool.getSpaceId;
    info1.recycledItemId = -1;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteSpaceRecycleObject"];
    QCloudSMHBatchDeleteSpaceRecycleObjectReqeust *request = [QCloudSMHBatchDeleteSpaceRecycleObjectReqeust new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.recycledItems = @[info1];
    [request setFinishBlock:^(QCloudSMHBatchResult *  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] batchDeleteCrossSpaceRecycleObject:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

-(void)testQCloudSMHCancelLoginQrcodeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteSpaceRecycleObject"];
    QCloudSMHCancelLoginQrcodeRequest * request = [QCloudSMHCancelLoginQrcodeRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.code = @"***";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] cancelLoginQrcode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHVerifyYufuCodeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHVerifyYufuCodeRequest"];
    QCloudSMHVerifyYufuCodeRequest * request = [QCloudSMHVerifyYufuCodeRequest new];
    request.tenantName = @"**";
    request.code = @"-1";
    request.type = QCloudSMHYufuLoginDomain;
    [request setFinishBlock:^(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"YufuConfigNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] verifyYufuCode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetYufuLoginAddressRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetYufuLoginAddressRequest"];
    QCloudSMHGetYufuLoginAddressRequest * request = [QCloudSMHGetYufuLoginAddressRequest new];
//    request.tenantName = @"**";
    request.domain = @"**";
    request.type = QCloudSMHYufuLoginDomain;
    [request setFinishBlock:^(NSString * _Nullable location, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"YufuConfigNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getYufuLoginAddress:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHClearMessageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHClearMessageRequest"];
    QCloudSMHClearMessageRequest * request = [QCloudSMHClearMessageRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.messageType = 0;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] clearMessage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHCompleteUploadAvatarRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCompleteUploadAvatarRequest"];
    QCloudSMHCompleteUploadAvatarRequest * request = [QCloudSMHCompleteUploadAvatarRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.filePath = @"";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"InvalidFilePath"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] completeUploadAvatar:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHGetMessageListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetMessageListRequest"];
    QCloudSMHGetMessageListRequest * request = [QCloudSMHGetMessageListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHMesssageListResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getMessageList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteMessageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteMessageRequest"];
    QCloudSMHDeleteMessageRequest * request = [QCloudSMHDeleteMessageRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.messageId = @"186277";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] deleteMessage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetTeamAllMemberDetailRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetTeamAllMemberDetailRequest"];
    QCloudSMHGetTeamAllMemberDetailRequest * request = [QCloudSMHGetTeamAllMemberDetailRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
//    request.teamId = @"-1";
    [request setFinishBlock:^(QCloudSMHTeamContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"OrganizationTeamNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getTeamAllMemberDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetTeamMemberDetailRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetTeamMemberDetailRequest"];
    QCloudSMHGetTeamMemberDetailRequest * request = [QCloudSMHGetTeamMemberDetailRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.teamId = @"-1";
    [request setFinishBlock:^(QCloudSMHTeamContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"OrganizationTeamNotFound"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getTeamMemberDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHSearchTeamDetailRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHSearchTeamDetailRequest"];
    QCloudSMHSearchTeamDetailRequest * request = [QCloudSMHSearchTeamDetailRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHSearchTeamInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getSearchTeamDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudUpdateFavoriteGroupRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateFavoriteGroupRequest"];
    QCloudUpdateFavoriteGroupRequest * request = [QCloudUpdateFavoriteGroupRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.tag = @"1";
    request.name = @"test";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] updateFavoriteGroup:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHListHistoryVersionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHListHistoryVersionRequest"];
    QCloudSMHAPIListHistoryVersionRequest * request = [QCloudSMHAPIListHistoryVersionRequest new];
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.spaceOrgId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.filePath = @"test.jpg";
    [request setFinishBlock:^(QCloudSMHListHistoryVersionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"FileNotFound"]);
        [expectation fulfill];
    }];
    
    [[QCloudSMHService defaultSMHService] listHistoryVersion:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetFileInfoRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetFileInfoRequest"];
    QCloudSMHGetFileInfoRequest * request = [QCloudSMHGetFileInfoRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.spaceOrgId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.dirPath = @"test.jpg";
    [request setFinishBlock:^(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getFileInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetAuthorizedRelatedToMeDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetAuthorizedRelatedToMeDirectoryRequest"];
    QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest * request = [QCloudSMHGetAuthorizedRelatedToMeDirectoryRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHContentListInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getAuthorizedRelatedToMeDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHFavoriteFileRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHFavoriteFileRequest"];
    QCloudSMHFavoriteFileRequest * request = [QCloudSMHFavoriteFileRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.spaceOrgId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.path = @"***";
    [request setFinishBlock:^(QCloudSMHFavoriteInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] favoriteFile:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDisableFileShareLinkRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDisableFileShareLinkRequest"];
    QCloudSMHDisableFileShareLinkRequest * request = [QCloudSMHDisableFileShareLinkRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.shareId = @"-1";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"ShareInfoNotFound"]);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] disableFileShareLink:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteFileShareRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteFileShareRequest"];
    QCloudSMHDeleteFileShareRequest * request = [QCloudSMHDeleteFileShareRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.shareIds = @[@"-1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] deleteShareFileLink:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHDeleteFavoriteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDeleteFavoriteRequest"];
    QCloudSMHDeleteFavoriteRequest * request = [QCloudSMHDeleteFavoriteRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.favoriteIds = @[@"-1"];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
    
        XCTAssertNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] deleteFavoriteFiles:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetMessageSettingRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetMessageSettingRequest"];
    QCloudSMHGetMessageSettingRequest * request = [QCloudSMHGetMessageSettingRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    
    [request setFinishBlock:^(QCloudSMHMessageSetting * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] getMessageSetting:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHUpdateMessageSettingRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHUpdateMessageSettingRequest"];
    QCloudSMHUpdateMessageSettingRequest * request = [QCloudSMHUpdateMessageSettingRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.forbidCancelled = YES;
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] updateMessageSetting:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
//#import "QCloudSMHGetVirusDetectionListRequest.h"
//#import "QCloudSMHVirusDetectionRestoreRequest.h"

-(void)testQCloudSMHGetVirusDetectionListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetVirusDetectionListRequest"];
    QCloudSMHGetVirusDetectionListRequest * request = [QCloudSMHGetVirusDetectionListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    
    request.page = 1;
    request.pageSize = 10;
    request.sortType = QCloudSMHSortTypeName;
    
    QCloudSMHListVirusDetectionInput * input = QCloudSMHListVirusDetectionInput.new;
    input.spaceId = @"space1d18pweh1rw2u";
    input.includeChildSpace = true;
    
    QCloudSMHListVirusDetectionInput * input1 = QCloudSMHListVirusDetectionInput.new;
    input1.spaceId = @"space3gqa7zjbohz4t";
    input1.includeChildSpace = false;
    
    QCloudSMHListVirusDetectionInput * input2 = QCloudSMHListVirusDetectionInput.new;
    input2.spaceId = @"space26b0t8a7lerg9";
    input2.includeChildSpace = false;
    
    QCloudSMHListVirusDetectionInput * input3 = QCloudSMHListVirusDetectionInput.new;
    input3.spaceId = @"space2ht86mr74nxj8";
    input3.includeChildSpace = false;
    
    QCloudSMHListVirusDetectionInput * input4 = QCloudSMHListVirusDetectionInput.new;
    input4.spaceId = @"space0wr0vfjctmfw1";
    input4.includeChildSpace = false;
    
    request.spaceItems = @[input,input1,input2,input3,input4];
    [request setFinishBlock:^(QCloudVirusDetectionFileList * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getVirusDetectionList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHVirusDetectionRestoreRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHVirusDetectionRestoreRequest"];
    QCloudSMHVirusDetectionRestoreRequest * request = [QCloudSMHVirusDetectionRestoreRequest  new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    QCloudSMHVirusDetectionInput * input = [QCloudSMHVirusDetectionInput new];
    input.path = @[@"esign测试",@"hei", @"测试杀毒" ,@"e8a1475945135b2d79b5aabaab78c0da"];
    input.spaceId = @"space01jxhp6uunwu8";
    request.restoreItems = @[input];

    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] virusDetectionRestore:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];    
}

-(void)testQCloudSMHGetOrgRoleListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetOrgRoleListRequest"];
    QCloudSMHGetOrgRoleListRequest * request = [QCloudSMHGetOrgRoleListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(NSArray<QCloudSMHRoleInfo *> * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getOrgRoleList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHAbortSearchTeamRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHAbortSearchTeamRequest"];
    QCloudSMHAbortSearchTeamRequest * request = [QCloudSMHAbortSearchTeamRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.searchId = @"FmdCM0lwN25KUmJpYmFzcVpxV1pxR1EhVFZaYmdvc2hTbUtYb180NnBzY3gyQToyNzAyMjM4NDU2";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] abortSearchTeam:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHNextSearchTeamRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHNextSearchTeamRequest"];
    QCloudSMHNextSearchTeamRequest * request = [QCloudSMHNextSearchTeamRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.marker = @"10";
    request.searchId = @"FmdCM0lwN25KUmJpYmFzcVpxV1pxR1EhVFZaYmdvc2hTbUtYb180NnBzY3gyQToyNzAyMjM4NDU2";
    [request setFinishBlock:^(QCloudSMHSearchTeamResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] nextSearchTeam:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHBeginSearchTeamRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHBeginSearchTeamRequest"];
    QCloudSMHBeginSearchTeamRequest * request = [QCloudSMHBeginSearchTeamRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.keyword = @"1";
    [request setFinishBlock:^(QCloudSMHSearchTeamResult * _Nullable result, NSError * _Nullable error) {
            [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] beginSearchTeam:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetTemporaryUserRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetTemporaryUserRequest"];
    QCloudSMHGetTemporaryUserRequest * request = [QCloudSMHGetTemporaryUserRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.page = 1;
    request.pageSize = 20;
    [request setFinishBlock:^(QCloudSMHTemporaryUserResult * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
    [[QCloudSMHUserService defaultSMHUserService] getTemporaryUser:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHUserInitiateSearchRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHUserInitiateSearchRequest"];
    QCloudSMHUserInitiateSearchRequest * request = [QCloudSMHUserInitiateSearchRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.keyword = @"1";
    [request setFinishBlock:^(QCloudSMHSearchListInfo * _Nullable result, NSError * _Nullable error) {
            [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] initiateSearch:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHGetOrganizationShareListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetOrganizationShareListRequest"];
    QCloudSMHGetOrganizationShareListRequest * request = [QCloudSMHGetOrganizationShareListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    [request setFinishBlock:^(QCloudSMHOrganizationShareList * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getOrganizationShareList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetApplyDirectoryDetailRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetApplyDirectoryDetailRequest"];
    QCloudSMHGetApplyDirectoryDetailRequest * request = [QCloudSMHGetApplyDirectoryDetailRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.applyNo = @"fdildrov";
    [request setFinishBlock:^(QCloudSMHApplyDircetoryDetailInfo * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getApplyDirectoryDetail:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHDisagreeApplyDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHDisagreeApplyDirectoryRequest"];
    QCloudSMHDisagreeApplyDirectoryRequest * request = [QCloudSMHDisagreeApplyDirectoryRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.applyNo = @"fdildrov";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] disagreeApplyDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHCancelApplyDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHCancelApplyDirectoryRequest"];
    QCloudSMHCancelApplyDirectoryRequest * request = [QCloudSMHCancelApplyDirectoryRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.applyNo = @"fdildrov";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] cancelApplyDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetApplyDirectoryListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetApplyDirectoryListRequest"];
    QCloudSMHGetApplyDirectoryListRequest * request = [QCloudSMHGetApplyDirectoryListRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.type = QCloudSMHAppleTypeMyAudit;
    [request setFinishBlock:^(QCloudSMHListAppleDirectoryResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] getApplyDirectoryList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHAgreeApplyDirectoryRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHAgreeApplyDirectoryRequest"];
    QCloudSMHAgreeApplyDirectoryRequest * request = [QCloudSMHAgreeApplyDirectoryRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.applyNo = @"fdildrov";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] agreeApplyDirectory:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHApplyDirectoryAuthorityRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHApplyDirectoryAuthorityRequest"];
    QCloudSMHApplyDirectoryAuthorityRequest * request = [QCloudSMHApplyDirectoryAuthorityRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.title = @"test";
    request.reason = @"reason";
    request.spaceId = QCloudSMHTestTools.singleTool.getSpaceId;
    request.pathList = @[@"test"];
    request.roleId = @"1";
    [request setFinishBlock:^(QCloudSMHAppleDirectoryResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] applyDirectoryAuthority:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHCheckDirectoryApplyRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHCheckDirectoryApplyRequest"];
    QCloudSMHCheckDirectoryApplyRequest * request = [QCloudSMHCheckDirectoryApplyRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.spaceId =  QCloudSMHTestTools.singleTool.getSpaceId;
    request.pathList = @[@"test"];
    [request setFinishBlock:^(NSArray <QCloudSMHCheckDirectoryApplyItem *> * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] checkDirectoryApply:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHGetApplyDirectoryListTotalInfoRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHGetApplyDirectoryListTotalInfoRequest"];
    QCloudSMHGetApplyDirectoryListTotalInfoRequest * request = [QCloudSMHGetApplyDirectoryListTotalInfoRequest new];
    request.userToken = QCloudSMHTestTools.singleTool.getUserToken;
    request.organizationId = QCloudSMHTestTools.singleTool.getOrgnizationId;
    request.type = QCloudSMHAppleTypeMyAudit;
    [request setFinishBlock:^(QCloudSMHListAppleDirectoryTotalInfoResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] getApplyDirectoryListTotalInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}
-(void)testQCloudSMHSSOLoginRedirectRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudSMHSSOLoginRedirectRequest"];
    QCloudSMHSSOLoginRedirectRequest * request = [QCloudSMHSSOLoginRedirectRequest new];
    request.autoRedirect = YES;
    request.domain = @"zubrbtyb";
    [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [[QCloudSMHUserService defaultSMHUserService] ssoLoginRedirect:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudSMHVerifyAccountLoginRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSMHVerifyAccountLoginRequest"];
    QCloudSMHVerifyAccountLoginRequest *req = [QCloudSMHVerifyAccountLoginRequest new];
    req.phoneNumber = @"18888888888";
    req.countryCode = @"+86";
    req.domain = @"zubrbtyb";
    req.deviceId = @"iphone";
    req.smsCode = @"21941";
    req.credential = @"7963d775739d40a4a38b246213ceea30";
    [req setFinishBlock:^(QCloudSMHOrganizationsInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertTrue([error.userInfo[@"code"] isEqualToString:@"WechatOauthFailed"]);
        [expectation fulfill];
    }];
    [[QCloudSMHUserService defaultSMHUserService] verifyAccountLogin:req];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

@end

