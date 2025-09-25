//
//  QCloudAbstractRequest+Quality.m
//  Pods
//
//  Created by garenwang on 2021/9/29.
//

#import "QCloudAbstractRequest+Quality.h"
#import <objc/runtime.h>
#import <QCloudCore/QualityDataUploader.h>
#import "QCloudCOSSMHVersion.h"
#import "QCloudSMHBizRequest.h"
#import "QCloudSMHUserBizRequest.h"
#import "QCloudCOSSMHConfig.h"

NSString *const kSMHQCloudUploadAppReleaseKey = @"0DOU06CCWK49FGC7";

#pragma mark -commen key
NSString * const kSMHQCloudQualityOrganizationIdKey = @"organization_id";
NSString * const kSMHQCloudQualityUserIdKey = @"user_id";

NSString * const kSMHQCloudQualityspaceIdKey = @"space_id";
NSString * const kSMHQCloudQualitysmhKeyKey = @"smh_key";
NSString * const kSMHQCloudQualitylocalPathKey = @"local_path";
NSString * const kSMHQCloudQualityfileSizeKey = @"file_size";
NSString * const kSMHQCloudQualityuploadSizeKey = @"upload_size";
NSString * const kSMHQCloudQualitydownloadSizeKey = @"download_size";
NSString * const kSMHQCloudQualityrequestNameKey = @"request_name";

@implementation QCloudAbstractRequest (Quality)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeImplementation];
    });
}

- (instancetype)__quality__init{
    [self startBeacon];
    return [self __quality__init];
}

+ (void)exchangeImplementation {
    Class class = [self class];
    Method originNotifyErrorMethod = class_getInstanceMethod(class, NSSelectorFromString(@"__notifyError:"));
    Method swizzedNotifyErrorMethod = class_getInstanceMethod(class, @selector(__quality__notifyError:));
    Method originNotifySuccessMethod = class_getInstanceMethod(class, NSSelectorFromString(@"__notifySuccess:"));
    Method swizzedNotifySuccessMethod = class_getInstanceMethod(class, @selector(__quality__notifySuccess:));

    Method originNotifyInitMethod = class_getInstanceMethod(class, @selector(init));
    Method swizzedNotifyInitMethod = class_getInstanceMethod(class, @selector(__quality__init));
    
    method_exchangeImplementations(originNotifyInitMethod, swizzedNotifyInitMethod);
    method_exchangeImplementations(originNotifyErrorMethod, swizzedNotifyErrorMethod);
    method_exchangeImplementations(originNotifySuccessMethod, swizzedNotifySuccessMethod);
}

- (void)__quality__notifyError:(NSError *)error {
    [self __quality__notifyError:error];
    if ([QCloudCOSSMHConfig canSMHUploadBeacon]) {
        if (!error.userInfo[@"code"] && !error.userInfo[@"Code"] && !error.userInfo[@"message"] && !error.userInfo[@"Message"]) {
            NSMutableDictionary * muserinfo = error.userInfo.mutableCopy;
            muserinfo[@"Code"] = @(error.code);
            muserinfo[@"Message"] = error.localizedDescription?:@"未知错误";
            [error setValue:muserinfo forKey:@"userInfo"];
        }
        [QualityDataUploader trackSDKRequestFailWithRequest:self error:error params:[self commonParams]];
    }
}

- (void)__quality__notifySuccess:(id)object {
    [self __quality__notifySuccess:object];
    if ([QCloudCOSSMHConfig canSMHUploadBeacon]) {
        [QualityDataUploader trackSDKRequestSuccessWithRequest:self params:[self commonParams]];
    }
}

-(void)startBeacon{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![QCloudCOSSMHConfig isDisableSMHStartBeacon]) {
            [QualityDataUploader startWithAppkey:kSMHQCloudUploadAppReleaseKey];
        }
    });
}

-(NSMutableDictionary *)commonParams{
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    if ([self isMemberOfClass:[QCloudSMHBizRequest class]]) {
        params[kSMHQCloudQualityUserIdKey] = ((QCloudSMHBizRequest *)self).userId?:@"";
        params[kSMHQCloudQualityspaceIdKey] = ((QCloudSMHBizRequest *)self).spaceId?:@"";
        
    }
    
    if ([self isMemberOfClass:[QCloudSMHUserBizRequest class]]) {
        params[kSMHQCloudQualityOrganizationIdKey] = ((QCloudSMHUserBizRequest *)self).organizationId?:@"";
    }
    
    if ([NSStringFromClass(self.class) isEqualToString:@"QCloudCOSSMHUploadObjectRequest"]) {
        NSURL * body = [self valueForKey:@"body"];
        if ([body isKindOfClass:[NSURL class]]) {
            NSURL * localUrl = body;
            params[kSMHQCloudQualitylocalPathKey] = localUrl.absoluteString;

        }
        
        NSString * uploadPath = [self valueForKey:@"uploadPath"];
        params[kSMHQCloudQualitysmhKeyKey] = uploadPath?:@"";
    }
    
    if ([NSStringFromClass(self.class) isEqualToString:@"QCloudSMHDownloadFileRequest"]) {
        
        NSURL * downloadingURL = [self valueForKey:@"downloadingURL"];
        if ([downloadingURL isKindOfClass:[NSURL class]]) {
            params[kSMHQCloudQualitylocalPathKey] = downloadingURL.absoluteString?:@"";
        }
        NSString * filePath = [self valueForKey:@"filePath"];
        params[kSMHQCloudQualitysmhKeyKey] = filePath?:@"";
    }
    
    params[kQCloudRequestAppkeyKey] = kSMHQCloudUploadAppReleaseKey;
    params[@"pName"] = @"smh";
    params[@"sdkVersion"] = QCloudCOSSMHModuleVersion;
    params[@"sdkVersionName"] = @(QCloudCOSSMHModuleVersionNumber);
    return params;
}
@end
