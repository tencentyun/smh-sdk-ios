//
//  QCloudSMHBaseRequest.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudSMHBaseRequest.h"

#define DEFAULT_API_HOST @"https://api.tencentsmh.cn/"

#define DEFAULT_USER_HOST @"https://instance.tencentsmh.cn/"

QCloudResponseSerializerBlock QCloudResponseRedirectBlock = ^(NSHTTPURLResponse *response, id inputData, NSError *__autoreleasing *error) {
    if(!response){
        return (id)nil;
    }
    return (id)(response.URL.absoluteString);
};

static QCloudSMHServerType _serverType;
static QCloudECDTargetType _targetType;
static NSString * _devHost;
static NSString * _testHost;
static NSString * _previewHost;
static NSString * _releaseHost;

static NSString * _devApiHost;
static NSString * _testApiHost;
static NSString * _previewApiHost;
static NSString * _releaseApiHost;

@interface QCloudSMHBaseRequest()

@end

@implementation QCloudSMHBaseRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
        
    }

    _customHeaders = [NSMutableDictionary dictionary];
    
    NSString * serverHost;
    if (_targetType == QCloudECDTargetRelease) {
        serverHost = _releaseHost?_releaseHost:DEFAULT_USER_HOST;
    }else if (_targetType == QCloudECDTargetDevelop){
        serverHost = _devHost ? _devHost : DEFAULT_USER_HOST;
    }else if (_targetType == QCloudECDTargetTest){
        serverHost = _testHost ? _testHost : DEFAULT_USER_HOST;
    }else if (_targetType == QCloudECDTargetPreview){
        serverHost = _previewHost ? _previewHost : DEFAULT_USER_HOST;
    }
    _serverDomain = serverHost;
    
    return self;
}

- (instancetype)initWithApiType:(QCloudECDAPIType)apiType{
    self = [super init];
    if (!self) {
        return self;
        
    }
    
    _customHeaders = [NSMutableDictionary dictionary];
    
    if (apiType == QCloudECDTargetAPIAll || apiType == QCloudECDTargetAPIUser) {
        NSString * serverHost;
        if (_targetType == QCloudECDTargetRelease) {
            serverHost = _releaseHost?_releaseHost:DEFAULT_USER_HOST;
        }else if (_targetType == QCloudECDTargetDevelop){
            serverHost = _devHost ? _devHost : DEFAULT_USER_HOST;
        }else if (_targetType == QCloudECDTargetTest){
            serverHost = _testHost ? _testHost : DEFAULT_USER_HOST;
        }else if (_targetType == QCloudECDTargetPreview){
            serverHost = _previewHost ? _previewHost : DEFAULT_USER_HOST;
        }
        _serverDomain = serverHost;
    }
    
    if (apiType == QCloudECDTargetAPIFile) {
        NSString * serverHost;
        if (_targetType == QCloudECDTargetRelease) {
            serverHost = _releaseApiHost?_releaseApiHost:DEFAULT_API_HOST;
        }else if (_targetType == QCloudECDTargetDevelop){
            serverHost = _devApiHost ? _devApiHost : DEFAULT_API_HOST;
        }else if (_targetType == QCloudECDTargetTest){
            serverHost = _testApiHost ? _testApiHost : DEFAULT_API_HOST;
        }else if (_targetType == QCloudECDTargetPreview){
            serverHost = _previewApiHost ? _previewApiHost : DEFAULT_API_HOST;
        }
        _serverDomain = serverHost;
    }
    return self;
}

+(void)setTargetType:(QCloudECDTargetType)targetType{
    _targetType = targetType;
}

+(void)setBaseRequestHost:(NSString *)host targetType:(QCloudECDTargetType)targetType{
    if (targetType == QCloudECDTargetDevelop) {
        _devHost = _devApiHost = host;
    }
    
    if (targetType == QCloudECDTargetTest) {
        _testHost = _testApiHost = host;
    }
    
    
    if (targetType == QCloudECDTargetPreview) {
        _previewHost = _previewApiHost = host;
    }
    
    if (targetType == QCloudECDTargetRelease) {
        _releaseHost = _releaseApiHost = host;
    }
    
}

+(void)setBaseRequestHost:(NSString *)host targetType:(QCloudECDTargetType)targetType apiType:(QCloudECDAPIType)apiType{
    if (apiType == QCloudECDTargetAPIAll) {
        [self setBaseRequestHost:host targetType:targetType];
        return;
    }
    
    if (apiType == QCloudECDTargetAPIFile) {
        if (targetType == QCloudECDTargetDevelop) {
            _devApiHost = host;
        }
        
        if (targetType == QCloudECDTargetTest) {
            _testApiHost = host;
        }
        
        if (targetType == QCloudECDTargetPreview) {
            _previewApiHost = host;
        }
        
        if (targetType == QCloudECDTargetRelease) {
            _releaseApiHost = host;
        }
    }
    
    if (apiType == QCloudECDTargetAPIUser) {
        if (targetType == QCloudECDTargetDevelop) {
            _devHost = host;
        }
        
        if (targetType == QCloudECDTargetTest) {
            _testHost = host;
        }
        
        if (targetType == QCloudECDTargetPreview) {
            _previewHost = host;
        }
        
        if (targetType == QCloudECDTargetRelease) {
            _releaseHost = host;
        }
    }
    
}

+(BOOL)isHttps{
    
    NSString * host;
    if (_targetType == QCloudECDTargetDevelop) {
        host = _devHost;
    }
    
    if (_targetType == QCloudECDTargetTest) {
        host = _testHost;
    }
    
    
    if (_targetType == QCloudECDTargetPreview) {
        host = _previewHost;
    }
    
    if (_targetType == QCloudECDTargetRelease) {
        host = _releaseHost;
    }
    if (!host) {
        host = DEFAULT_API_HOST;
    }
    return [[host lowercaseString] hasPrefix:@"https://"];
}

/// 获取后台为公有云还是私有云
+(QCloudSMHServerType)getServerType{
    return _serverType;
}

/// 设置后台为公有云还是私有云 默认公有云
+(void)setServerType:(QCloudSMHServerType)serverType{
    _serverType = serverType;
}

- (void)loadConfigureBlock {
    __weak typeof(self) weakSelf = self;
    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
        [weakSelf configureReuqestSerializer:requestSerializer responseSerializer:responseSerializer];
    }];
}

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    _customHeaders = [NSMutableDictionary dictionary];
    [requestSerializer setSerializerBlocks:[self customRequestSerizliers]];
    [responseSerializer setSerializerBlocks:[self customResponseSerializers]];
}
- (NSArray *)customResponseSerializers {
    return @[];
}

- (NSArray *)customRequestSerizliers {
    return @[];
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error{
    BOOL ret = [super buildRequestData:error];
    if (!ret) {
        return ret;
    }
    return YES;
}


- (BOOL)customBuildRequestData:(NSError *__autoreleasing *)error {
    return YES;
}

- (void)onError:(NSError *)error{
    [super onError:error];
    if ([error.userInfo[@"code"] isEqualToString:@"InvalidUserToken"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ECDNotificationInvalidUserToken" object:nil];
        });
    }
}

@end
