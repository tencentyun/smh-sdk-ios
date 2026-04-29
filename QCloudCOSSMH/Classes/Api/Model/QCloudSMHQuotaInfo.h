//
//  QCloudSMHQuotaInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 配额信息（对应 getQuota 响应）
@interface QCloudSMHQuotaInfo : NSObject
/** 配额 ID */
@property (nonatomic, assign) NSInteger quotaId;
/** 配额的具体值，单位为字节（Byte），字符串形式 */
@property (nonatomic, strong) NSString *capacity;
@end
NS_ASSUME_NONNULL_END
