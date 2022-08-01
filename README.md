## 准备工作

1. 您需要一个 iOS 应用，这个应用可以是您现有的工程，也可以是您新建的一个空的工程。
2. 请确保您的 iOS 应用目标为 iOS 9及以上。


## 第一步：安装 SDK

## pod集成

sdk分为四个模块，可以按照项目实际需求集成相应模块，推荐集成sdk完整功能。
|名称| 功能描述 | 集成 |
|:-----| :-----| :---- |
|Default| sdk完整功能，包括Api、User、灯塔数据收集三个模块 | pod "QCloudCOSSMH" |
|Slim|Api、User模块，排除灯塔数据收集模块 | pod "QCloudCOSSMH/Slim" |
|Api| Api模块 | pod "QCloudCOSSMH/Api" |
|User| User模块 | pod "QCloudCOSSMH/User" |

## 第二步：开始使用
#### 1. 导入头文件
Default 和 Slim
```
#import <QCloudCOSSMH.h>
```
Api
```
#import <QCloudCOSSMHApi.h>
```
User
```
#import <QCloudCOSSMHUser.h>
```
#### 2. 初始化 SMH 服务并实现获取accessToken协议（User模块不需要accesstoken，若仅使用User,可以跳过此步骤）
>?集成了 Api和User时 获取accessToken的方式。

Api模块接口在发出请求时需要携带accesstoken，所以需要实现QCloudSMHAccessTokenProvider协议，在该协议中获取包含accesstoken以及spaceid等信息的QCloudSMHSpaceInfo对象通过参数continueBlock 回调给 SDK。
```
- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    if (!request.spaceId.length) {
            // 获取用户个人空间的accesstoken，若用户只有个人空间时，没有spaceid，因此需要调用该接口。
            QCloudSMHGetAccessTokenRequest *getAccessToken = [QCloudSMHGetAccessTokenRequest new];

            getAccessToken.priority = QCloudAbstractRequestPriorityHigh;

            // 用户所在组织id
            getAccessToken.organizationId = @"organizationId";

            // User模块中登录接口返回
            getAccessToken.userToken = @"userToken";

            [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
                continueBlock(outputObject, error);
            }];
            // 发起请求
            [[QCloudSMHUserService defaultSMHUserService] getAccessToken:getAccessToken];
        }else{
            // 根据spaceid获取指定空间accesstoken。
            QCloudSMHGetSpaceAccessTokenRequest *getAccessToken = [QCloudSMHGetSpaceAccessTokenRequest new];
            getAccessToken.priority = QCloudAbstractRequestPriorityHigh;
            // // 用户所在组织id
            getAccessToken.organizationId = @"organizationId";

            // User模块中登录接口返回
            getAccessToken.userToken = @"userToken";

            // 空间id
            getAccessToken.spaceId = request.spaceId;

            // 空间所在组织id，当前用户需要访问外部组织的空间时，需要设置该参数
            getAccessToken.spaceOrgId = request.spaceOrgId;

            [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
                continueBlock(outputObject, error);
            }];
            [[QCloudSMHUserService defaultSMHUserService] getSpaceAccessToken:getAccessToken];
        }
}
```

SDK 提供了一个 QCloudSMHAccessTokenFenceQueue 的脚手架，实现对accessToken的缓存与复用。脚手架在密钥过期之后会重新调用该协议的方法来重新获取新的密钥，直到该密钥过期时间大于设备的当前时间。
>?建议把初始化过程放在 AppDelegate 或者程序单例中。

使用脚手架您需要实现`QCloudAccessTokenFenceQueueDelegate`协议。
    
初始化脚手架
```
@property (nonatomic) QCloudSMHAccessTokenFenceQueue *fenceQueue;

self.fenceQueue = [QCloudSMHAccessTokenFenceQueue new];
self.fenceQueue.delegate = self;
```

