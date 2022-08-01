//
//  QCloudSpaceTagEnum.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QCloudSpaceTagEnum) {
    QCloudSpaceTag_None = 0,
    QCloudSpaceTag_Personal,
    QCloudSpaceTag_Team,
    QCloudSpaceTag_Group
};
QCloudSpaceTagEnum  QCloudSMHQCloudSpaceTagFromString(NSString *key);
NSString *  QCloudSMHQCloudSpaceTagTransferToString( QCloudSpaceTagEnum type);
