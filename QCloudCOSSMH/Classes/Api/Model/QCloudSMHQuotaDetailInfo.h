//
//  QCloudSMHQuotaDetailInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 租户配额详情信息（对应 getQuotaInfo 响应）
@interface QCloudSMHQuotaDetailInfo : NSObject
/** 配额所使用的空间 ID 集合 */
@property (nonatomic, strong) NSArray<NSString *> *spaces;
/** 配额的具体值，单位为字节（Byte），字符串形式 */
@property (nonatomic, strong) NSString *capacity;
@end
NS_ASSUME_NONNULL_END