实现QCloudAccessTokenFenceQueueDelegate
```
- (void)fenceQueue:(QCloudSMHAccessTokenFenceQueue *)queue
           request:(QCloudSMHBizRequest *)request
requestCreatorWithContinue:(QCloudAccessTokenFenceQueueContinue)continueBlock {
    if (!request.spaceId.length) {
            // 获取用户个人空间的accesstoken，若用户只有个人空间时，没有spaceid，因此需要调用该接口。
            QCloudSMHGetAccessTokenRequest *getAccessToken = [QCloudSMHGetAccessTokenRequest new];

            getAccessToken.priority = QCloudAbstractRequestPriorityHigh;

            // 用户所在组织id
            getAccessToken.organizationId = @"organizationId";

            // User模块中登录接口返回
            getAccessToken.userToken = @"userToken";

            [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
                continueBlock(outputObject, error);
            }];
            // 发起请求
            [[QCloudSMHUserService defaultSMHUserService] getAccessToken:getAccessToken];
        }else{
            // 根据spaceid获取指定空间accesstoken。
            QCloudSMHGetSpaceAccessTokenRequest *getAccessToken = [QCloudSMHGetSpaceAccessTokenRequest new];
            getAccessToken.priority = QCloudAbstractRequestPriorityHigh;
            // // 用户所在组织id
            getAccessToken.organizationId = @"organizationId";

            // User模块中登录接口返回
            getAccessToken.userToken = @"userToken";

            // 空间id
            getAccessToken.spaceId = request.spaceId;

            // 空间所在组织id，当前用户需要访问外部组织的空间时，需要设置该参数
            getAccessToken.spaceOrgId = request.spaceOrgId;

            [getAccessToken setFinishBlock:^(QCloudSMHSpaceInfo *outputObject, NSError *_Nullable error) {
                continueBlock(outputObject, error);
            }];
            [[QCloudSMHUserService defaultSMHUserService] getSpaceAccessToken:getAccessToken];
        }
}

// 在该方法中使用脚手架进行请求sdk内部缓存的accesstoken并使用continueBlock回调给sdk，若
// sdk内缓存的accesstoken过期或没有，则跳转到上面方法中进行请求最新的accesstoken回调给sdk并缓存。
- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                   urlRequest:(NSURLRequest *)urlRequst
                    compelete:(QCloudSMHAuthentationContinueBlock)continueBlock {
    [self.fenceQueue performRequest:request
                         withAction:^(QCloudSMHSpaceInfo *_Nonnull accessToken, NSError *_Nonnull error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            continueBlock(accessToken, nil);
        }
    }];
}
```

>?若仅需要Api模块，则需要一个可以获取智能媒资托管服务访问令牌的业务服务端接口，关于访问令牌的有关说明请参考 (https://cloud.tencent.com/document/product/1339/71159)。

实现QCloudSMHAccessTokenProvider协议，在该协议中获取accesstoken 并包装成一个QCloudSMHSpaceInfo对象通过参数continueBlock回调给SDK。


## 第三步：访问 SMH 服务

例如：列出文件列表
```
QCloudSMHListContentsRequest *req = [QCloudSMHListContentsRequest new];
// 用户所在空间id
req.spaceId = @"spaceId";
// 用户所在libraryid
req.libraryId = @"libraryId";
// 用户id
req.userId = @"userId";

// 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
req.dirPath = @"dirpath";
[req setFinishBlock:^(QCloudSMHContentListInfo *_Nullable result, NSError *_Nullable error) {
    // result 文件列表数据
    // error 报错信息
}];
// 发起请求
[[QCloudSMHService defaultSMHService] listContents:req];
```

>?
SMH SDK提供了自定义域名的功能，若业务有自研后台，可以是用如下方式更改访问域名，按需配置。
```
// 配置发布域名    
[QCloudSMHBaseRequest setBaseRequestHost:@"releasehost" targetType:QCloudECDTargetRelease];
// 配置预发布域名    
[QCloudSMHBaseRequest setBaseRequestHost:@"previewhost" targetType:QCloudECDTargetPreview];
// 配置测试域名
[QCloudSMHBaseRequest setBaseRequestHost:@"testhost" targetType:QCloudECDTargetTest];
// 配置开发域名
[QCloudSMHBaseRequest setBaseRequestHost:@"devhost" targetType:QCloudECDTargetDevelop];
// 设置当前模式 开发、测试、预发布、发布
[QCloudSMHBaseRequest setTargetType:QCloudECDTarget];
```

## 通用参数介绍

* LibraryId: 媒体库 ID，必选参数；
* SpaceId: 空间 ID，如果媒体库为单租户模式，则该参数固定为连字符(-)；如果媒体库为多租户模式，则必须指定该参数；
* AccessToken: 访问令牌，必选参数；
* UserId: 用户身份识别，当访问令牌对应的权限为管理员权限且申请访问令牌时的用户身份识别为空时用来临时指定用户身份，详情请参阅生成访问令牌接口，可选参数；
* OrganizationId: 组织 ID，必选参数
* UserToken: 用户令牌，必选参数

>? 更多概念 请[点击查看](https://cloud.tencent.com/document/product/1339/49939)

