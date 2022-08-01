//
//  QCloudSMHDynamicEnum.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/27.
//

#import "QCloudSMHDynamicEnum.h"

//download 下载
//preview 预览
//delete 删除
//move 移动
//rename 重命名
//copy 复制
//create 新建
//update 更新
//restore 还原 111111
NSArray * QCloudSMHDynamicActionDetailTypeTransferToString(QCloudSMHDynamicActionDetailType type){
    
    NSMutableArray * types = NSMutableArray.new;
    
    if(QCloudSMHDynamicActionDetailDownload & type){
        [types addObject:@"download"];
    }
    if(QCloudSMHDynamicActionDetailPreview & type){
        [types addObject:@"preview"];
    }
    if(QCloudSMHDynamicActionDetailDelete & type){
        [types addObject:@"delete"];
    }
    if(QCloudSMHDynamicActionDetailMove & type){
        [types addObject:@"move"];
    }
    if(QCloudSMHDynamicActionDetailRename & type){
        [types addObject:@"rename"];
    }
    if(QCloudSMHDynamicActionDetailCopy & type){
        [types addObject:@"copy"];
    }
    if(QCloudSMHDynamicActionDetailCreate & type){
        [types addObject:@"create"];
    }
    if(QCloudSMHDynamicActionDetailUpdate & type){
        [types addObject:@"update"];
    }
    if(QCloudSMHDynamicActionDetailRestore & type){
        [types addObject:@"restore"];
    }
    return types;
}

QCloudSMHDynamicActionDetailType QCloudSMHDynamicActionDetailTypeFromString(NSString * type){
    
    if([type isEqualToString:@"download"]){
        return QCloudSMHDynamicActionDetailDownload;
    }
    if([type isEqualToString:@"preview"]){
        return QCloudSMHDynamicActionDetailPreview;
    }
    if([type isEqualToString:@"delete"]){
        return QCloudSMHDynamicActionDetailDelete;
    }
    if([type isEqualToString:@"move"]){
        return QCloudSMHDynamicActionDetailMove;
    }
    if([type isEqualToString:@"rename"]){
        return QCloudSMHDynamicActionDetailRename;
    }
    if([type isEqualToString:@"copy"]){
        return QCloudSMHDynamicActionDetailCopy;
    }
    if([type isEqualToString:@"create"]){
        return QCloudSMHDynamicActionDetailCreate;
    }
    if([type isEqualToString:@"update"]){
        return QCloudSMHDynamicActionDetailUpdate;
    }
    if([type isEqualToString:@"restore"]){
        return QCloudSMHDynamicActionDetailRestore;
    }
    
    return QCloudSMHDynamicActionDetailDownload;
    
}

NSString * QCloudSMHDDynamicLogTypeTransferToString(QCloudSMHDynamicLogType type){
    if (type == QCloudSMHDynamicLogAPI) {
        return @"api";
    }
    if (type == QCloudSMHDynamicLogUser) {
        return @"user";
    }
    return @"";
}

QCloudSMHDynamicLogType  QCloudSMHDDynamicLogTypeFromString(NSString * type){
    
    if ([type isEqualToString:@"api"] ) {
        return QCloudSMHDynamicLogAPI;
    }
    
    if ([type isEqualToString:@"user"]) {
        return QCloudSMHDynamicLogUser;
    }
    return QCloudSMHDynamicLogAPI;
}

NSString * QCloudSMHDDynamicActionTypeTransferToString(QCloudSMHDynamicActionType type){
    
    NSString * typeString = @"";
    if(type == QCloudSMHDynamicTypeLogin){
        typeString = @"Login";
    }
    if(type == QCloudSMHDynamicTypeUserManagement){
        typeString = @"UserManagement";
    }
    if(type == QCloudSMHDynamicTypeTeamManagement){
        typeString = @"TeamManagement";
    }
    if(type == QCloudSMHDynamicTypeShareManagement){
        typeString = @"ShareManagement";
    }
    if(type == QCloudSMHDynamicTypeAuthorityAction){
        typeString = @"AuthorityAction";
    }
    if(type == QCloudSMHDynamicTypeFileAction){
        typeString = @"FileAction";
    }
    if(type == QCloudSMHDynamicTypeSyncAction){
        typeString = @"SyncAction";
    }
    return typeString;
}

QCloudSMHDynamicActionType QCloudSMHDDynamicActionTypeFromString(NSString * type){
    
    
    if([type isEqualToString:@"Login"]){
        return QCloudSMHDynamicTypeLogin;
    }
    if([type isEqualToString:@"UserManagement"]){
        return QCloudSMHDynamicTypeUserManagement;
    }
    if([type isEqualToString:@"TeamManagement"]){
        return QCloudSMHDynamicTypeTeamManagement;
    }
    if([type isEqualToString:@"ShareManagement"]){
        return QCloudSMHDynamicTypeShareManagement;
    }
    if([type isEqualToString:@"AuthorityAction"]){
        return QCloudSMHDynamicTypeAuthorityAction;
    }
    if([type isEqualToString:@"FileAction"]){
        return QCloudSMHDynamicTypeFileAction;
    }
    if([type isEqualToString:@"SyncAction"]){
        return QCloudSMHDynamicTypeSyncAction;
    }
    return QCloudSMHDynamicTypeLogin;
}


NSString * QCloudSMHDDynamicObjectTypeTransferToString(QCloudSMHDynamicObjectType type){
    NSString * typeString = @"";
    if(type == QCloudSMHDynamicObjectTypeUser){
        typeString = @"user";
    }
    if(type == QCloudSMHDynamicObjectTypeTeam){
        typeString = @"team";
    }
    if(type == QCloudSMHDynamicObjectTypeOrganization){
        typeString = @"organization";
    }
   
    return typeString;
}

QCloudSMHDynamicObjectType QCloudSMHDDynamicObjectTypeFromString(NSString * type){
    if([type isEqualToString:@"user"]){
        return QCloudSMHDynamicObjectTypeUser;
    }
    if([type isEqualToString:@"team"]){
        return QCloudSMHDynamicObjectTypeTeam;
    }
    if([type isEqualToString:@"organization"]){
        return QCloudSMHDynamicObjectTypeOrganization;
    }
    return QCloudSMHDynamicObjectTypeUser;
}
