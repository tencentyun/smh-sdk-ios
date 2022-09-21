//
//  QCloudSMHMessageTypeEnum.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHMessageTypeEnum.h"

QCloudSMHMessageLinkType  QCloudSMHMessageLinkTypeFromString(NSString *key){
    if ([key isEqualToString:@"outside"]){
        return QCloudSMHMessageLinkOutside;
    }else if([key isEqualToString:@"inside-background-management"]){
        return QCloudSMHMessageLinkInsideBackgroundManagement;
    }else{
        return QCloudSMHMessageLinkNone;
    }
}

QCloudSMHMessageTypeDetail  QCloudSMHMessageTypeDetailFromString(NSString *key){
    if ([key isEqualToString:@"authorityAndSettingMsg"]){
        return QCloudSMHMessageTypeAuthorityAndSettingMsg;
    }else if ([key isEqualToString:@"shareMsg"]){
        return QCloudSMHMessageTypeShareMsg;
    }else if ([key isEqualToString:@"esignMsg"]){
        return QCloudSMHMessageTypeEsignMsg;
    }else if ([key isEqualToString:@"userManageMsg"]){
        return QCloudSMHMessageTypeUserManageMsg;
    }else{
        return QCloudSMHMessageTypeQuotaAndRenewMsg;
    }

}

QCloudSMHMessageIconType  QCloudSMHMessageIconTypeFromString(NSString *key){
    if ([key isEqualToString:@"add-circle"]){
        return QCloudSMHMessageIconTypeAdd;
    }else if ([key isEqualToString:@"minus-circle"]){
        return QCloudSMHMessageIconTypeMinus;
    }else if ([key isEqualToString:@"warn-circle"]){
        return QCloudSMHMessageIconTypeWarn;
    }else{
        return QCloudSMHMessageIconTypeOther;
    }
}
