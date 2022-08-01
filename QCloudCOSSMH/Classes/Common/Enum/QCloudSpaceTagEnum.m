//
//  QCloudSpaceTagEnum.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/25.
//

#import "QCloudSpaceTagEnum.h"


QCloudSpaceTagEnum  QCloudSMHQCloudSpaceTagFromString(NSString *key){
    if ([key isEqualToString:@"personal"]) {
        return QCloudSpaceTag_Personal;
    }else if ([key isEqualToString:@"team"]){
        return QCloudSpaceTag_Team;
    }else if ([key isEqualToString:@"group"]){
        return QCloudSpaceTag_Group;
    }
    return QCloudSpaceTag_None;
}
NSString *  QCloudSMHQCloudSpaceTagTransferToString( QCloudSpaceTagEnum type){
    switch (type) {
        case QCloudSpaceTag_Personal:
            return @"personal";
        case QCloudSpaceTag_Team:
            return @"dir";
        case QCloudSpaceTag_Group:
            return @"group";
        case QCloudSpaceTag_None:
            return @"";
    }
}
