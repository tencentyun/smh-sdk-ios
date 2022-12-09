//
//  QCloudSMHCommonEnum.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/26.
//

#import "QCloudSMHCommonEnum.h"


QCloudSMHGroupRole  QCloudSMHGroupRoleFromString(NSString *key){
    if ([key isEqualToString:@"owner"]) {
        return QCloudSMHGroupRoleOwner;
    }else if ([key isEqualToString:@"groupAdmin"]) {
        return QCloudSMHGroupRoleAdmin;
    }else if ([key isEqualToString:@"user"]){
        return QCloudSMHGroupRoleUser;
    }
    return QCloudSMHGroupRoleAdmin;
}
NSString *  QCloudSMHGroupRoleTransferToString( QCloudSMHGroupRole type){
    switch (type) {
        case QCloudSMHGroupRoleOwner:
            return @"owner";
        case QCloudSMHGroupRoleAdmin:
            return @"groupAdmin";
        case QCloudSMHGroupRoleUser:
            return @"user";
        default:
            return @"";
        }
}


QCloudSMHOrganizationType  QCloudSMHOrganizationTypeFromString(NSString *key){
    if ([key isEqualToString:@"personal"]) {
        return QCloudSMHOrganizationTypePersonal;
    }else if ([key isEqualToString:@"team"]) {
        return QCloudSMHOrganizationTypeTeam;
    }else if ([key isEqualToString:@"enterprise"]){
        return QCloudSMHOrganizationTypeEnterprise;
    }
    return QCloudSMHOrganizationTypePersonal;
}

NSString *  QCloudSMHOrganizationTypeTransferToString( QCloudSMHOrganizationType type){
    switch (type) {
        case QCloudSMHOrganizationTypePersonal:
            return @"personal";
        case QCloudSMHOrganizationTypeTeam:
            return @"team";
        case QCloudSMHOrganizationTypeEnterprise:
            return @"enterprise";
        default:
            return @"";
        }
}

//'superAdmin' | 'admin' | 'user'
QCloudSMHOrgUserRole  QCloudSMHOrgUserRoleTypeFromString(NSString *key){
    if ([key isEqualToString:@"superAdmin"]) {
        return QCloudSMHOrgUserRoleSuperAdmin;
    }else if ([key isEqualToString:@"admin"]) {
        return QCloudSMHOrgUserRoleAdmin;
    }else if ([key isEqualToString:@"user"]){
        return QCloudSMHOrgUserRoleUser;
    }
    return QCloudSMHOrgUserRoleOther;
}

NSString *  QCloudSMHOrgUserRoleTypeTransferToString( QCloudSMHOrgUserRole type){
    switch (type) {
        case QCloudSMHOrgUserRoleSuperAdmin:
            return @"superAdmin";
        case QCloudSMHOrgUserRoleAdmin:
            return @"admin";
        case QCloudSMHOrgUserRoleUser:
            return @"user";
        default:
            return @"";
        }
}

QCloudSMHLoginAuthType QCloudSMHLoginAuthTypeFromString(NSString *key){
    if ([key isEqualToString:@"web"]) {
        return QCloudSMHLoginAuthWeb;
    }else if ([key isEqualToString:@"mobile"]) {
        return QCloudSMHLoginAuthMobile;
    }
    return QCloudSMHLoginAuthOther;
}
NSString *  QCloudSMHLoginAuthTypeTransferToString( QCloudSMHLoginAuthType type){
    switch (type) {
        case QCloudSMHLoginAuthWeb:
            return @"web";
        case QCloudSMHLoginAuthMobile:
            return @"mobile";
        default:
            return @"";
        }
}

NSString *  QCloudSMHPurposeTypeTransferToString( QCloudSMHPurposeType type){
    switch (type) {
        case QCloudSMHPurposeDownload:
            return @"download";
        case QCloudSMHPurposePreview:
            return @"preview";
        case QCloudSMHPurposeList:
            return @"list";
        default:
            return @"";
        }
}

NSString *  QCloudSMHUsedSenceTransferToString( QCloudSMHUsedSence type){
    switch (type) {
        case QCloudSMHUsedSencePersonal:
            return @"personal_space";
            break;
        case QCloudSMHUsedSenceTeam:
            return @"team_space";
            break;
        case QCloudSMHUsedSenceGroup:
            return @"group_space";
            break;
        default:
            break;
    }
}

NSString *  QCloudSMHFileTemplateTransferToString( QCloudSMHFileTemplate fileTemplate){
    switch (fileTemplate) {
        case QCloudSMHFileTemplateWord:
            return @"word.docx";
            break;
        case QCloudSMHFileTemplateExcel:
            return @"excel.xlsx";
            break;
        case QCloudSMHFileTemplatePPT:
            return @"powerpoint.pptx";
            break;
        default:
            return @"";
            break;
    }
}

NSString *  QCloudSMHChannnelFlagTransferToString( QCloudSMHChannnelFlag flag){
    switch (flag) {
        case QCloudSMHChannnelFlagMeeting:
            return @"meeting";
            break;
        case QCloudSMHChannnelFlagNone:
            return @"";
            break;
        default:
            return @"";
            break;
    }
}
QCloudSMHChannnelFlag QCloudSMHChannnelFlagFromString(NSString *key){
    if([key isEqualToString:@"meeting"]){
        return QCloudSMHChannnelFlagMeeting;
    }
    return QCloudSMHChannnelFlagNone;
}
