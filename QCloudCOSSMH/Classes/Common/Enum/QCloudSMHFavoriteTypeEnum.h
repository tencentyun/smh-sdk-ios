//
//  QCloudSMHFavoriteTypeEnum.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QCloudSMHFavoriteType) {
    QCloudSMHFavoriteTypeFile = 1,
    QCloudSMHFavoriteTypeDirectory,
};
QCloudSMHFavoriteType  QCloudSMHFavoriteTypeDumpFromString(NSString *key);
NSString *  QCloudSMHFavoriteTypeTransferToString( QCloudSMHFavoriteType type);
