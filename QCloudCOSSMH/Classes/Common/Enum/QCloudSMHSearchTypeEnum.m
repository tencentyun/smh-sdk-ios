//
//  QCloudSMHSearchTypeEnum.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import "QCloudSMHSearchTypeEnum.h"

NSString * QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchType type){
    switch (type) {
        case QCloudSMHSearchTypeAll:
            return @"all";
        case QCloudSMHSearchTypeDir:
            return @"dir";
        case QCloudSMHSearchTypeFile:
            return @"file";
        case QCloudSMHSearchTypeDoc:
            return @"doc";
        case QCloudSMHSearchTypeXls:
            return @"xls";
        case QCloudSMHSearchTypePpt:
            return @"ppt";
        case QCloudSMHSearchTypeTxt:
            return @"txt";
        case QCloudSMHSearchTypePdf:
            return @"pdf";
        case QCloudSMHSearchTypeVideo:
            return @"video";
        case QCloudSMHSearchTypeAudio:
            return @"audio";
        case QCloudSMHSearchTypeImage:
            return @"image";
        case QCloudSMHSearchTypePowerPoint:
            return @"powerpoint";
        case QCloudSMHSearchTypeExcel:
            return @"excel";
        case QCloudSMHSearchTypeWord:
            return @"word";
        default:
            break;
    }
    return nil;
}

