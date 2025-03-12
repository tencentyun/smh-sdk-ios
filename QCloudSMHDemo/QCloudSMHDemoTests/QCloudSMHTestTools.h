//
//  QCloudSMHTestTools.h
//  QCloudSMHDemoTests
//
//  Created by garenwang on 2022/5/11.
//

#import <Foundation/Foundation.h>
#import "QCloudCOSSMH.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHTestTools : NSObject

@property (nonatomic,strong)QCloudSMHOrganizationsInfo * organizationsInfo;

@property (nonatomic,strong)QCloudSMHSpaceInfo *spaceInfo;

@property (nonatomic,strong)QCloudSMHUserDetailInfo * userInfo;

+(instancetype)singleTool;
+(NSString *)getTestPhone;
+(NSString *)getTestDefautlVerificationCode;
+(NSString *)getTestCountryCode;
-(NSString *)getUserToken;
-(NSString *)getLibraryId;
-(NSString *)getOrgnizationId;
-(NSString *)getAccessToken;
-(NSString *)getUserId;
-(NSString *)getSpaceId;
+ (NSString *)tempFileWithSize:(int)size;
@end

NS_ASSUME_NONNULL_END
