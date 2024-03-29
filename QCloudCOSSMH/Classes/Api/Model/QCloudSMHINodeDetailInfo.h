//
//  QCloudSMHINodeDetailInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHINodeDetailInfo : NSObject

/// [ "folderA", "1.jpg" ], // 路径 folderA/1.jpg
@property (nonatomic, strong) NSArray *path;

/// "1.jpg", // 名称
@property (nonatomic, strong) NSString *name;

/// "file", // 类型 file 或 dir
@property (nonatomic, strong) NSString *type;

/// "2020-09-22T07:44:45.000Z",
@property (nonatomic, strong) NSString *creationTime;

/// "2020-09-22T07:44:45.000Z",
@property (nonatomic, strong) NSString *modificationTime;

/// "1048576", // 大小
@property (nonatomic, strong) NSString *size;

/// "123"
@property (nonatomic, strong) NSString *crc64;

@end

NS_ASSUME_NONNULL_END
