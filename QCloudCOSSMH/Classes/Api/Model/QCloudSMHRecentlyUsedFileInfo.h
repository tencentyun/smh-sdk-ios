//
//  QCloudSMHRecentlyUsedFileInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QCloudSMHRecentlyUsedFileInfoItem;
@interface QCloudSMHRecentlyUsedFileInfo : NSObject
@property (nonatomic, strong) NSString* nextMarker;
@property (nonatomic, strong) NSArray <QCloudSMHRecentlyUsedFileInfoItem *>* contents;
@end

@interface QCloudSMHRecentlyUsedFileInfoItem : NSObject

// 文档名称
@property (nonatomic, strong) NSString * name;

// 文档所在空间
@property (nonatomic, strong) NSString * spaceId;

// 文档 ID
@property (nonatomic, strong) NSString * inode;

// 文档大小
@property (nonatomic, strong) NSString * size;

// 操作类型
@property (nonatomic, strong) NSString * actionType;

// 操作时间
@property (nonatomic, strong) NSString * operationTime;

// 路径
@property (nonatomic, strong) NSArray <NSString *> * path;

@end
NS_ASSUME_NONNULL_END
