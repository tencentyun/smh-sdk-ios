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
-(NSString *)getLibrarySecretV1;

-(NSString *)getUserIdV2;
- (NSString *)getBaseUrlStrV2;
-(NSString *)getAccessTokenV2;
-(NSString *)getSpaceIdV2;
-(NSString *)getLibraryIdV2;
-(NSString *)getLibrarySecretV2;
+ (NSString *)tempFileWithSize:(int)size;

/// 生成随机大小的临时文件，基于时间戳生成随机 size（范围：minSize ~ maxSize 字节）
+ (NSString *)tempFileWithRandomSizeFrom:(int)minSize to:(int)maxSize;
@end

NS_ASSUME_NONNULL_END
