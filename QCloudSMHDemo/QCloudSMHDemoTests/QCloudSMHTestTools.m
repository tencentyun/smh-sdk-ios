//
//  QCloudSMHTestTools.m
//  QCloudSMHDemoTests
//
//  Created by garenwang on 2022/5/11.
//

#import "QCloudSMHTestTools.h"

@implementation QCloudSMHTestTools

+(instancetype)singleTool{
    static QCloudSMHTestTools * tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[QCloudSMHTestTools alloc]init];
    });
    return tools;
}

+(NSString *)getTestPhone{
    return @"18888888888";
}
+(NSString *)getTestDefautlVerificationCode{
    return @"21941";
}
+(NSString *)getTestCountryCode{
    return @"+86";
}

-(NSString *)getUserToken{
    if (self.organizationsInfo.userToken) {
        return self.organizationsInfo.userToken;
    }
    return @"f0ab4b1b395c7da885f3792666051c145ddca33b9def79582cc0c7c9bd3f7290ef6e66fe3a049e852f4071eb2bfb59be1938a17ada289248422abf0158e25b0a";
}
-(NSString *)getLibraryId{
    
    return @"smh08gcw6500e6jl";
    if (self.organizationsInfo.organizations.firstObject.libraryId) {
        return self.organizationsInfo.organizations.firstObject.libraryId;
    }
}

-(NSString *)getOrgnizationId{
    if (self.organizationsInfo.organizations.firstObject.organizationID) {
        return self.organizationsInfo.organizations.firstObject.organizationID;
    }
    return @"1";
}

-(NSString *)getUserId{
    if (self.organizationsInfo.userId) {
        return self.organizationsInfo.userId;
    }
//    return @"30";
    return @"59";
}
-(NSString *)getSpaceId{
    return @"space30mh65tpqrv5f";
    if (self.spaceInfo.spaceId) {
        return self.spaceInfo.spaceId;
    }
}
-(NSString *)getAccessToken{
    return @"acctk02e057bfccm7opso8xcjj8d43blygezrwfluv7fzbsflbqwqlst75mpp5rzt6uwjf6ebcs2ezb9aghn8cdz9m7zexcpszvfcx8wfaa22zvmbzchg4gtb3dc7839";
    if (self.spaceInfo.accessToken) {
        return self.spaceInfo.accessToken;
    }
}

+ (NSString *)tempFileWithSize:(int)size {
    NSString *file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);

    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:size];
    [handler closeFile];

    return file4MBPath;
}
@end
