//
//  QCloudSMHINodeDetailInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHINodeDetailInfo : NSObject

/// 字符串数组，文件目录路径；
@property (nonatomic, strong) NSArray *path;

/// 字符串，文件目录名称；
@property (nonatomic, strong) NSString *name;


/// type: 字符串，文件目录类型：
///     dir: 目录或相簿；
///     file: 文件，仅用于文件类型媒体库；
@property (nonatomic, assign) QCloudSMHContentInfoType type;

///  文件目录创建时间；
@property (nonatomic, strong) NSString *creationTime;

///  文件最近一次被覆盖的时间，或者目录内最近一次增删子目录或文件的时间；
@property (nonatomic, strong) NSString *modificationTime;

/// 媒体类型；
@property (nonatomic, strong) NSString *contentType;

/// size: 文件目录大小，非必返；
@property (nonatomic, strong) NSString *size;

/// 文件的 CRC64-ECMA182 校验值，为了避免数字精度问题，这里为字符串格式；
@property (nonatomic, strong) NSString *crc64;

@end

NS_ASSUME_NONNULL_END
