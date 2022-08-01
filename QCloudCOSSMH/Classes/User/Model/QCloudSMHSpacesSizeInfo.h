//
//  QCloudSMHSpacesSizeInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 空间信息
 */
@interface QCloudSMHSpacesSizeInfo : NSObject

/// 是否分配有个人空间；
@property (nonatomic, strong) NSString *hasPersonalSpace;

/// 字符串或 null，个人空间存储额度，单位 Byte，如果为 null 则共享组织剩余未分配存储额度；
@property (nonatomic, strong) NSString *capacity;

/// 字符串或 null，个人空间剩余可使用存储额度，单位 Byte，如果为 null 则共享组织剩余未分配存储额度；
@property (nonatomic, strong) NSString *availableSpace;

/// 字符串，个人空间已使用存储额度，单位 Byte
@property (nonatomic, strong) NSString *size;
@end

/**
 查询组织空间总使用量
 */
@interface QCloudSMHOrgSpacesSizeInfo : NSObject

/// 组织总存储额度，单位 Byte，如果为 null 则无存储额度限制
@property (nonatomic, strong) NSString *capacity;

/// 组织剩余可用存储额度大小，单位 Byte，如果为 null 则无限制（注：已分配额度的空间，不论使用与否都将占用组织可用存储额度大小）
@property (nonatomic, strong) NSString *availableSpace;

/// 组织分配给空间的总存储额度，单位 Byte
@property (nonatomic, strong) NSString *totalAllocatedSpaceQuota;

/// 组织已上传文件占用的存储额度，单位 Byte
@property (nonatomic, strong) NSString *totalFileSize;

@end

NS_ASSUME_NONNULL_END
