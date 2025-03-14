//
//  QCloudSMHFavoriteTypeEnum.m
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHFavoriteTypeEnum.h"

QCloudSMHFavoriteType QCloudSMHFavoriteTypeDumpFromString(NSString *key){
    if ([key isEqualToString:@"file"]) {
        return QCloudSMHFavoriteTypeFile;
    }else if ([key isEqualToString:@"dir"]){
        return QCloudSMHFavoriteTypeDirectory;
    }
    return QCloudSMHFavoriteTypeFile;
}

NSString *  QCloudSMHFavoriteTypeTransferToString( QCloudSMHFavoriteType type){
switch (type) {
        case QCloudSMHFavoriteTypeFile:
        return @"file";
        case QCloudSMHFavoriteTypeDirectory:
        return @"dir";
    }
}
