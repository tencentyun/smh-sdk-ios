//
//  QCloudSMHTestTools.m
//  QCloudSMHDemoTests
//
//  Created by garenwang on 2022/5/11.
//

#import "QCloudSMHTestTools.h"

@interface QCloudSMHTestTools()

@property(nonatomic, strong) NSDictionary *smhTokenDicV1;

@property(nonatomic, strong) NSDictionary *smhTokenDicV2;

@end

@implementation QCloudSMHTestTools

+(instancetype)singleTool{
    static QCloudSMHTestTools * tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[QCloudSMHTestTools alloc]init];
    });
    return tools;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _smhTokenDicV1 = [self readJSONFileFromRootDirectory:@"SMHTokenV1" ofType:@"geojson"];
        _smhTokenDicV2 = [self readJSONFileFromRootDirectory:@"SMHTokenV2" ofType:@"geojson"];
    }
    return self;
}

+(NSString *)getTestPhone{
    return @"15929443992";
}
+(NSString *)getTestDefautlVerificationCode{
    return @"449030";
}
+(NSString *)getTestCountryCode{
    return @"+86";
}

-(NSString *)getUserToken{
    return @"f8304b5d74c24f2930e0af31482b141c9d50a73c9da2fa354b8f248c5c0b7d31eebf5bec68eba15bcf6ee8905e162a4b7db3e633ad9c9b565b8a6b3eaf8aa065";
}

-(NSString *)getOrgnizationId{
    return @"1";
}

#pragma mark - v1 接口
-(NSString *)getUserIdV1{
    return _smhTokenDicV1[@"user_id"] ?: @"";
}

- (NSString *)getBaseUrlStrV1 {
    return _smhTokenDicV1[@"base_url"] ?: @"";
}

-(NSString *)getAccessTokenV1{
    return _smhTokenDicV1[@"accessToken"] ?: @"";
}
-(NSString *)getSpaceIdV1{
    NSString *spaceId = _smhTokenDicV1[@"space_id"];
    if (spaceId == nil || spaceId.length == 0) {
        return @"-";
    }
    return spaceId;
}
-(NSString *)getLibraryIdV1{
    return  _smhTokenDicV1[@"library_id"] ?: @"";
}

#pragma mark - v2 接口

-(NSString *)getUserIdV2{
    return _smhTokenDicV2[@"user_id"] ?: @"";
}

- (NSString *)getBaseUrlStrV2 {
    return _smhTokenDicV2[@"base_url"] ?: @"";
}

-(NSString *)getAccessTokenV2{
    return _smhTokenDicV2[@"accessToken"] ?: @"";
}
-(NSString *)getSpaceIdV2{
    NSString *spaceId = _smhTokenDicV2[@"space_id"];
    if (spaceId == nil || spaceId.length == 0) {
        return @"-";
    }
    return spaceId;
}
-(NSString *)getLibraryIdV2{
    return  _smhTokenDicV2[@"library_id"] ?: @"";
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

#pragma mark - 读取json文件
- (NSDictionary *)readJSONFileFromRootDirectory:(NSString *)fileName ofType:(NSString *)fileType {
    // 1. 参数安全检查
    if (!fileName || fileName.length == 0) {
        NSLog(@"❌ 错误：文件名不能为空");
        return nil;
    }
    
    // 设置默认文件类型为json
    NSString *type = fileType ?: @"json";
    
    // 2. 获取JSON文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    if (!filePath) {
        NSLog(@"❌ 错误：未找到文件 '%@.%@'，请检查文件名是否正确且文件已添加到项目Target中", fileName, type);
        return nil;
    }
    
    // 3. 读取文件内容为NSData
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
    if (error || !jsonData) {
        NSLog(@"❌ 读取文件失败：%@", error.localizedDescription);
        return nil;
    }
    
    // 4. 解析JSON数据
    error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
    if (error) {
        NSLog(@"❌ JSON解析失败：%@", error.localizedDescription);
        return nil;
    }
    
    NSLog(@"✅ JSON文件读取成功");
    return jsonDict;
}


@end
