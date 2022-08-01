//
//  QCloudSMHGetYufuLoginAddressRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/7/06.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 根据玉符租户 ID，获取单点登录云盘地址。
 */
@interface QCloudSMHGetYufuLoginAddressRequest : QCloudSMHBaseRequest

/**
 玉符租户 ID，字符串，必选参数，和 Domain 二选一；
 */
@property (nonatomic,strong)NSString * tenantName;

/**
 企业自定义域名，字符串，必选参数，和 TenantName 二选一；
 */
@property (nonatomic,strong)NSString * domain;

/**
 玉符登录类型，字符串，必选参数，值为：domain 或 tenantName；
 */
@property (nonatomic,assign)QCloudSMHYufuLoginType type;

/**
 是否自动跳转，可选参数，默认 true；
 */
@property (nonatomic,assign)BOOL autoRedirect;

- (void)setFinishBlock:(void (^)(NSString * _Nullable location, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
