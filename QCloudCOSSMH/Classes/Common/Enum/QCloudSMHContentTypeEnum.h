//
//  QCloudContentTypeEnum.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudSMHContentInfoType) {
    QCloudSMHContentInfoTypeOther = 0,
    QCloudSMHContentInfoTypeImage,
    QCloudSMHContentInfoTypeWord ,
    QCloudSMHContentInfoTypePPT,
    QCloudSMHContentInfoTypeExcel,
    QCloudSMHContentInfoTypePDF,
    QCloudSMHContentInfoTypeTXT,
    QCloudSMHContentInfoTypeAudio,
    QCloudSMHContentInfoTypeVideo,
    QCloudSMHContentInfoTypeFile,
    QCloudSMHContentInfoTypeArchive,
    QCloudSMHContentInfoTypeDir
   
   
};
QCloudSMHContentInfoType QCloudSMHContentInfoTypeDumpFromString(NSString *key);
NSString * QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoType type);
NS_ASSUME_NONNULL_END
