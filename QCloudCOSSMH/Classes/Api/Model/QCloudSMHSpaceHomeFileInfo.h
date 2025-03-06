//
//  QCloudSMHSpaceHomeFileInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN
@class QCloudSMHSpaceHomeFileInfoItem;
@interface QCloudSMHSpaceHomeFileInfo : NSObject
@property (nonatomic, strong) NSString* nextMarker;
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *>* contents;
@end

NS_ASSUME_NONNULL_END
