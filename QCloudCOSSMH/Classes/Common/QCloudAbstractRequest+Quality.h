//
//  QCloudAbstractRequest+Quality.h
//  Pods
//
//  Created by garenwang on 2021/9/29.
//

#import "QCloudAbstractRequest.h"

NS_ASSUME_NONNULL_BEGIN

// 公共参数
extern NSString * const kSMHQCloudQualityOrganizationIdKey;
extern NSString * const kSMHQCloudQualityUserIdKey;
extern NSString * const kSMHQCloudQualitySmhsdkVersionKey;
extern NSString * const kSMHQCloudQualitySmhsdkVersionCodeKey;
extern NSString * const kSMHQCloudQualityPlatformKey;
extern NSString * const kSMHQCloudQualityNetworkTypeKey;
extern NSString * const kSMHQCloudQualityBoundleIdKey;
extern NSString * const kSMHQCloudQualityClientIpKey;

extern NSString * const kSMHQCloudQualityspaceIdKey;
extern NSString * const kSMHQCloudQualitysmhKeyKey;
extern NSString * const kSMHQCloudQualitylocalPathKey;
extern NSString * const kSMHQCloudQualityerrorCodeKey;
extern NSString * const kSMHQCloudQualityerrorMessageKey;
extern NSString * const kSMHQCloudQualityfileSizeKey;
extern NSString * const kSMHQCloudQualityuploadSizeKey;
extern NSString * const kSMHQCloudQualitydownloadSizeKey;
extern NSString * const kSMHQCloudQualityconsumeTimeKey;
extern NSString * const kSMHQCloudQualityrequestIdKey;
extern NSString * const kSMHQCloudQualityrequestNameKey;

@interface QCloudAbstractRequest (Quality)

- (void)__quality__notifyError:(NSError *)error;

- (void)__quality__notifySuccess:(id)object;

@end

NS_ASSUME_NONNULL_END
