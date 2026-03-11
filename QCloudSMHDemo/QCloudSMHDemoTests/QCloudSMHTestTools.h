//
//  QCloudSMHTestTools.h
//  QCloudSMHDemoTests
//
//  Created by garenwang on 2022/5/11.
//

#import <Foundation/Foundation.h>
#import "QCloudCOSSMHApi.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHTestTools : NSObject

//@property (nonatomic,strong)QCloudSMHOrganizationsInfo * organizationsInfo;

@property (nonatomic,strong)QCloudSMHSpaceInfo *spaceInfo;

//@property (nonatomic,strong)QCloudSMHUserDetailInfo * userInfo;

+(instancetype)singleTool;
+(NSString *)getTestPhone;
+(NSString *)getTestDefautlVerificationCode;
+(NSString *)getTestCountryCode;
-(NSString *)getUserToken;
-(NSString *)getOrgnizationId;

-(NSString *)getUserIdV1;
- (NSString *)getBaseUrlStrV1;
-(NSString *)getAccessTokenV1;
-(NSString *)getSpaceIdV1;
-(NSString *)getLibraryIdV1;

-(NSString *)getUserIdV2;
- (NSString *)getBaseUrlStrV2;
-(NSString *)getAccessTokenV2;
-(NSString *)getSpaceIdV2;
-(NSString *)getLibraryIdV2;
+ (NSString *)tempFileWithSize:(int)size;
@end

NS_ASSUME_NONNULL_END
