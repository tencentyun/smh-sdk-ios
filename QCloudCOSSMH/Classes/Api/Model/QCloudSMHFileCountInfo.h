//
//  QCloudSMHFileCountInfo.h
//  QCloudCOSSMH
//
//  Created by qinghaochen on 2023/10/30.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHFileCountInfo : NSObject

/// 总文件数量（包括回收站和历史版本）
@property (nonatomic, assign) NSString *fileNum;

/// 总文件夹数量（包括回收站)
@property (nonatomic, assign) NSString *dirNum;

/// 回收站文件数量
@property (nonatomic, assign) NSString *recycledFileNum;

/// 回收站文件夹数量
@property (nonatomic, assign) NSString *recycledDirNum;

/// 历史版本文件数量
@property (nonatomic, assign) NSString *historyFileNum;

@end

NS_ASSUME_NONNULL_END
