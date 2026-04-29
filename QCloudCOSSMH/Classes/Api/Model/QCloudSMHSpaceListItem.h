//
//  QCloudSMHSpaceListItem.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 租户空间列表项（对应 listSpace 响应中 list 数组元素）
@interface QCloudSMHSpaceListItem : NSObject
/** 租户空间 ID */
@property (nonatomic, strong) NSString *spaceId;
/** 创建者用户 ID */
@property (nonatomic, strong) NSString *userId;
/** 租户空间创建时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *creationTime;
@end
NS_ASSUME_NONNULL_END
