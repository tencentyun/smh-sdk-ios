//
//  QCloudContentTypeEnum.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//
#import "QCloudSMHContentTypeEnum.h"

QCloudSMHContentInfoType QCloudSMHContentInfoTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"file"]) {
        return QCloudSMHContentInfoTypeFile;
    } else if ([key isEqualToString:@"dir"]) {
        return QCloudSMHContentInfoTypeDir;
    } else if ([key isEqualToString:@"word"]) {
        return QCloudSMHContentInfoTypeWord;
    } else if ([key isEqualToString:@"video"]) {
        return QCloudSMHContentInfoTypeVideo;
    } else if ([key isEqualToString:@"audio"]) {
        return QCloudSMHContentInfoTypeAudio;
    } else if ([key isEqualToString:@"portable"]) {
        return QCloudSMHContentInfoTypePDF;
    } else if ([key isEqualToString:@"powerpoint"]) {
        return QCloudSMHContentInfoTypePPT;
    } else if ([key isEqualToString:@"text"]) {
        return QCloudSMHContentInfoTypeTXT;
    } else if ([key isEqualToString:@"excel"]) {
        return QCloudSMHContentInfoTypeExcel;
    } else if ([key isEqualToString:@"archive"]) {
        return QCloudSMHContentInfoTypeArchive;
    } else if ([key isEqualToString:@"image"]) {
        return QCloudSMHContentInfoTypeImage;
    }else if ([key isEqualToString:@"symlink"]) {
        return QCloudSMHContentInfoTypeSymlink;
    }
    return QCloudSMHContentInfoTypeOther;
}
NSString * QCloudSMHContentInfoTypeTransferToString(QCloudSMHContentInfoType type) {
    switch (type) {
        case QCloudSMHContentInfoTypeWord:
            return @"word";
        case QCloudSMHContentInfoTypeFile: {
            return @"file";
        }
        case QCloudSMHContentInfoTypeDir: {
            return @"dir";
        }
        case QCloudSMHContentInfoTypeImage: {
            return @"image";
        }
        case QCloudSMHContentInfoTypeVideo: {
            return @"video";
        }
        case QCloudSMHContentInfoTypeArchive:{
            return @"archive";
        }
            
        case QCloudSMHContentInfoTypeExcel:{
            return @"excel";
        }
            
        case QCloudSMHContentInfoTypeTXT:{
            return @"text";
        }
            
        case QCloudSMHContentInfoTypePPT:{
            return @"powerpoint";
        }
            
        case QCloudSMHContentInfoTypePDF:{
            return @"portable";
        }
        case QCloudSMHContentInfoTypeSymlink:{
            return @"symlink";
        }
        default:
            return @"other";
    }
}
