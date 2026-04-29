//
//  QCloudSMHCreateShareResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/24.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 分享域名配置
@interface QCloudSMHShareDomainInfo : NSObject
/** 分享域名列表 */
@property (nonatomic, strong) NSArray<NSString *> *shareDomain;
@end

/// 创建/更新分享的响应结果
@interface QCloudSMHCreateShareResult : NSObject
/** 分享 ID */
@property (nonatomic, strong) NSString *identifier;
/** 分享码，用于访问分享链接 */
@property (nonatomic, strong) NSString *code;
/** 分享访问端点 URL */
@property (nonatomic, strong) NSString *endpoint;
/** 创建时间 */
@property (nonatomic, strong) NSString *createTime;
/** 过期时间 */
@property (nonatomic, strong) NSString *expireTime;
/** 是否为永久分享 */
@property (nonatomic, assign) BOOL isPermanent;
/** 分享域名配置 */
@property (nonatomic, strong) QCloudSMHShareDomainInfo *domain;
@end
NS_ASSUME_NONNULL_END
