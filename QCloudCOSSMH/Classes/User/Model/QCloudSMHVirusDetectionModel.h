//
//  QCloudSMHVirusDetectionModel.h
//  Pods-QCloudSMHDemo
//
//  Created by garenwang on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHVirusDetectionInput: NSObject
@property (nonatomic,strong) NSString *spaceId;
@property (nonatomic,strong) NSArray *path;
@end

@interface QCloudSMHListVirusDetectionInput: NSObject
@property (nonatomic,strong) NSString *spaceId;
@property (nonatomic,assign) BOOL includeChildSpace;
@end

@interface QCloudVirusDetectionFileList : NSObject

/// 文件所在空间id
@property (nonatomic, assign) NSInteger totalNum;

/// 字符串或整数，用于顺序列出分页的标识；
@property (nonatomic, assign) NSInteger nextMarker;

/// 文件path
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *> * contents;

@end
NS_ASSUME_NONNULL_END
