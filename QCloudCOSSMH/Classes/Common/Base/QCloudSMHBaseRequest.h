//
//  QCloudSMHBaseRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHAccessTokenProvider.h"

typedef NS_ENUM(NSUInteger, QCloudECDTargetType) {
    QCloudECDTargetRelease = 0,
    QCloudECDTargetDevelop,
    QCloudECDTargetTest,
    QCloudECDTargetPreview
};

typedef NS_ENUM(NSUInteger, QCloudECDAPIType) {
    QCloudECDTargetAPIAll = 0, // 所有
    QCloudECDTargetAPIUser, // user模块 (user_api)
    QCloudECDTargetAPIFile  // file模块（api）
};


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN QCloudResponseSerializerBlock QCloudResponseRedirectBlock;

@interface QCloudSMHBaseRequest : QCloudHTTPRequest

/*
在进行HTTP请求的时候，可以通过设置该参数来设置自定义的一些头部信息。
通常情况下，携带特定的额外HTTP头部可以使用某项功能，如果是这类需求，可以通过设置该属性来实现。
*/
@property (strong, nonatomic) NSMutableDictionary *customHeaders;

- (instancetype)initWithApiType:(QCloudECDAPIType)apiType;

/// 当前项目targettype 默认发布模式；
+(void)setTargetType:(QCloudECDTargetType)targetType;


/// 根据targettype 设置请求域名，仅支持设置开发测试模式；发布模式已内定；若不指定统一使用发布模式域名
+(void)setBaseRequestHost:(NSString *)host targetType:(QCloudECDTargetType)targetType;

/// 根据targettype 设置请求域名，仅支持设置开发测试模式；发布模式已内定；若不指定统一使用发布模式域名 ,
/// 后台接口分为api 以及 user 两个模块，若两个模块host不一致，可以分别指定
+(void)setBaseRequestHost:(NSString *)host targetType:(QCloudECDTargetType)targetType apiType:(QCloudECDAPIType)apiType;

@end

NS_ASSUME_NONNULL_END
